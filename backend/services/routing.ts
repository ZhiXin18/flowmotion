/*
 * Flowmotion
 * Backend
 * Routing Service
 */

import { components, paths } from "../api";
import { CongestionSvc } from "./congestion";
// osrm-text-instructions
// eslint-disable-next-line @typescript-eslint/no-require-imports
const OSRMText = require("osrm-text-instructions")("v5");

type Location = components["schemas"]["Location"];
type Routes = NonNullable<
  paths["/route"]["post"]["responses"]["200"]["content"]["application/json"]["routes"]
>;

export const ROUTING_API =
  "https://osrm-congestion-210524342027.asia-southeast1.run.app";

/**
 * RoutingSvc performs routing by making an API call to the OSRM API.
 *
 * @param apiBase - The base URL of the OSRM API.
 *                           This URL is used to construct
 *                           requests to the OSRM service.
 *
 * @param fetchFn - A custom fetch function used
 *                          to perform network requests.
 *                          This implementation should
 *                          conform to the Fetch API,
 *                          potentially incorporating caching
 *                          strategies to enhance performance.
 */
export class RoutingSvc {
  constructor(
    public apiBase: string,
    private fetchFn: typeof fetch,
    private congestion: CongestionSvc,
  ) {}

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
  route = async (src: Location, dest: Location): Promise<Routes> => {
    // make api call to OSRM to perform routing
    const url = new URL(
      `/route/v1/driving/${src.longitude},${src.latitude};${dest.longitude},${dest.latitude}`,
      this.apiBase,
    );
    url.searchParams.set("steps", "true");
    url.searchParams.set("alternatives", "true");
    const response = await this.fetchFn(url);
    const r = await response.json();

    // handle response failure
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
