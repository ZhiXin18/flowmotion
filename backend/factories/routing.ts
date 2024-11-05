/*
 * Flowmotion
 * Backend
 * Routing Service Factory
 */

import { CachingFetch } from "../fetch";
import { CongestionSvc } from "../services/congestion";
import { RoutingSvc } from "../services/routing";

// routing endpoint url constants
export const CONGEST_ROUTING_API =
  "https://osrm-congestion-210524342027.asia-southeast1.run.app";
export const ROUTING_API = "https://router.project-osrm.org";

/*
 * RoutingSvcFactory creates instances of RoutingSvc.
 */
export class RoutingSvcFactory {
  /**
   * Creates an instance of RoutingSvc.
   *
   * This method generates a RoutingSvc instance, which can be configured to use congestion-aware routing
   *
   * @param congestionSvc - An optional instance of CongestionSvc that enables congestion-aware routing.
   *
   * @returns An instance of RoutingSvc.
   */
  static create(congestionSvc: CongestionSvc | null = null): RoutingSvc {
    if (congestionSvc != null) {
      // create routing service with congestion aware routing
      return new RoutingSvc(CONGEST_ROUTING_API, fetch, congestionSvc);
    } else {
      // caching fetch with ttl of 1s to avoid hitting 1RPS rate limit
      return new RoutingSvc(ROUTING_API, CachingFetch({ ttl: 1, max: 100000 }));
    }
  }
}
