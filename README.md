# Mi lesz ma?

iPhone-ra szánt webapp (PWA, kezdőképernyőre téve), egyetlen `index.html` fájlban, étel-magazin kinézettel. A Mindmegette.hu „Heti menü” oldaláról megmutatja a mai főételt: teljes szélességű fotó, elkészítési idő, adag, hozzávalólista, az elkészítés lépései.

Funkciók:
- **Ma**: a mai főétel; a „Másik főétel” gombbal a nap másik főételére lehet váltani.
- **Hét**: a 7 nap főétele tartalomjegyzék-szerűen, koppintásra ugyanaz a részletes nézet.
- **Itthon**: közös kamralista. Egy hozzávalóra koppintva az összes receptben „megvan itthonként” jelenik meg (név alapján, pl. „35 dkg Liszt” = „liszt”). Kézzel is hozzáadható, és mutatja, mi hiányzik a mai ételhez („Megvan” gombbal).
- **Bevásárlólista küldése**: a hiányzó hozzávalókból szöveget készít, és megnyitja az iPhone megosztó lapját (Messenger, SMS…); ha az nem érhető el, a vágólapra másolja.
- **Beállítások**: Itthon lista törlése, frissítés most, verzió.

Nincs build lépés, nincs külső könyvtár, nincs webfont.

## Fájlok

| Fájl | Szerep |
|---|---|
| `index.html` | Az egész app: HTML + CSS + JS |
| `sw.js` | Service worker (`milesz-v1-1` cache, cache-first + háttérfrissítés; csak a saját fájlokat kezeli) |
| `manifest.webmanifest` | PWA manifest |
| `icon-180.png`, `icon-512.png` | App ikon |
| `tools/serve.ps1` | Helyi szerver teszteléshez (alapból 8770-as port) |

## Helyi futtatás

```
powershell -ExecutionPolicy Bypass -File tools\serve.ps1
```
Majd: http://localhost:8770/

## Telepítés (GitHub Pages)

1. A `mi-lesz-ma` GitHub repó, a fenti 5 fájl (`index.html`, `sw.js`, `manifest.webmanifest`, `icon-180.png`, `icon-512.png`) a gyökérbe. A `tools/` és a README nem kell hozzá.
2. Settings → Pages → Branch: `main`, mappa: `/ (root)`.
3. iPhone-on Safariban megnyitni az oldalt → Megosztás → „Főképernyőhöz adás”.

Új verziónál: a Beállítások alján lévő „Mi lesz ma? vX” felirat és a `sw.js` cache-neve (`milesz-v1-1` → `milesz-v1-2`) együtt léptetendő.

## Adatforrás

Az adatok **élőben, az eszközön töltődnek le** a Mindmegette.hu-ról (a `heti-menu` oldal JSON-LD listája + az egyes receptek JSON-LD adatai; a Mindmegette engedélyezi a közvetlen böngészős lekérést). A repóban semmilyen receptadat, szöveg vagy kép nem tárolódik; minden a telefon `localStorage`-ában van:

| Kulcs | Tartalom |
|---|---|
| `eb.week` | A heti menü (letöltés ideje, a hét hétfője, 28 elem) |
| `eb.rec` | Letöltött receptek (legfeljebb ~40) |
| `eb.pan` | Az „Itthon van” kamra: hozzávalónév → időbélyeg (a régi `eb.chk` pipákat egyszer átemeli, majd törli) |
| `eb.alt` | Dátumonként: a másik főétel van kiválasztva |

A menü új hétnél, illetve 12 óránál régebbi adatnál újratöltődik; net nélkül a mentett adatokból működik. A recepttartalom a Mindmegette tulajdona, az app a forrásra hivatkozik („Forrás: Mindmegette.hu”, link a recept oldalára).

## Hogyan tedd a kezdőképernyőre (családnak)

iPhone-on, egyszer kell megcsinálni:

1. Nyisd meg a kapott linket **Safariban** (ha Messengerben koppintasz rá, ott a menüből válaszd a megnyitást Safariban).
2. Koppints a **Megosztás** gombra (négyzet felfelé mutató nyíllal). Ha nem látod, a **•••** gomb alatt találod.
3. Görgess lejjebb, és válaszd a **Főképernyőhöz adás** pontot.
4. Ha látsz „Megnyitás webappként” kapcsolót, hagyd bekapcsolva.
5. Koppints a **Hozzáadás** gombra.

Ezután a **Mi lesz ma?** ikonnal indul, mint egy rendes app. Az első megnyitáshoz internet kell. Az „Itthon” lista minden telefonon külön van.
