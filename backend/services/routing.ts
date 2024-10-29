import express from 'express';
import * as fs from 'fs';            
import * as path from 'path';      
import csv from 'csv-parser';       
import { components, paths } from "../api";
import { CongestionSvc } from "./congestion";

// OSRMText instructions
const OSRMText = require("osrm-text-instructions")("v5");

// Define GeoLocation to avoid conflict with DOM Location
type GeoLocation = {
  latitude: number;
  longitude: number;
};

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
   * Geocodes a postcode to obtain latitude and longitude.
   */
  public async geolookup(postcode: string): Promise<GeoLocation> {
    // Load postcode data if not already loaded
    console.log('routing.geolookup')
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
  };

  /**
   * Loads the postcode data from the CSV file into a Map for quick lookup.
   */
  private loadPostcodeData(): Promise<void> {
    return new Promise((resolve, reject) => {
      const csvFilePath = path.resolve(__dirname, '../data/SG_postal.csv');
      this.postcodeLookup = new Map<string, GeoLocation>();

      fs.createReadStream(csvFilePath)
        .pipe(csv()) // Default comma delimiter
        .on('data', (row) => {
          const postcode = row['postal_code']?.trim();
          const latitude = parseFloat(row['lat']);
          const longitude = parseFloat(row['lon']);

          if (postcode && !isNaN(latitude) && !isNaN(longitude)) {
            this.postcodeLookup!.set(postcode, { latitude, longitude });
          }
        })
        .on('end', () => {
          console.log('Postcode data loaded successfully.');
          resolve();
        })
        .on('error', (error) => {
          console.error('Error loading postcode data:', error);
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

  const response = await this.fetchFn(url.toString());
  const r = await response.json();

  // Handle response failure
  if (!response.ok) {
    throw new Error(
      `OSRM ${url.pathname} request failed with error: ${r["code"]}: ${r["message"]}`
    );
  }

  // Decode response into routes
  return Promise.all(
    r.routes.map(async (route: any) => ({
      geometry: route.geometry, // Polyline for the entire route
      duration: route.duration,
      distance: route.distance,
      steps: await Promise.all(
        route.legs.flatMap((leg: any) =>
          leg.steps.map(async (step: any) => ({
            name: step.name,
            duration: step.duration,
            distance: step.distance,
            geometry: step.geometry,
            direction: step.maneuver.modifier || null,
            maneuver: step.maneuver.type,
            instruction: OSRMText.compile("en", step, {}),
            // Congestion data is handled by the CongestionSvc
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
