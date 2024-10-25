/*
 * Flowmotion
 * Backend
 * Firebase Firestore DB
 */

import * as firebase from "firebase-admin/app";
import { Firestore, getFirestore } from "firebase-admin/firestore";

/**
 * Initializes and returns a Firestore database instance.
 *
 * This function sets up access to Firebase Firestore by initializing a Firebase app
 * with the specified project ID, and then returns the Firestore database instance 
 * associated with this app.
 *
 * @function
 * @returns {Firestore} A Firestore database instance connected to the specified project.
 */
export function initDB(): Firestore {
  // setup firebase / firestore db access
  const app = firebase.initializeApp({
    projectId: "flowmotion-4e268",
  });
  const db = getFirestore(app);
  return db;
}
