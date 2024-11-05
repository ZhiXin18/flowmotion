/*
 * Flowmotion
 * Backend
 * Caching Fetch implementation
 */

import TTLCache from "@isaacs/ttlcache";

// Serialized Fetch Response
interface ResponseData {
  body: ArrayBuffer; // The response body as an ArrayBuffer
  headers: Record<string, string>; // Headers as a plain object
  status: number; // HTTP status code
  statusText: string; // HTTP status text
}

/**
 * Serializes a Fetch Response object.
 *
 * @param response - The Fetch Response object to be serialized.
 * @returns A Promise that resolves to an object containing the serialized response data.
 */
async function serializeResponse(response: Response): Promise<ResponseData> {
  // read body as ArrayBuffer
  const responseBody = await response.clone().arrayBuffer();
  return {
    body: responseBody,
    headers: Object.fromEntries(response.headers.entries()),
    status: response.status,
    statusText: response.statusText,
  };
}

/**
 * Deserializes a serialized response object back into a Fetch Response object.
 *
 * @param serialized - The serialized response object containing response data.
 * @returns A Promise that resolves to a Fetch Response object.
 */
async function deserializeResponse(data: ResponseData): Promise<Response> {
  const { body, headers, status, statusText } = data;
  // construct a new Fetch Response object using the deserialized data
  return new Response(new Blob([body]), {
    status,
    statusText,
    headers: new Headers(headers),
  });
}

/**
 * Creates a caching version of the fetch function that stores responses in a TTL cache.
 *
 * This function takes caching options and returns a fetch function that checks the cache
 * for previously fetched responses if request Cache-Control permits
 * (ie. 'no-cache' and 'no-store' directives are absent).
 * If a response is cached, it is returned directly.
 * If not, a new fetch request is made, and the response is cached for future use. .
 *
 * When a response is fetched from the cache, the "X-Cache" header is set to "HIT".
 * If a fresh fetch is made and the response is successful, it will be cached and
 * the "X-Cache" header will set to "MISS".
 *
 * @param {Object} cacheOpts - Options for configuring the TTL cache.
 * @param {number} cacheOpts.ttl - Time-to-live for cached responses, in milliseconds.
 * @param {number} [cacheOpts.maxSize] - (Optional) Maximum number of items in the cache.
 *
 * @returns {Function} A fetch function that supports caching.
 */
export function CachingFetch(
  cacheOpts: TTLCache.Options<string, ResponseData>,
): typeof fetch {
  const cache = new TTLCache<string, ResponseData>(cacheOpts);
  return async (url, options) => {
    // extract cache-control header from options
    const cacheControl = new Set(
      new Headers(options?.headers)
        .get("Cache-Control")
        ?.split(",")
        .map((t) => t.trim()),
    );

    // construct caching key: fetch requests are unique by url + fetch options
    const key = `${url}-${JSON.stringify(options)}`;

    if (!cacheControl.has("no-store") && !cacheControl.has("no-cache")) {
      // attempt to fetch from cache
      // return cached response if any
      const cachedData = cache.get(key);
      if (cachedData) {
        const response = await deserializeResponse(cachedData);
        response.headers.set("X-Cache", "HIT");
        return response;
      }
    }
    // cache miss: perform actual fetch request
    const response = await fetch(url, options);
    // save response in cache if request was successful & allowed by cache-control
    if (
      response.ok &&
      !cacheControl.has("no-store") &&
      !cacheControl.has("no-cache")
    ) {
      cache.set(key, await serializeResponse(response));
    }

    // tag response with x-cache header
    // create a copy of response since response headers from fetch is immutable
    const tagResponse = new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: new Headers(response.headers),
    });
    tagResponse.headers.set("X-Cache", "MISS");
    return tagResponse;
  };
}
