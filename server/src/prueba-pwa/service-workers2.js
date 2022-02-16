

//This code executes in its own worker or thread
self.addEventListener("install", async event => {
    event.waitUntil(preLoad());
});

let preLoad = async () => {
    console.log("Service worker installed");
    const cache = await caches.open('pwa-assets');
    return cache.addAll([
        'css/app.a440f352.css',
        'css/chunk-23515940.5c55f785.css',
        'css/chunk-30099b94.8caf4ccf.css',
        'css/chunk-54e71ce5.a7b6ca95.css',
        'css/chunk-7fc753cd.fb730b49.css',
        'css/chunk-97f0bfae.ddc29be9.css',
        'css/chunk-9eb676a6.90c7f27e.css',
        'css/chunk-f18b73ba.6085bf3c.css',
        'img/profile_02.dab8565d.jpg',
        'img/icons/android-chrome-192x192.png',
        'img/icons/android-chrome-512x512.png',
        'img/icons/apple-touch-icon.png',
        'img/icons/browserconfig.xml',
        'img/icons/favicon-16x16.png',
        'img/icons/favicon-32x32.png',
        'img/icons/mstile-150x150.png',
        'img/icons/safari-pinned-tab.svg',
        'img/icons/site.webmanifest',
        'js/app.6640e378.js',
        'js/app.6640e378.js.map',
        'js/chunk-23515940.f06fd3fc.js',
        'js/chunk-23515940.f06fd3fc.js.map',
        'js/chunk-30099b94.2c60d058.js    ',
        'js/chunk-30099b94.2c60d058.js.map',
        'js/chunk-54e71ce5.631993ec.js',    
        'js/chunk-54e71ce5.631993ec.js.map',
        'js/chunk-7fc753cd.5b2090e2.js',    
        'js/chunk-7fc753cd.5b2090e2.js.map',
        'js/chunk-97f0bfae.784b2c25.js',    
        'js/chunk-97f0bfae.784b2c25.js.map',
        'js/chunk-9eb676a6.cd2cf35d.js',    
        'js/chunk-9eb676a6.cd2cf35d.js.map',
        'js/chunk-f18b73ba.b3dba22a.js',    
        'js/chunk-f18b73ba.b3dba22a.js.map',
        'js/chunk-vendors.b5c29fba.js',     
        'js/chunk-vendors.b5c29fba.js.map',
        'favicon.ico',
        'index.html',
    ]);
}

self.addEventListener("activate", event => {
    console.log("Service worker activated");
});

self.addEventListener("fetch", event => {
    //console.log(`URL requested: ${event.request.url}`);
    // if (event.request.method === 'GET') {
    //     console.log(event.request);
    // }
    //console.log(event.request);
    // Parse the URL
    if (event.request.url === 'https://survea-webapp.azurewebsites.net/api/surveyed/answer') {
        
        console.log(event.request.json());
        // event.respondWith(
        //     fetch(event.request)
        //     .catch(error => {
        //         const options = {
        //             status: 200,
        //             headers: {
        //                 'Content-type': 'application/json'
        //             }
        //          };
        //          return new Response('Survey Added', options);
        //     })
        //   );
    }

  
});

// if (/^\/article\//.test(requestURL.pathname)) {
//     event.respondWith(/* some response strategy */);
//     return;
// }
// if (/\.webp$/.test(requestURL.pathname)) {
//     event.respondWith(/* some other response strategy */);
//     return;
// }


// self.addEventListener("fetch", event => {
//     event.respondWith(
//       fetch(event.request)
//       .catch(error => {
//         return caches.match(event.request) ;
//       })
//     );
//  });