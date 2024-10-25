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
initializeApp({
  projectId: "flowmotion-4e268",
});
const db = getFirestore();

// setup express server
const app: Express = express();
const port = process.env.PORT || 3000;
initOpenAPI({
  app,
  apiDoc: "../schema/flowmotion_api.yaml",
  paths: "routes",
});
app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
