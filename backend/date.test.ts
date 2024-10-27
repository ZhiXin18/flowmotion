/*
 * Flowmotion
 * Date Utilities
 * Unit Tests
 */

import { describe, expect, test } from "@jest/globals";
import { formatSGT } from "./date";

describe("CongestionSvc", () => {
  test("formatSGT()", async () => {
    // month is zero indexed: 3 -> April
    expect(formatSGT(new Date("2024-04-01T00:00:00.000+0000"))).toStrictEqual(
      "2024-04-01T08:00:00.000+0800",
    );
  });
});
