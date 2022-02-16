let BASE_URL = 'http://localhost:4000/api';

//This code executes in its own worker or thread
self.addEventListener("install", async event => {
    event.waitUntil(preLoad());
});

let preLoad = async () => {
    console.log("Service worker installed");
    const cache = await caches.open('pwa-assets');
    return cache.addAll(['/', 'index.html', 'css/style.css', 'js/main.js', 'assets/favicon.ico', 'js/db.js']);
}

self.addEventListener("activate", event => {
    console.log("Service worker activated");
});

// self.addEventListener("fetch", async event => {
//     // const response = new Response('Esta es una respuesta');
//     // const options = {
//     //     status: 200,
//     //     headers: {
//     //      'Content-type': 'application/json'
//     //     }
//     // };
    
//     // const response = new Response({msg: 'Este es un mensaje'}, options)

//     // if (event.request.url === 'http://localhost:4000/api/login?email=email%40algo.com&password=1234') {
//     //     event.respondWith(response);
//     // }

//     // if (event.request.url === 'http://localhost:4000/api/login?email=email%40algo.com&password=1234') {
//     //     event.respondWith(response);
//     // }
    
//     // console.log('URL requested:', event.request.url);
        

// });

// self.addEventListener("fetch", event => {
//     event.respondWith(
//       caches.match(event.request)
//       .then(cachedResponse => {
//         // It can update the cache to serve updated content on the next request
//           return cachedResponse || fetch(event.request);
//       }
//     )
//    )
//  });

self.addEventListener("fetch", event => {
    event.respondWith(
      fetch(event.request)
      .catch(error => {
        return caches.match(event.request) ;
      })
    );
 });

