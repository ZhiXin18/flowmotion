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

  test("geolookup() returns correct GeoLocation for a given postcode", async () => {
    const postcode = "639798"; // Example postcode for NTU area
    const location = await osrm.geolookup(postcode);

    expect(location).toBeDefined();
    expect(location.latitude).toBeCloseTo(1.3437504, 2);
    expect(location.longitude).toBeCloseTo(103.6849923, 2);
  });

  test("geolookup() throws an error for invalid postcode", async () => {
    const invalidPostcode = "000000"; // Example of an invalid postcode

    await expect(osrm.geolookup(invalidPostcode)).rejects.toThrow(
      `No location found for postcode: ${invalidPostcode}`,
    );
  });
});
