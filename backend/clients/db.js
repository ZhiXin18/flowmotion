"use strict";
/*
 * Flowmotion
 * Backend
 * Firebase Firestore DB
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.initDB = initDB;
var firebase = require("firebase-admin/app");
var firestore_1 = require("firebase-admin/firestore");
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
function initDB() {
    // setup firebase / firestore db access
    var app = firebase.initializeApp({
        projectId: "flowmotion-4e268",
    });
    var db = (0, firestore_1.getFirestore)(app);
    return db;
}
