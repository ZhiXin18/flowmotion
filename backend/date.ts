/*
 * Flowmotion
 * Backend
 * Date Utilities
 */

import { TZDate } from "@date-fns/tz";
import { eachDayOfInterval, eachHourOfInterval, formatDate } from "date-fns";

export type DateInterval = "day" | "hour";

/**
 * Formats a given date to Singapore Standard Time (SGT) in ISO 8601 format.
 *
 * This function takes a JavaScript `Date` object, converts it to UTC,
 * then adjusts it to Singapore Standard Time (SGT) and formats the date
 * to the iso 8601 format with millisecond precision.
 *
 * @param date - The date to format in SGT.
 * @returns The formatted date string in SGT, ISO 8601 format.
 *
 * @example
 * const date = new Date('2023-10-26T12:00:00Z');
 * console.log(formatSGT(date));
 * // Output: "2023-10-26T20:00:00.000000+08:00" (Example output in SGT)
 */
export function formatSGT(date: TZDate): string {
  return formatDate(
    date.withTimeZone("Asia/Singapore"),
    "yyyy-MM-dd'T'HH:mm:ss.SSSXX",
  );
}

/**
 * Generates a range of dates based on a specified interval.
 *
 * @param begin - The start date of the range, inclusive.
 * @param end - The end date of the range, exclusive.
 * @param interval - The interval for generating dates. Options are:
 *   - "day": Generates an array of dates at daily intervals.
 *   - "hour": Generates an array of dates at hourly intervals.
 *
 * @returns An array of dates within the specified range, depending on the chosen interval.
 */
export function dateRange(begin: TZDate, end: TZDate, interval: DateInterval) {
  const timespan = {
    start: begin,
    end: end,
  };
  if (interval === "day") {
    return eachDayOfInterval(timespan);
  }
  if (interval == "hour") {
    return eachHourOfInterval(timespan);
  }
}
