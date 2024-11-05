/*
 * Flowmotion
 * Caching Fetch implementation
 * Unit tests
 */

import { describe, expect, test } from "@jest/globals";
import { CachingFetch } from "./fetch";

describe("CachingFetch", () => {
  // guarantee that fetch will cache with ttl = infinity
  const fetch = CachingFetch({ ttl: Infinity });
  test("fetch() no cache", async () => {
    const response = await fetch("https://example.com");
    expect(response.ok).toBeTruthy();
    expect(response.headers.get("X-Cache")).toStrictEqual("MISS");
  });
  test("fetch() cached", async () => {
    const response = await fetch("https://example.com");
    expect(response.ok).toBeTruthy();
    expect(response.headers.get("X-Cache")).toStrictEqual("HIT");
  });

  test("fetch() no-cache", async () => {
    const response = await fetch("https://example.com", {
      headers: {
        "Cache-Control": "no-cache",
      },
    });
    expect(response.ok).toBeTruthy();
    expect(response.headers.get("X-Cache")).toStrictEqual("MISS");
  });
});
