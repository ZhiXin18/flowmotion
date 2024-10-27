/*
 * Flowmotion
 * Backend
 * Congestion Service
 */

import { Firestore, Query } from "firebase-admin/firestore";
import { components, paths } from "@/api";
import { formatSGT } from "@/date";
import { add as addDate } from "date-fns";

type Params = paths["/congestions"]["get"]["parameters"]["query"];
type Congestion = components["schemas"]["Congestion"];

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
  lastUpdatedOn = async (): Promise<Date> => {
    const latest = await this.db
      .collection(this.collection)
      .orderBy("updated_on", "desc")
      .limit(1)
      .get();
    if (latest.size < 1) {
      throw new Error("Expected at least 1 Congestion document in Firestore.");
    }
    return new Date(latest.docs[0].data().updated_on);
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
  getCongestions = async ({ begin, end, camera_id }: Params = {}): Promise<
    Congestion[]
  > => {
    let query = this.db.collection(this.collection) as Query;
    // filter congestions by time range, or default to returning last updated
    // performance: only query last updated_on if 'begin' or 'end' timestamp is omitted.
    const beginDate = begin != null ? new Date(begin) : null;
    const endDate = end != null ? new Date(end) : null;
    if (beginDate == null || endDate == null) {
      const lastUpdated = await this.lastUpdatedOn();
      const lastUpdatedEnd = new Date(
        addDate(lastUpdated, { days: 1 }).getTime() - 1,
      );
      query = query
        .where("updated_on", ">=", formatSGT(beginDate ?? lastUpdated))
        .where("updated_on", "<", formatSGT(endDate ?? lastUpdatedEnd));
    } else {
      query = query
        .where("updated_on", ">=", formatSGT(beginDate))
        .where("updated_on", "<", formatSGT(endDate));
    }

    // filter by camera_id if specified
    if (camera_id != null) {
      query = query.where("camera.id", "==", camera_id);
    }

    const congestions = await query.get();
    // TODO(F-R-YEO): perform aggregation based on aggregation parameters
    return congestions.docs.map((d) => d.data() as Congestion);
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
