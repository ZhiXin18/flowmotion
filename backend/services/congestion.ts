/*
 * Flowmotion
 * Backend
 * Congestion Service
 */

import { Firestore, Query } from "firebase-admin/firestore";
import { components, paths } from "../api";
import { formatSGT } from "../date";
import { add as addDate } from "date-fns";
import * as _ from "lodash"; // lodash for aggregation

// Extend the Params type to include 'min_rating'
type Params = paths["/congestions"]["get"]["parameters"]["query"] & {
  min_rating?: number; // Add min_rating as an optional parameter
};

type Congestion = components["schemas"]["Congestion"];

export class CongestionSvc {
  constructor(
    private db: Firestore,
    private collection: string = "congestions",
  ) {}

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

  getCongestions = async ({
    begin,
    end,
    camera_id,
    agg,
    groupby,
    min_rating,
  }: Params = {}): Promise<Congestion[]> => {
    let query = this.db.collection(this.collection) as Query;

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

    if (camera_id != null) {
      query = query.where("camera.id", "==", camera_id);
    }

    const congestions = await query.get();
    let data = congestions.docs.map((d) => d.data() as Congestion);

    // Filter by rating if min_rating is provided
    if (min_rating != null) {
      data = data.filter(
        (d) => d.rating.value != null && d.rating.value >= min_rating,
      );
    }

    // Perform aggregation if agg and groupby are provided
    if (agg && groupby) {
      const grouped = _.groupBy(data, (d: Congestion) => {
        const date = new Date(d.updated_on);
        return groupby === "hour"
          ? `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}`
          : `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
      });

      return Object.values(grouped).map((group: Congestion[]) => {
        const ratings = group.map((d) => d.rating.value ?? 0); // Default to 0 if value is undefined
        const aggregatedValue =
          agg === "min"
            ? _.min(ratings)
            : agg === "max"
              ? _.max(ratings)
              : _.mean(ratings); // Default to 'avg'

        return {
          ...group[0], // Take the first element's structure for consistency
          rating: { ...group[0].rating, value: aggregatedValue as number },
          updated_on: group[0].updated_on, // Maintain the first timestamp in group
        };
      });
    } else if (agg && !groupby) {
      throw new Error("groupby must be provided if agg is specified");
    }

    return data;
  };

  getCongestion = async (docId: string): Promise<Congestion> => {
    const doc = await this.db.doc(docId).get();
    return doc.data() as Congestion;
  };
}
