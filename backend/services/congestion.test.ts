/*
 * Flowmotion
 * Congestion Service
 * Tests
 */

import { describe, expect, test } from "@jest/globals";
import { CongestionSvc } from "./congestion";
import { initDB } from "../clients/db";
import { add as addDate } from "date-fns";

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
    const congestions = await congestion.getCongestions({
      groupby: "hour",
      agg: "max",
    });
    expect(congestions.length).toBeGreaterThan(0);
    expect(congestions.every((c) => typeof c.rating.value === "number")).toBe(
      true,
    );
  });

  test("getCongestions() performs aggregation by day with avg", async () => {
    const congestions = await congestion.getCongestions({
      groupby: "day",
      agg: "avg",
    });
    expect(congestions.length).toBeGreaterThan(0);
    expect(congestions.every((c) => typeof c.rating.value === "number")).toBe(
      true,
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

  // Edge case test for invalid agg parameter
  test("getCongestions() throws error for invalid agg parameter", async () => {
    try {
      await congestion.getCongestions({
        groupby: "day",
        agg: "invalid_agg" as unknown as "min" | "max" | "avg", // Cast to a valid agg type
      });
    } catch (e) {
      expect((e as Error).message).toMatch(/Invalid aggregation method/);
    }
  });

  // Edge case test for missing groupby when agg is provided
  test("getCongestions() throws error when agg is provided without groupby", async () => {
    try {
      await congestion.getCongestions({
        agg: "max",
      });
    } catch (e) {
      expect((e as Error).message).toMatch(
        /groupby must be provided if agg is specified/,
      );
    }
  });

  // New test for filtering by min_rating
  test("getCongestions() filters by min_rating", async () => {
    const congestions = await congestion.getCongestions({
      min_rating: 0.7,
    });
    expect(congestions.every((c) => c.rating.value >= 0.7)).toBe(true);
  });
});
