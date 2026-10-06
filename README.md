# Steam Windows on Mac

Steam for Windows running on an Apple silicon Mac, for free — so Windows-only games (Happy
Wheels was the reason) start on a Mac like on a PC. No CrossOver, no virtual machine: a free,
open-source [Sikarugir](https://github.com/Sikarugir-App/Sikarugir) wrapper with Wine inside, set
up so it opens like a normal app, sits in the Dock, has its own icon and draws at full Retina
resolution.

*[Po polsku niżej.](#po-polsku)*

<p><img src="Icon/icon.png" width="160" alt="Steam Windows icon"></p>

Tested on a MacBook Air M1, macOS 27, October 2026.

## Install

1. Download this repo: **Code → Download ZIP**, and open the zip.
2. Double-click **Install Steam Windows.command**.
3. Do what it asks — there are two moments where you click:
   - in **Sikarugir Creator**, pick the engine **WS12WineSikarugir11.0_1** and create an app
     named `Steam Windows.app` in the `Sikarugir` folder;
   - in the **Steam installer**, click through and untick **Run Steam** at the end.
4. Open **Steam Windows** from Applications → Sikarugir. The first start updates Steam; then
   sign in.

If macOS says the `.command` file can't be opened: right-click it → **Open** → **Open**.

Sikarugir Creator is installed with [Homebrew](https://brew.sh) if you have it; otherwise the
script opens its download page. Windows games need Rosetta 2:
`softwareupdate --install-rosetta --agree-to-license`.

### Your settings from Steam for Mac

After signing in to Steam Windows once, quit it and run **Install Steam Windows.command** again.
It asks whether to copy client settings and launch options, your custom library artwork and
collections from Steam for Mac, and backs up the old ones first. It leaves `config.vdf` alone —
it holds Mac paths and the login.

### Terminal way

Same result, step by step, for those who'd rather see each part. After creating `Steam
Windows.app` in Sikarugir Creator (as above):

```
./setup.sh install    # puts the Steam installer in the wrapper; open the wrapper and click through it
./setup.sh finish     # runs Steam instead of the installer, Dock icon, icon, Retina
./setup.sh settings   # optional: settings from Steam for Mac (quit both Steams first)
```

## Games in Applications and the Dock

Double-click **Make Game Shortcuts.command**. For every game installed in Steam Windows it makes a
small app with the game's icon in Applications → Steam Windows Games — drag it to the Dock.
Clicking it starts Steam Windows if needed and launches the game. Run it again after installing a
new game.

While a game runs, the Dock shows Steam Windows, not the game: every game runs inside the one
wrapper.

## What the installer sets

- **Retina mode** — Wine draws at the screen's full resolution instead of half and scaling up,
  so Steam and games are sharp. Windows text is set to 200% so it keeps its size.
- **Dock icon** — Sikarugir makes wrappers background-only; the installer turns that off.
- **Icon** — the Steam circle with the Sikarugir icon (`Icon/make-icon.swift` builds it).

## Good to know

- **Quitting takes a while.** After Steam → Exit, Steam saves settings, syncs cloud saves and
  closes its processes, all slower under Wine. Wait until the icon leaves the Dock; don't force
  quit, or cloud saves and settings may not be written.
- Run the installer only while Steam Windows is closed — Wine rewrites its settings on exit.

## What did not work

Kept here so nobody has to repeat it:

| Tried | Result |
| --- | --- |
| CrossOver | Works, but it is paid |
| Wine Staging 11.18 (Gcenx build) | Steam starts, the sign-in window stays black |
| WineCX 24.0.7 engine | Windows show, Steam fails with error 0x3008 |
| Sikarugir engine and template set up by hand | `wineboot` fails; the wrapper needs Sikarugir Creator to make it |
| Copying the Mac Steam login into Windows Steam | Ignored, you still sign in |

## Credits

[Sikarugir](https://github.com/Sikarugir-App/Sikarugir) and its Wine engines do the real work.
Steam is a trademark of Valve; Sikarugir's icon belongs to its authors. This repo only has
scripts, an icon and this guide.

---

## Po polsku

Windowsowy Steam na Macu z Apple silicon, za darmo, żeby gry tylko na Windows (powodem było
Happy Wheels) uruchamiały się na Macu jak na PC. Bez CrossOvera i bez maszyny wirtualnej:
darmowe, otwartoźródłowe opakowanie [Sikarugir](https://github.com/Sikarugir-App/Sikarugir) z Wine
w środku, ustawione tak, że otwiera się jak zwykła aplikacja, siedzi w Docku, ma własną ikonę i
rysuje w pełnej rozdzielczości Retina.

Sprawdzone na MacBooku Air M1, macOS 27, październik 2026.

### Instalacja

1. Pobierz to repo: **Code → Download ZIP** i otwórz zip.
2. Kliknij dwa razy **Install Steam Windows.command**.
3. Rób, o co prosi — klikasz w dwóch momentach:
   - w **Sikarugir Creator** wybierz silnik **WS12WineSikarugir11.0_1** i utwórz aplikację
     `Steam Windows.app` w folderze `Sikarugir`;
   - w **instalatorze Steama** przeklikaj do końca i odznacz **Uruchom Steam**.
4. Otwórz **Steam Windows** z Aplikacje → Sikarugir. Pierwszy start aktualizuje Steama, potem
   się zaloguj.

Jeśli macOS nie chce otworzyć pliku `.command`: kliknij go prawym → **Otwórz** → **Otwórz**.

Sikarugir Creator instaluje się przez [Homebrew](https://brew.sh), jeśli go masz; jeśli nie,
skrypt otworzy stronę pobierania. Gry z Windows potrzebują Rosetty 2:
`softwareupdate --install-rosetta --agree-to-license`.

#### Ustawienia ze Steama na Maca

Po pierwszym zalogowaniu w Steam Windows zamknij go i uruchom **Install Steam Windows.command**
jeszcze raz. Zapyta, czy skopiować ustawienia klienta i opcje uruchamiania, własne okładki w
bibliotece i kolekcje ze Steama na Maca, a najpierw zrobi kopię starych. Nie rusza `config.vdf`,
bo są w nim ścieżki z Maca i logowanie.

#### Przez terminal

To samo krok po kroku, dla tych, którzy wolą widzieć każdą część. Po utworzeniu `Steam
Windows.app` w Sikarugir Creator (jak wyżej):

```
./setup.sh install    # wrzuca instalator Steama do opakowania; otwórz opakowanie i przeklikaj go
./setup.sh finish     # Steam zamiast instalatora, ikona w Docku, ikona, Retina
./setup.sh settings   # opcjonalnie: ustawienia ze Steama na Maca (zamknij oba Steamy)
```

### Gry w Aplikacjach i w Docku

Kliknij dwa razy **Make Game Shortcuts.command**. Dla każdej gry zainstalowanej w Steam Windows
robi małą aplikację z ikoną gry w Aplikacje → Steam Windows Games — przeciągnij ją do Docka.
Kliknięcie włącza Steam Windows, jeśli trzeba, i uruchamia grę. Po zainstalowaniu nowej gry
uruchom skrypt jeszcze raz.

Kiedy gra działa, w Docku jest Steam Windows, a nie gra: wszystkie gry działają w jednym
opakowaniu.

### Co ustawia instalator

- **Tryb Retina** — Wine rysuje w pełnej rozdzielczości ekranu zamiast w połowie i rozciągania,
  więc Steam i gry są ostre. Tekst Windowsa jest na 200%, żeby nie zrobił się malutki.
- **Ikona w Docku** — Sikarugir robi opakowania działające w tle; instalator to wyłącza.
- **Ikona** — kółko Steama z ikoną Sikarugira (buduje ją `Icon/make-icon.swift`).

### Dobrze wiedzieć

- **Zamykanie trwa dłużej.** Po Steam → Wyjdź Steam zapisuje ustawienia, synchronizuje zapisy z
  chmurą i zamyka procesy, a pod Wine wszystko to jest wolniejsze. Poczekaj, aż ikona zniknie z
  Docka; nie zamykaj na siłę, bo zapisy w chmurze i ustawienia mogą się nie zapisać.
- Instalator uruchamiaj tylko przy zamkniętym Steam Windows — Wine nadpisuje ustawienia przy
  wyłączaniu.

### Co nie zadziałało

| Próba | Wynik |
| --- | --- |
| CrossOver | Działa, ale jest płatny |
| Wine Staging 11.18 (build Gcenx) | Steam startuje, okno logowania zostaje czarne |
| Silnik WineCX 24.0.7 | Okna się pokazują, Steam wywala błąd 0x3008 |
| Silnik i szablon Sikarugira złożone ręcznie | `wineboot` nie startuje; opakowanie musi zrobić Sikarugir Creator |
| Skopiowanie logowania ze Steama na Maca | Ignorowane, i tak trzeba się zalogować |

### Podziękowania

Całą robotę robi [Sikarugir](https://github.com/Sikarugir-App/Sikarugir) i jego silniki Wine.
Steam to znak towarowy Valve, ikona Sikarugira należy do jego autorów. W tym repo są tylko
skrypty, ikona i ten poradnik.
