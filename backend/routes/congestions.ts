/*
 * Flowmotion
 * Backend
 * API Route /congestions
 */

import { CongestionSvc } from "@/services/congestion";
import { Request, Response } from "express";

export function congestionRoute(congestion: CongestionSvc) {
  return {
    getCongestions: async (req: Request, resp: Response) => {
      const congestions = await congestion.getCongestions(req.query);
      resp.json(congestions);
    },
  };
}
