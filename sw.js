const C="milesz-v1-1",F=["./","index.html","manifest.webmanifest","icon-180.png","icon-512.png"];
self.addEventListener("install",e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(F.map(u=>new Request(u,{cache:"reload"})))));self.skipWaiting()});
self.addEventListener("activate",e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x.indexOf("milesz-")===0&&x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener("fetch",e=>{const r=e.request;if(r.method!=="GET")return;
  /* csak a saját fájlok: a Mindmegette-kérések (recept, hétmenü, képek) mennek közvetlenül a netre */
  if(new URL(r.url).origin!==self.location.origin)return;
  /* azonnal a cache-ből (gyors indulás, net nélkül is), közben a háttérben frissít a következő indításra */
  const p=caches.open(C).then(c=>{
    const net=fetch(r,{cache:"no-store"}).then(x=>x.ok?c.put(r,x.clone()).then(()=>x,()=>x):x);
    return c.match(r,{ignoreSearch:r.mode==="navigate"}).then(hit=>({hit,net}))});
  e.respondWith(p.then(({hit,net})=>hit||net));
  e.waitUntil(p.then(({net})=>net.catch(()=>{})))});
