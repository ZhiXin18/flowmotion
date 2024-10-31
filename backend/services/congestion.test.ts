/*
 * Flowmotion
 * Congestion Service
 * Tests
 */

import { describe, expect, test } from "@jest/globals";
import { CongestionSvc } from "./congestion";
import { initDB } from "../clients/db";
import { add as addDate } from "date-fns";
import { ValidationError } from "../error";

describe("CongestionSvc", () => {
  const congestion = new CongestionSvc(initDB());

  test("lastUpdatedOn() gets last updated_on date", async () => {
    await congestion.lastUpdatedOn();
  });

  test("getCongestions() gets last updated_on congestions", async () => {
    const lastUpdated = await congestion.lastUpdatedOn();
    const congestions = await congestion.getCongestions();
    expect(congestions.length).toBeGreaterThan(0);
    expect(
      congestions.reduce(
        (actual, c) =>
          actual && new Date(c.updated_on).getTime() === lastUpdated.getTime(),
        true,
      ),
    ).toStrictEqual(true);
  });

  test("getCongestions() filters by begin & end", async () => {
    const minDate = new Date(0);
    const congestions = await congestion.getCongestions({
      begin: minDate.toISOString(),
      end: addDate(minDate, { days: 1 }).toISOString(),
    });
    expect(congestions.length).toStrictEqual(0);
  });

  test("getCongestions() filters by camera_id", async () => {
    const congestions = await congestion.getCongestions({ camera_id: "1703" });
    expect(congestions.length).toBeGreaterThan(0);
    expect(
      congestions.reduce((actual, c) => actual && c.camera.id === "1703", true),
    ).toStrictEqual(true);
  });

  test("getCongestions() performs aggregation by hour with max", async () => {
    // hourly group by over a day
    const grouped = await congestion.getCongestions({
      groupby: "hour",
      agg: "max",
      begin: "2024-10-29T20:00:00+00:00",
      end: "2024-10-30T20:00:00+00:00",
    });
    expect(grouped.length).toEqual(24);
    expect(grouped.every((c) => typeof c.rating.value === "number")).toBe(true);
    // check first group is aggregated correctly
    const firstHour = await congestion.getCongestions({
      begin: "2024-10-29T20:00:00+00:00",
      end: "2024-10-29T21:00:00+00:00",
    });
    expect(grouped[0].rating.value).toStrictEqual(
      firstHour
        .map((c) => c.rating.value)
        .reduce((acc, v) => Math.max(acc, v), 0),
    );
  });

  test("getCongestions() performs aggregation by day with avg", async () => {
    const grouped = await congestion.getCongestions({
      groupby: "day",
      agg: "avg",
      begin: "2024-10-28T00:00:00+00:00",
      end: "2024-10-30T00:00:00+00:00",
    });
    expect(grouped.length).toStrictEqual(2);
    expect(grouped.every((c) => typeof c.rating.value === "number")).toBe(true);
    // check first group is aggregated correctly
    const firstDay = await congestion.getCongestions({
      begin: "2024-10-28T00:00:00+00:00",
      end: "2024-10-29T00:00:00+00:00",
    });
    expect(grouped[0].rating.value).toStrictEqual(
      firstDay.map((c) => c.rating.value).reduce((acc, v) => acc + v, 0) /
        firstDay.length,
    );
  });

  test("getCongestions() performs aggregation by day with min", async () => {
    const congestions = await congestion.getCongestions({
      groupby: "day",
      agg: "min",
    });
    expect(congestions.length).toBeGreaterThan(0);
    expect(congestions.every((c) => typeof c.rating.value === "number")).toBe(
      true,
    );
  });

  // Edge case test for missing groupby when agg is provided
  test("getCongestions() throws error when agg is provided without groupby", async () => {
    await expect(congestion.getCongestions({ agg: "max" })).rejects.toThrow(
      new ValidationError(
        "Both groupby & agg params must be specified if either is specified.",
      ),
    );
  });

  // New test for filtering by min_rating
  test("getCongestions() filters by min_rating", async () => {
    const congestions = await congestion.getCongestions({
      min_rating: 0.7,
    });
    expect(congestions.length).toBeGreaterThan(0);
    expect(congestions.every((c) => c.rating.value >= 0.7)).toBe(true);
  });
});
