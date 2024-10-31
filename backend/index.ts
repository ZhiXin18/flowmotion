/*
 * Flowmotion
 * Backend
 * Entrypoin
 */
import express, { NextFunction } from "express";
import { CongestionSvc } from "./services/congestion";
import { initDB } from "./clients/db";
import { Request, Response } from "express";
import * as OpenApiValidator from "express-openapi-validator";
import { ROUTING_API, RoutingSvc } from "./services/routing";
import { paths } from "./api";

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

// setup services
const db = initDB();
const congestion = new CongestionSvc(db);
const routing_service = new RoutingSvc(ROUTING_API, fetch, congestion);

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
  // const location = await routing_service.geolookup("636959");
  // console.log(location);
  if (r.src.kind === "location" && r.dest.kind === "location") {
    const routes = await routing_service.route(
      r.src.location!,
      r.dest.location!,
    );
    res.json({ routes });
  } else {
    try {
      let srcLocation: GeoLocation;
      let destLocation: GeoLocation;

      if (r.src.kind === "address") {
        const postcode = r.src.address?.postcode?.trim();
        if (!postcode) {
          throw new Error("Source address must include a postcode.");
        }
        srcLocation = await routing_service.geolookup(postcode);
      } else {
        srcLocation = r.src.location!;
      }

      if (r.dest.kind === "address") {
        const postcode = r.dest.address?.postcode?.trim();
        if (!postcode) {
          throw new Error("Destination address must include a postcode.");
        }
        destLocation = await routing_service.geolookup(postcode);
      } else {
        destLocation = r.dest.location!;
      }

      const routes = await routing_service.route(srcLocation, destLocation);
      res.json({ routes });
    } catch (error) {
      console.error(error);
      const err = error as Error;
      res.status(500).json({ message: err.message });
    }
  }
});

// catchall error handler with json response
// eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/no-unused-vars
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
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
