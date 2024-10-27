/*
 * Flowmotion
 * Backend
 * Entrypoint
 */
import express from "express";
import { CongestionSvc } from "@/services/congestion";
import { initDB } from "@/clients/db";
import { Request, Response } from "express";
import * as OpenApiValidator from "express-openapi-validator";

// parse command line args
if (process.argv.length < 4) {
  console.error("Usage: index.ts <OPENAPI_YAML> <PORT>");
  process.exit(1);
}
const apiYaml = process.argv[2];
const port = parseInt(process.argv[3]);

// setup services
const db = initDB();
const congestionSvc = new CongestionSvc(db);

// setup express server
const app = express();
// parse json in request body
app.use(express.json());
// validate requests / responses against openapi schema
app.use(
  OpenApiValidator.middleware({
    apiSpec: apiYaml,
    validateRequests: true,
    // turn off response validation for performance in production
    validateResponses: app.get("env") != "production",
  }),
);
app.get("/congestions", async (req: Request, res: Response) => {
  res.json(await congestionSvc.getCongestions(req.query));
});

// catchall error handler with json response
// eslint-disable-next-line @typescript-eslint/no-explicit-any
app.use((err: any, _req: Request, res: Response) => {
  console.error(err);
  // format error
  res.status(err.status || 500).json({
    message: err.message,
  });
});

// listen for requests
app.listen(port, () => {
  console.log(`[server]: Running in ${app.get("env")} environment`);
  console.log(`[server]: Listening at http://localhost:${port}`);
});
