"use strict";
/*
 * Flowmotion
 * Backend
 * Congestion Service
 */
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g = Object.create((typeof Iterator === "function" ? Iterator : Object).prototype);
    return g.next = verb(0), g["throw"] = verb(1), g["return"] = verb(2), typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CongestionSvc = void 0;
var date_1 = require("../date");
var date_fns_1 = require("date-fns");
var CongestionSvc = /** @class */ (function () {
    function CongestionSvc(db, collection) {
        if (collection === void 0) { collection = "congestions"; }
        var _this = this;
        this.db = db;
        this.collection = collection;
        /**
         * Retrieves the date when traffic congestion data was last updated.
         *
         * This method queries the specified database collection, orders documents by the `updated_on`
         * field in descending order, and returns the latest update date.
         *
         * @returns A promise that resolves to a date of the last update to traffic congestion data.
         * @throws Throws an error if the query fails or if no documents are found in the collection.
         */
        this.lastUpdatedOn = function () { return __awaiter(_this, void 0, void 0, function () {
            var latest;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this.db
                            .collection(this.collection)
                            .orderBy("updated_on", "desc")
                            .limit(1)
                            .get()];
                    case 1:
                        latest = _a.sent();
                        if (latest.size < 1) {
                            throw new Error("Expected at least 1 Congestion document in Firestore.");
                        }
                        return [2 /*return*/, new Date(latest.docs[0].data().updated_on)];
                }
            });
        }); };
        /**
         * Retrieve congestion data within an optional time range and/or for a specific camera.
         *
         * @param params - The parameters for querying congestion data.
         * @returns A promise resolving to an array of congestion data objects matching the query criteria.
         *
         * @description Returns traffic congestion data inferred from traffic cameras, optionally filtered by camera ID and/or a specific time range.
         * If neither `begin` nor `end` timestamps are provided, the function defaults to querying based on the most recent `updated_on` timestamp for optimized performance.
         */
        this.getCongestions = function () {
            var args_1 = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args_1[_i] = arguments[_i];
            }
            return __awaiter(_this, __spreadArray([], args_1, true), void 0, function (_a) {
                var query, beginDate, endDate, lastUpdated, lastUpdatedEnd, congestions;
                var _b = _a === void 0 ? {} : _a, begin = _b.begin, end = _b.end, camera_id = _b.camera_id;
                return __generator(this, function (_c) {
                    switch (_c.label) {
                        case 0:
                            query = this.db.collection(this.collection);
                            beginDate = begin != null ? new Date(begin) : null;
                            endDate = end != null ? new Date(end) : null;
                            if (!(beginDate == null || endDate == null)) return [3 /*break*/, 2];
                            return [4 /*yield*/, this.lastUpdatedOn()];
                        case 1:
                            lastUpdated = _c.sent();
                            lastUpdatedEnd = new Date((0, date_fns_1.add)(lastUpdated, { days: 1 }).getTime() - 1);
                            query = query
                                .where("updated_on", ">=", (0, date_1.formatSGT)(beginDate !== null && beginDate !== void 0 ? beginDate : lastUpdated))
                                .where("updated_on", "<", (0, date_1.formatSGT)(endDate !== null && endDate !== void 0 ? endDate : lastUpdatedEnd));
                            return [3 /*break*/, 3];
                        case 2:
                            query = query
                                .where("updated_on", ">=", (0, date_1.formatSGT)(beginDate))
                                .where("updated_on", "<", (0, date_1.formatSGT)(endDate));
                            _c.label = 3;
                        case 3:
                            // filter by camera_id if specified
                            if (camera_id != null) {
                                query = query.where("camera.id", "==", camera_id);
                            }
                            return [4 /*yield*/, query.get()];
                        case 4:
                            congestions = _c.sent();
                            // TODO(F-R-YEO): perform aggregation based on aggregation parameters
                            return [2 /*return*/, congestions.docs.map(function (d) { return d.data(); })];
                    }
                });
            });
        };
        /**
         * Retrieves congestion data for a given document ID.
         *
         * @param {string} docId - The ID of the document to retrieve from the database.
         * @returns {Promise<Congestion>} A promise that resolves to the congestion data.
         */
        this.getCongestion = function (docId) { return __awaiter(_this, void 0, void 0, function () {
            var doc;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, this.db.doc(docId).get()];
                    case 1:
                        doc = _a.sent();
                        return [2 /*return*/, doc.data()];
                }
            });
        }); };
    }
    return CongestionSvc;
}());
exports.CongestionSvc = CongestionSvc;
