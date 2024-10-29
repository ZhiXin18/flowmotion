"use strict";
/*
 * Flowmotion
 * Backend
 * Date Utilities
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatSGT = formatSGT;
var tz_1 = require("@date-fns/tz");
var date_fns_1 = require("date-fns");
/**
 * Formats a given date to Singapore Standard Time (SGT) in ISO 8601 format.
 *
 * This function takes a JavaScript `Date` object, converts it to UTC,
 * then adjusts it to Singapore Standard Time (SGT) and formats the date
 * to the iso 8601 format with millisecond precision.
 *
 * @param {Date} date - The date to format in SGT.
 * @returns {string} The formatted date string in SGT, ISO 8601 format.
 *
 * @example
 * const date = new Date('2023-10-26T12:00:00Z');
 * console.log(formatSGT(date));
 * // Output: "2023-10-26T20:00:00.000000+08:00" (Example output in SGT)
 */
function formatSGT(date) {
    var tzDate = new tz_1.TZDate(date, "UTC");
    return (0, date_fns_1.formatDate)(tzDate.withTimeZone("Asia/Singapore"), "yyyy-MM-dd'T'HH:mm:ss.SSSXX");
}
