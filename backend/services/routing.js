"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.RoutingSvc = exports.ROUTING_API = void 0;
var fs = require("fs");
var path = require("path");
var csv_parser_1 = require("csv-parser");
// OSRMText instructions
var OSRMText = require("osrm-text-instructions")("v5");
exports.ROUTING_API = "https://osrm-congestion-210524342027.asia-southeast1.run.app";
/**
 * RoutingSvc performs routing by making API calls to the OSRM API.
 */
var RoutingSvc = /** @class */ (function () {
    function RoutingSvc(apiBase, fetchFn, congestion) {
        var _this = this;
        this.apiBase = apiBase;
        this.fetchFn = fetchFn;
        this.congestion = congestion;
        this.postcodeLookup = null;
        this.postcodeDataLoading = null;
        /**
        * Calculates routes between two locations using the OSRM API.
        */
        this.route = function (src, dest) { return __awaiter(_this, void 0, void 0, function () {
            var url, response, r;
            var _this = this;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        url = new URL("/route/v1/driving/".concat(src.longitude, ",").concat(src.latitude, ";").concat(dest.longitude, ",").concat(dest.latitude), this.apiBase);
                        url.searchParams.set("steps", "true");
                        url.searchParams.set("alternatives", "true");
                        return [4 /*yield*/, this.fetchFn(url.toString())];
                    case 1:
                        response = _a.sent();
                        return [4 /*yield*/, response.json()];
                    case 2:
                        r = _a.sent();
                        // Handle response failure
                        if (!response.ok) {
                            throw new Error("OSRM ".concat(url.pathname, " request failed with error: ").concat(r["code"], ": ").concat(r["message"]));
                        }
                        // Decode response into routes
                        return [2 /*return*/, Promise.all(r.routes.map(function (route) { return __awaiter(_this, void 0, void 0, function () {
                                var _a;
                                var _this = this;
                                return __generator(this, function (_b) {
                                    switch (_b.label) {
                                        case 0:
                                            _a = {
                                                geometry: route.geometry, // Polyline for the entire route
                                                duration: route.duration,
                                                distance: route.distance
                                            };
                                            return [4 /*yield*/, Promise.all(route.legs.flatMap(function (leg) {
                                                    return leg.steps.map(function (step) { return __awaiter(_this, void 0, void 0, function () {
                                                        var _a;
                                                        var _b;
                                                        return __generator(this, function (_c) {
                                                            switch (_c.label) {
                                                                case 0:
                                                                    _b = {
                                                                        name: step.name,
                                                                        duration: step.duration,
                                                                        distance: step.distance,
                                                                        geometry: step.geometry,
                                                                        direction: step.maneuver.modifier || null,
                                                                        maneuver: step.maneuver.type,
                                                                        instruction: OSRMText.compile("en", step, {})
                                                                    };
                                                                    if (!(step.pronunciation != null)) return [3 /*break*/, 2];
                                                                    return [4 /*yield*/, this.congestion.getCongestion(step.pronunciation)];
                                                                case 1:
                                                                    _a = _c.sent();
                                                                    return [3 /*break*/, 3];
                                                                case 2:
                                                                    _a = null;
                                                                    _c.label = 3;
                                                                case 3: return [2 /*return*/, (
                                                                    // Congestion data is handled by the CongestionSvc
                                                                    _b.congestion = _a,
                                                                        _b)];
                                                            }
                                                        });
                                                    }); });
                                                }))];
                                        case 1: return [2 /*return*/, (_a.steps = _b.sent(),
                                                _a)];
                                    }
                                });
                            }); }))];
                }
            });
        }); };
        // No need to load the CSV data here
    }
    /**
     * Geocodes a postcode to obtain latitude and longitude.
     */
    RoutingSvc.prototype.geolookup = function (postcode) {
        return __awaiter(this, void 0, void 0, function () {
            var normalizedPostcode, location;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        // Load postcode data if not already loaded
                        console.log('routing.geolookup');
                        if (!!this.postcodeLookup) return [3 /*break*/, 2];
                        if (!this.postcodeDataLoading) {
                            this.postcodeDataLoading = this.loadPostcodeData();
                        }
                        return [4 /*yield*/, this.postcodeDataLoading];
                    case 1:
                        _a.sent();
                        _a.label = 2;
                    case 2:
                        normalizedPostcode = postcode.trim();
                        if (!this.postcodeLookup) {
                            throw new Error("Postcode data failed to load.");
                        }
                        location = this.postcodeLookup.get(normalizedPostcode);
                        if (!location) {
                            throw new Error("No location found for postcode: ".concat(postcode));
                        }
                        return [2 /*return*/, location];
                }
            });
        });
    };
    ;
    /**
     * Loads the postcode data from the CSV file into a Map for quick lookup.
     */
    RoutingSvc.prototype.loadPostcodeData = function () {
        var _this = this;
        return new Promise(function (resolve, reject) {
            var csvFilePath = path.resolve(__dirname, '../data/SG_postal.csv');
            _this.postcodeLookup = new Map();
            fs.createReadStream(csvFilePath)
                .pipe((0, csv_parser_1)()) // Default comma delimiter
                .on('data', function (row) {
                var _a;
                var postcode = (_a = row['postal_code']) === null || _a === void 0 ? void 0 : _a.trim();
                var latitude = parseFloat(row['lat']);
                var longitude = parseFloat(row['lon']);
                if (postcode && !isNaN(latitude) && !isNaN(longitude)) {
                    _this.postcodeLookup.set(postcode, { latitude: latitude, longitude: longitude });
                }
            })
                .on('end', function () {
                console.log('Postcode data loaded successfully.');
                resolve();
            })
                .on('error', function (error) {
                console.error('Error loading postcode data:', error);
                _this.postcodeLookup = null;
                reject(error);
            });
        });
    };
    return RoutingSvc;
}());
exports.RoutingSvc = RoutingSvc;
