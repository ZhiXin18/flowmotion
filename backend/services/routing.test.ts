/*
 * Flowmotion
 * Routing Service
 * Tests
 */

import { describe, expect, test } from "@jest/globals";
import { ROUTING_API, RoutingSvc } from "./routing";
import { CongestionSvc } from "./congestion";
import { initDB } from "../clients/db";

describe("RoutingSvc", () => {
  const osrm = new RoutingSvc(ROUTING_API, fetch, new CongestionSvc(initDB()));
  test("route() returns routes", async () => {
    const routes = await osrm.route(
      // NTU nanyang circle
      {
        longitude: 103.6849923,
        latitude: 1.3437504,
      },
      // changi airport
      {
        longitude: 103.98847034565972,
        latitude: 1.35755735,
      },
    );
    expect(routes.length).toBeGreaterThan(0);
  });
});
