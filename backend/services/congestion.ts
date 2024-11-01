/*
 * Flowmotion
 * Backend
 * Congestion Service
 */

import { AggregateField, Firestore, Query } from "firebase-admin/firestore";
import { components, paths } from "../api";
import { DateInterval, dateRange, formatSGT } from "../date";
import { add as addDate } from "date-fns";
import { ValidationError } from "../error";
import { TZDate } from "@date-fns/tz";

type Params = paths["/congestions"]["get"]["parameters"]["query"];
type Congestion = components["schemas"]["Congestion"];
type AggregateFn = "min" | "max" | "avg";

export class CongestionSvc {
  constructor(
    private db: Firestore,
    private collection: string = "congestions",
  ) {}

  /**
   * Retrieves the date when traffic congestion data was last updated.
   *
   * This method queries the specified database collection, orders documents by the `updated_on`
   * field in descending order, and returns the latest update date.
   *
   * @returns A promise that resolves to a date of the last update to traffic congestion data.
   * @throws Throws an error if the query fails or if no documents are found in the collection.
   */
  lastUpdatedOn = async (): Promise<TZDate> => {
    const latest = await this.db
      .collection(this.collection)
      .orderBy("updated_on", "desc")
      .limit(1)
      .get();
    if (latest.size < 1) {
      throw new Error("Expected at least 1 Congestion document in Firestore.");
    }
    return new TZDate(latest.docs[0].data().updated_on);
  };

  /**
   * Retrieve congestion data within an optional time range and/or for a specific camera.
   *
   * @param params - The parameters for querying congestion data.
   * @returns A promise resolving to an array of congestion data objects matching the query criteria.
   *
   * @description Returns traffic congestion data inferred from traffic cameras, optionally filtered by camera ID and/or a specific time range.
   * If neither `begin` nor `end` timestamps are provided, the function defaults to querying based on the most recent `updated_on` timestamp for optimized performance.
   */
  getCongestions = async ({
    begin,
    end,
    camera_id,
    agg,
    groupby,
    min_rating,
  }: Params = {}): Promise<Congestion[]> => {
    let query = this.db.collection(this.collection) as Query;
    // determine date range of query
    let beginDate = begin != null ? new TZDate(begin) : null;
    let endDate = end != null ? new TZDate(end) : null;
    if (beginDate == null || endDate == null) {
      // performance: only query last updated_on if 'begin' or 'end' timestamp is omitted.
      const lastUpdated = await this.lastUpdatedOn();
      beginDate = await this.lastUpdatedOn();
      endDate = addDate<TZDate, TZDate>(lastUpdated, { days: 1 });
    }

    // filter by camera_id if specified
    if (camera_id != null) {
      query = query.where("camera.id", "==", camera_id);
    }
    // Filter by rating if min_rating is provided
    if (min_rating != null) {
      query = query.where("rating.value", ">=", min_rating);
    }
    // filter congestions by date range
    query = query
      .where("updated_on", ">=", formatSGT(beginDate))
      .where("updated_on", "<", formatSGT(endDate));

    // perform aggregation if agg and groupby are provided
    if (agg && groupby) {
      return this.aggregate(query, agg, groupby, beginDate, endDate);
    } else if (agg || groupby) {
      throw new ValidationError(
        "Both groupby & agg params must be specified if either is specified.",
      );
    }

    // obtain congestion points for query
    const congestions = await query.get();
    const data = congestions.docs.map((d) => d.data() as Congestion);

    return data;
  };

  /**
   * Aggregates congestion data over a specified time range and grouping interval.
   *
   * This method computes congestion metrics—such as average, minimum, or latest congestion ratings—
   * across date intervals within a specified time range. It uses the provided `query` to filter
   * congestion records as inputs for aggregation, grouping them by the specified interval.
   *
   * @param query - The query to supply input congestion records for aggregation.
   * @param agg - The aggregation function to apply ("avg" for average, "min" for minimum, or any other value for the latest).
   * @param groupby - The interval by which to group data (e.g., daily, weekly).
   * @param beginDate - The start date of the aggregation period, inclusive.
   * @param endDate - The end date of the aggregation period, exclusive.
   * @returns A Promise that resolves to an array of `Congestion` objects, representing aggregated results for each date group.
   *
   * @throws Error if date range creation fails.
   */
  private aggregate = async (
    query: Query,
    agg: AggregateFn,
    groupby: DateInterval,
    beginDate: TZDate,
    endDate: TZDate,
  ): Promise<Congestion[]> => {
    // compute date groups based on specified groupby
    const dateGroups = dateRange(beginDate, endDate, groupby);
    if (dateGroups == null) {
      throw Error(
        `Failed to create date range: ${beginDate} to ${endDate} every ${groupby}`,
      );
    }

    const grouped: Congestion[] = [];
    for (let i = 0; i < dateGroups.length - 1; i++) {
      // filter for congestions that belong to date interval group
      const group = query
        .where("updated_on", ">=", formatSGT(dateGroups[i]))
        .where("updated_on", "<", formatSGT(dateGroups[i + 1]));
      // sorted results by congestion rating
      const groupLen = (await group.count().get()).data().count;
      if (groupLen <= 0) {
        // skip groups with no items
        continue;
      }

      // compute aggregation for each group
      const getFirst = async () =>
        (
          await group.orderBy("rating.value", "asc").limit(1).get()
        ).docs[0].data() as Congestion;
      if (agg === "avg") {
        // query first congestion for each group as the representative of the group
        const congestion = await getFirst();
        const result = await group
          .aggregate({ value: AggregateField.average("rating.value") })
          .get();
        congestion.rating.value = result.data().value!;
        grouped.push(congestion);
      } else if (agg === "min") {
        // first congestion of each rating value sorted group is min.
        grouped.push(await getFirst());
      } else {
        // agg is max: first congestion of each rating value sorted in descending order group is max
        grouped.push(
          (
            await group.orderBy("rating.value", "desc").limit(1).get()
          ).docs[0].data() as Congestion,
        );
      }
    }

    return grouped;
  };

  /**
   * Retrieves congestion data for a given document ID.
   *
   * @param {string} docId - The ID of the document to retrieve from the database.
   * @returns {Promise<Congestion>} A promise that resolves to the congestion data.
   */
  getCongestion = async (docId: string): Promise<Congestion> => {
    const doc = await this.db.doc(docId).get();
    return doc.data() as Congestion;
  };
}
