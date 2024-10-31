/*
 * Flowmotion
 * Backend
 * Errors
 */

/**
 * Represents an error that occurs during validation when a user provides invalid arguments.
 * Extends the standard JavaScript `Error` class with an additional `status` property, indicating
 * a HTTP status code for a "Bad Request".
 *
 * @property {number} status - HTTP status code associated with the error, set to 400 (Bad Request).
 *
 * @constructor
 * @param {string} message - A descriptive message explaining the validation error.
 *
 * @example
 * throw new ValidationError("Invalid input provided");
 */
export class ValidationError extends Error {
  status: number;

  constructor(message: string) {
    super(message);
    this.name = "ValidationError";
    // bad request status code
    this.status = 400;
  }
}
