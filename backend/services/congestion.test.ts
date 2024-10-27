/*
 * Flowmotion
 * Congestion Service
 * Unit Tests
 */

import { describe, expect, test } from "@jest/globals";
import { CongestionSvc } from "@/services/congestion";
import { initDB } from "@/clients/db";
import { add as addDate } from "date-fns";

describe("CongestionSvc", () => {
  const congestion = new CongestionSvc(initDB());
  test("lastUpdatedOn() gets last updated_on date", async () => {
    await congestion.lastUpdatedOn();
  });

  test("get() gets last updated_on congestions", async () => {
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

  test("get() filters by begin & end", async () => {
    // unix epoch jan 1 1970
    const minDate = new Date(0);
    const congestions = await congestion.getCongestions({
      begin: minDate.toISOString(),
      end: addDate(minDate, { days: 1 }).toISOString(),
    });
    expect(congestions.length).toStrictEqual(0);
  });

  test("get() filters by camera_id", async () => {
    const congestions = await congestion.getCongestions({ camera_id: "1703" });
    expect(congestions.length).toBeGreaterThan(0);
    expect(
      congestions.reduce((actual, c) => actual && c.camera.id === "1703", true),
    ).toStrictEqual(true);
  });
});
