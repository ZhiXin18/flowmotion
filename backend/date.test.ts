/*
 * Flowmotion
 * Date Utilities
 * Unit Tests
 */

import { describe, expect, test } from "@jest/globals";
import { formatSGT } from "@/date";

describe("CongestionSvc", () => {
  test("formatSGT()", async () => {
    expect(formatSGT(new Date(2024, 2, 1))).toStrictEqual(
      "1970-01-01T07:30:000000+0730",
    );
  });
});
