/*
 * Flowmotion
 * Backend
 * Date Utilities
 */

import { TZDate } from "@date-fns/tz";
import { formatDate } from "date-fns";

export function formatSGT(date: Date): string {
  const tzDate = new TZDate(date);
  return formatDate(
    tzDate.withTimeZone("Asia/Singapore"),
    "yyyy-MM-dd'T'HH:mm:ss.SSSSSXX",
  );
}
