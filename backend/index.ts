/*
 * Flowmotion
 * Backend
 * Entrypoint
 */
import express, { NextFunction } from "express";
import { CongestionSvc } from "./services/congestion";
import { initDB } from "./clients/db";
import { Request, Response } from "express";
import * as OpenApiValidator from "express-openapi-validator";
import { paths } from "./api";
import { ValidationError } from "./error";
import { RoutingSvcFactory } from "./factories/routing";

type GeoLocation = {
  latitude: number;
  longitude: number;
};
// parse command line args
if (process.argv.length < 4) {
  console.error("Usage: index.ts <OPENAPI_YAML> <PORT>");
  process.exit(1);
}
const apiYaml = process.argv[2];
const port = parseInt(process.argv[3]);

// fix timezone
process.env.TZ = "Asia/Singapore";

// setup services
const db = initDB();
const congestion = new CongestionSvc(db);

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
  res.json(await congestion.getCongestions(req.query));
});

app.post("/route", async (req: Request, res: Response) => {
  const r =
    req.body as paths["/route"]["post"]["requestBody"]["content"]["application/json"];

  let srcLocation: GeoLocation;
  let destLocation: GeoLocation;

  // construct routing service based on whether congestion aware routing is enabled.
  const routingSvc = RoutingSvcFactory.create(
    (r.congestion ?? true) ? congestion : null,
  );

  if (r.src.kind === "address") {
    const postcode = r.src.address?.postcode?.trim();
    if (!postcode) {
      throw new ValidationError("Source address must include a postcode.");
    }
    srcLocation = await routingSvc.geolookup(postcode);
  } else {
    srcLocation = r.src.location!;
  }

  if (r.dest.kind === "address") {
    const postcode = r.dest.address?.postcode?.trim();
    if (!postcode) {
      throw new ValidationError("Destination address must include a postcode.");
    }
    destLocation = await routingSvc.geolookup(postcode);
  } else {
    destLocation = r.dest.location!;
  }

  const routes = await routingSvc.route(srcLocation, destLocation);
  res.json({ routes });
});

app.get("/geocode/:postcode", async (req: Request, res: Response) => {
  const r =
    req.params as paths["/geocode/{postcode}"]["get"]["parameters"]["path"];
  const location = await RoutingSvcFactory.create().geolookup(r.postcode);
  res.json(location);
});

// catchall error handler with json response
// eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/no-unused-vars
app.use((err: any, req: Request, res: Response, _next: NextFunction) => {
  // dump error and on
  console.error("Server error: %j Caused by: %j", err, req);
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
