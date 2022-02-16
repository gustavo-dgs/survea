self.addEventListener("install", event =>  {
    event.waitUntil(preLoad());
});

var preLoad = async function () {
    //console.log("Installing web app");
    console.log("Service worker installed");
    const cache = await caches.open("offline");
    console.log("caching index and important routes");
    return await cache.addAll(["/", "user/2", "/offline.html"]);
};

self.addEventListener("activate", event => {
    console.log("Service worker activated");
});

self.addEventListener("fetch", function (event) {
    event.respondWith(checkResponse(event.request).catch(function () {
        return returnFromCache(event.request);
    }));
    event.waitUntil(addToCache(event.request));
});

var checkResponse = function (request) {
    return new Promise(function (fulfill, reject) {
        fetch(request).then(function (response) {
            if (response.status !== 404) {
                fulfill(response);
            } else {
                reject();
            }
        }, reject);
    });
};

var addToCache = async function (request) {
    const cache = await caches.open("offline");
    const response = await fetch(request);
    console.log(response.url + " was cached");
    return await cache.put(request, response);
};

var returnFromCache = async function (request) {
    const cache = await caches.open("offline");
    const matching = await cache.match(request);
    if (!matching || matching.status == 404) {
        return cache.match("offline.html");
    } else {
        return matching;
    }
};