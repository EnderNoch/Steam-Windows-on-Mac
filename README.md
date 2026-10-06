# Steam Windows on Mac

Steam for Windows running on an Apple silicon Mac, for free — so Windows-only games (Happy
Wheels was the reason) start on a Mac like on a PC. No CrossOver, no virtual machine: a free,
open-source [Sikarugir](https://github.com/Sikarugir-App/Sikarugir) wrapper with Wine inside, set
up so it opens like a normal app, sits in the Dock and has its own icon.

*[Po polsku niżej.](#po-polsku)*

<p><img src="Icon/icon.png" width="160" alt="Steam Windows icon"></p>

Tested on a MacBook Air M1, macOS 27, October 2026.

## What you need

- A Mac with Apple silicon and [Homebrew](https://brew.sh)
- Rosetta 2: `softwareupdate --install-rosetta --agree-to-license`
- Steam for Mac in Applications (only for the icon and for copying your settings)

## Setup

1. Install Sikarugir Creator:

   ```
   brew trust Sikarugir-App/sikarugir
   brew install --cask Sikarugir-App/sikarugir/sikarugir
   ```

2. Open **Sikarugir Creator** and download the engine **WS12WineSikarugir11.0_1**.
3. Click **Create empty app**, name it `Steam Windows.app`, leave it in the `Sikarugir` folder
   and click **Save**.
4. Put the Steam installer in the wrapper:

   ```
   ./setup.sh install
   ```

5. Double-click **Steam Windows** in `~/Applications/Sikarugir`, click through the installer and
   untick **Run Steam** at the end.
6. Switch the wrapper to Steam, add the icon and the Dock icon:

   ```
   ./setup.sh finish
   ```

7. Open **Steam Windows**. The first start updates Steam; then sign in.

### Optional: your settings from Steam for Mac

Quit both Steams, then:

```
./setup.sh settings
```

It copies client settings and launch options (`localconfig.vdf`), your custom library artwork
(`grid`) and collections (`sharedconfig.vdf`), and backs up the old ones first. It leaves
`config.vdf` alone — it holds Mac paths and the login.

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
Steam is a trademark of Valve; Sikarugir's icon belongs to its authors. This repo only has a
setup script, an icon and this guide.

---

## Po polsku

Windowsowy Steam na Macu z Apple silicon, za darmo, żeby gry tylko na Windows (powodem było
Happy Wheels) uruchamiały się na Macu jak na PC. Bez CrossOvera i bez maszyny wirtualnej:
darmowe, otwartoźródłowe opakowanie [Sikarugir](https://github.com/Sikarugir-App/Sikarugir) z Wine
w środku, ustawione tak, że otwiera się jak zwykła aplikacja, siedzi w Docku i ma własną ikonę.

Sprawdzone na MacBooku Air M1, macOS 27, październik 2026.

### Co jest potrzebne

- Mac z Apple silicon i [Homebrew](https://brew.sh)
- Rosetta 2: `softwareupdate --install-rosetta --agree-to-license`
- Steam na Maca w Aplikacjach (tylko do ikony i do skopiowania ustawień)

### Instalacja

1. Zainstaluj Sikarugir Creator:

   ```
   brew trust Sikarugir-App/sikarugir
   brew install --cask Sikarugir-App/sikarugir/sikarugir
   ```

2. Otwórz **Sikarugir Creator** i pobierz silnik **WS12WineSikarugir11.0_1**.
3. Kliknij **Create empty app**, nazwij ją `Steam Windows.app`, zostaw w folderze `Sikarugir`
   i kliknij **Save**.
4. Wrzuć instalator Steama do opakowania:

   ```
   ./setup.sh install
   ```

5. Kliknij dwa razy **Steam Windows** w `~/Applications/Sikarugir`, przeklikaj instalator i na
   końcu odznacz **Uruchom Steam**.
6. Przestaw opakowanie na Steama, dodaj ikonę i ikonę w Docku:

   ```
   ./setup.sh finish
   ```

7. Otwórz **Steam Windows**. Pierwszy start aktualizuje Steama, potem się zaloguj.

### Opcjonalnie: ustawienia ze Steama na Maca

Zamknij oba Steamy, potem:

```
./setup.sh settings
```

Kopiuje ustawienia klienta i opcje uruchamiania (`localconfig.vdf`), własne okładki w bibliotece
(`grid`) i kolekcje (`sharedconfig.vdf`), a najpierw robi kopię starych. Nie rusza `config.vdf`,
bo są w nim ścieżki z Maca i logowanie.

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
Steam to znak towarowy Valve, ikona Sikarugira należy do jego autorów. W tym repo jest tylko
skrypt, ikona i ten poradnik.
