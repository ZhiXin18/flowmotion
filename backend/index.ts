/*
 * Flowmotion
 * Backend
 * Entrypoint
 */
import express, { Express } from "express";
import { initialize as initOpenAPI } from "express-openapi";
import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

// setup firebase / firestore db access
const firebase = initializeApp({
  projectId: "flowmotion-4e268",
});
const firestore = getFirestore(firebase);

// setup express server
const app: Express = express();
const port = process.env.PORT || 3000;
initOpenAPI({
  app,
  apiDoc: "../schema/flowmotion_api.yaml",
  paths: "routes",
  // dependency injection concrete implementations
  // eg. request handlers with 'database' parameter will be injected with a firestore instance.
  dependencies: {
    database: firestore,
  },
});
app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
