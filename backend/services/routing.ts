/*
 * Flowmotion
 * Backend
 * Routing Service
 */

import * as fs from "fs";
import * as path from "path";
import csv from "csv-parser";
import { components, paths } from "../api";
import { CongestionSvc } from "./congestion";

// OSRMText instructions
// eslint-disable-next-line @typescript-eslint/no-require-imports
const OSRMText = require("osrm-text-instructions")("v5");

// Define GeoLocation to avoid conflict with DOM Location
type GeoLocation = components["schemas"]["Location"];

type Routes = NonNullable<
  paths["/route"]["post"]["responses"]["200"]["content"]["application/json"]["routes"]
>;

export const ROUTING_API =
  "https://osrm-congestion-210524342027.asia-southeast1.run.app";

/**
 * RoutingSvc performs routing by making API calls to the OSRM API.
 */
export class RoutingSvc {
  private postcodeLookup: Map<string, GeoLocation> | null = null;
  private postcodeDataLoading: Promise<void> | null = null;

  constructor(
    public apiBase: string,
    private fetchFn: typeof fetch,
    private congestion: CongestionSvc,
  ) {
    // No need to load the CSV data here
  }

  /**
   * Calculates a route from the given source (src) to the destination (dest) location
   * using the Open Source Routing Machine (OSRM) API.
   *
   * This method constructs a request to the OSRM API to retrieve routing information,
   * including the route geometry, estimated travel duration, distance, and detailed
   * steps for navigation. The response is processed to extract relevant route details
   * and return them in a structured format.
   *
   * @param src The starting location for the route. Should contain properties `latitude` and `longitude`.
   *
   * @param dest The destination location for the route. Should also contain properties `latitude` and `longitude`.
   *
   * @returns A promise that resolves to an array of routes.
   *
   * @throws Throws an error if the OSRM API request fails, including the error code and message from the response.
   *
   */
  public async geolookup(postcode: string): Promise<GeoLocation> {
    // Load postcode data if not already loaded
    console.log("routing.geolookup");
    if (!this.postcodeLookup) {
      if (!this.postcodeDataLoading) {
        this.postcodeDataLoading = this.loadPostcodeData();
      }
      await this.postcodeDataLoading;
    }

    const normalizedPostcode = postcode.trim();
    if (!this.postcodeLookup) {
      throw new Error("Postcode data failed to load.");
    }
    const location = this.postcodeLookup.get(normalizedPostcode);

    if (!location) {
      throw new Error(`No location found for postcode: ${postcode}`);
    }

    return location;
  }

  /**
   * Loads the postcode data from the CSV file into a Map for quick lookup.
   */
  private loadPostcodeData(): Promise<void> {
    return new Promise((resolve, reject) => {
      const csvFilePath = path.resolve(__dirname, "../data/SG_postal.csv");
      this.postcodeLookup = new Map<string, GeoLocation>();

      fs.createReadStream(csvFilePath)
        .pipe(csv()) // Default comma delimiter
        .on("data", (row) => {
          const postcode = row["postal_code"]?.trim();
          const latitude = parseFloat(row["lat"]);
          const longitude = parseFloat(row["lon"]);

          if (postcode && !isNaN(latitude) && !isNaN(longitude)) {
            this.postcodeLookup!.set(postcode, { latitude, longitude });
          }
        })
        .on("end", () => {
          console.log("Postcode data loaded successfully.");
          resolve();
        })
        .on("error", (error) => {
          console.error("Error loading postcode data:", error);
          this.postcodeLookup = null;
          reject(error);
        });
    });
  }

  /**
   * Calculates routes between two locations using the OSRM API.
   */
  route = async (src: GeoLocation, dest: GeoLocation): Promise<Routes> => {
    // Construct the URL for the OSRM API call
    const url = new URL(
      `/route/v1/driving/${src.longitude},${src.latitude};${dest.longitude},${dest.latitude}`,
      this.apiBase,
    );
    url.searchParams.set("steps", "true");
    url.searchParams.set("alternatives", "true");
    const response = await this.fetchFn(url);
    const r = await response.json();

    // Handle response failure
    if (!response.ok) {
      throw new Error(
        `OSRM ${url.pathname} request failed with error: ${r["code"]}: ${r["message"]}`,
      );
    }

    // decode response into routes
    return await Promise.all(
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      r.routes.map(async (route: any) => ({
        geometry: route.geometry, // Polyline for the entire route
        duration: route.duration,
        distance: route.distance,
        steps: await Promise.all(
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          route.legs.flatMap((leg: any) =>
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            leg.steps.map(async (step: any) => ({
              name: step.name,
              duration: step.duration,
              distance: step.distance,
              geometry: step.geometry,
              direction: step.maneuver.modifier || null,
              maneuver: step.maneuver.type,
              instruction: OSRMText.compile("en", step, {}),
              // congestion doc id is passed via step 's pronunciation field
              // resolve contents of congestion if present
              congestion:
                step.pronunciation != null
                  ? await this.congestion.getCongestion(step.pronunciation)
                  : null,
            })),
          ),
        ),
      })),
    );
  };
}
