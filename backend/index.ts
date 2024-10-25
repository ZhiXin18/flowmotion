/*
 * Flowmotion
 * Backend
 * Entrypoint
 */
import express, { Express } from "express";
import { initialize } from "express-openapi";

const app: Express = express();
const port = process.env.PORT || 3000;

initialize({
  app,
  apiDoc: "../schema/flowmotion_api.yaml",
  paths: "routes",
});

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
