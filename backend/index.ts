/*
 * Flowmotion
 * Backend
 * Entrypoint
 */
import express, { Express } from "express";
import { initialize as initOpenAPI } from "express-openapi";
import CongestionSvc from "@/services/congestion";
import { initDB } from "@/db";

const db = initDB();

// setup express server
const app: Express = express();
const port = process.env.PORT || 3000;
initOpenAPI({
  app,
  apiDoc: "../schema/flowmotion_api.yaml",
  paths: "routes",
  // dependency injection concrete implementations
  dependencies: {
    congestion: new CongestionSvc(db),
  },
});
app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
