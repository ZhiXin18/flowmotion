"use strict";
/*
 * Flowmotion
 * Backend
 * Entrypoin
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
Object.defineProperty(exports, "__esModule", { value: true });
if (process.env.NODE_ENV === 'development') {
    Object.keys(require.cache).forEach(function (key) { return delete require.cache[key]; });
}
var express_1 = require("express");
var congestion_1 = require("./services/congestion");
var db_1 = require("./clients/db");
var OpenApiValidator = require("express-openapi-validator");
var routing_1 = require("./services/routing");
var routing_2 = require("./services/routing");
// parse command line args
if (process.argv.length < 4) {
    console.error("Usage: index.ts <OPENAPI_YAML> <PORT>");
    process.exit(1);
}
var apiYaml = process.argv[2];
var port = parseInt(process.argv[3]);
// setup services
var db = (0, db_1.initDB)();
var congestion = new congestion_1.CongestionSvc(db);
var routing_service = new routing_2.RoutingSvc(routing_1.ROUTING_API, fetch, congestion);
// setup express server
var app = express_1();
// parse json in request body
app.use(express_1.json());
// validate requests / responses against openapi schema
app.use(OpenApiValidator.middleware({
    apiSpec: apiYaml,
    validateRequests: true,
    // turn off response validation for performance in production
    validateResponses: app.get("env") != "production",
}));
app.get("/congestions", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var _a, _b;
    return __generator(this, function (_c) {
        switch (_c.label) {
            case 0:
                _b = (_a = res).json;
                return [4 /*yield*/, congestion.getCongestions(req.query)];
            case 1:
                _b.apply(_a, [_c.sent()]);
                return [2 /*return*/];
        }
    });
}); });
app.post("/route", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var r, routes, srcLocation, destLocation, postcode, postcode, routes, error_1, err;
    var _a, _b, _c, _d;
    return __generator(this, function (_e) {
        switch (_e.label) {
            case 0:
                r = req.body;
                if (!(r.src.kind === "location" && r.dest.kind === "location")) return [3 /*break*/, 2];
                return [4 /*yield*/, routing_service.route(r.src.location, r.dest.location)];
            case 1:
                routes = _e.sent();
                res.json({ routes: routes });
                return [3 /*break*/, 11];
            case 2:
                _e.trys.push([2, 10, , 11]);
                srcLocation = void 0;
                destLocation = void 0;
                if (!(r.src.kind === "address")) return [3 /*break*/, 4];
                postcode = (_b = (_a = r.src.address) === null || _a === void 0 ? void 0 : _a.postcode) === null || _b === void 0 ? void 0 : _b.trim();
                if (!postcode) {
                    throw new Error("Source address must include a postcode.");
                }
                return [4 /*yield*/, routing_service.geolookup(postcode)];
            case 3:
                srcLocation = _e.sent();
                return [3 /*break*/, 5];
            case 4:
                srcLocation = r.src.location;
                _e.label = 5;
            case 5:
                if (!(r.dest.kind === "address")) return [3 /*break*/, 7];
                postcode = (_d = (_c = r.dest.address) === null || _c === void 0 ? void 0 : _c.postcode) === null || _d === void 0 ? void 0 : _d.trim();
                if (!postcode) {
                    throw new Error("Destination address must include a postcode.");
                }
                return [4 /*yield*/, routing_service.geolookup(postcode)];
            case 6:
                destLocation = _e.sent();
                return [3 /*break*/, 8];
            case 7:
                destLocation = r.dest.location;
                _e.label = 8;
            case 8: return [4 /*yield*/, routing_service.route(srcLocation, destLocation)];
            case 9:
                routes = _e.sent();
                res.json({ routes: routes });
                return [3 /*break*/, 11];
            case 10:
                error_1 = _e.sent();
                console.error(error_1);
                err = error_1;
                res.status(500).json({ message: err.message });
                return [3 /*break*/, 11];
            case 11: return [2 /*return*/];
        }
    });
}); });
// catchall error handler with json response
// eslint-disable-next-line @typescript-eslint/no-explicit-any
app.use(function (err, _req, res) {
    console.error(err);
    // format error
    res.status(err.status || 500).json({
        message: err.message,
    });
});
// listen for requests
app.listen(port, function () {
    console.log("[server]: Running in ".concat(app.get("env"), " environment"));
    console.log("[server]: Listening at http://localhost:".concat(port));
});
