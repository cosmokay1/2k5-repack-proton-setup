# 2K5 Remade: Proton setup

A small setup helper by [Cosmo Kay](https://github.com/cosmokay1) for running the
**original Windows repack** on Steam Deck or a Linux PC with Steam and Proton.
No franchise AI, sidecar, custom game build, ray tracing, or launcher application.
A shell script starts the repack through Proton; it has no UI or background service.

The repack is [BeyondTomrrow/2K5Remade](https://github.com/BeyondTomrrow/2K5Remade).
This project is independent setup tooling, not the game or an official release.

## Current compatibility result

**Setup completes, but this stock release is not yet playable in the tested clean
Proton configuration.** On October 16, 2026, `v0.6.1-hotfix` crashed during Xbox
memory initialization under Proton Experimental, both in `--validate` and through
its Steam shortcut. This helper is available for reproduction and setup work;
it is not a verified working Deck package. See [TESTING.md](TESTING.md).

## What you need

- An x86-64 Linux PC or Steam Deck, Steam, Python 3, and an installed Proton version.
- The original `NFL2K5-PC-Setup.exe` from the upstream releases page.
- Your own extracted **Xbox** NFL 2K5 disc folder containing `default.xbe` and
  `vc_53450030`. A PS2 ISO does not work with this repack.
- Space for a fresh Proton prefix and the repack. Your disc files stay where they are.

This tool downloads nothing and includes no game, disc, BIOS, Microsoft DLLs or
Proton files. The instructions use Proton Experimental; see TESTING.md for the
exact tested version and acceptance results.

## Steam Deck: install

1. Switch to Desktop Mode. In Steam, install **Proton Experimental** from Library
   → Tools if it is not already installed. Download/extract this setup repo.
2. Download the upstream Windows installer and extract your own Xbox disc.
3. Open Konsole in this repo. Run the following, replacing the installer and disc
   paths with your own. The output directory **must not already exist**:

```sh
python3 setup.py \
  --installer "$HOME/Downloads/NFL2K5-PC-Setup.exe" \
  --disc "$HOME/Games/NFL2K5-disc" \
  --proton "$HOME/.local/share/Steam/steamapps/common/Proton - Experimental/proton" \
  --steam "$HOME/.local/share/Steam" \
  --output "$HOME/Games/2K5-Repack-Proton" \
  --add-to-steam
```

4. In Steam, find **2K5 Remade (Repack)**. If the add helper is unavailable, choose
   Games → Add a Non-Steam Game → Browse and select `play.sh` in the output folder.
5. Leave Steam's **Force compatibility tool** unchecked for this shortcut: the
   script already invokes the Proton version you selected. Choose the standard
   **Gamepad** Steam Input template. Return to Gaming Mode and launch it there.

The script preserves Steam's shortcut identity, which is needed for gamepad
mapping. Launching outside Steam in Desktop Mode may use desktop mouse controls.
Do not copy your franchise addon or graphics experiment into this installation.

On another Linux PC, use the actual Steam and Proton paths on that PC. Custom
Steam library locations are supported by passing their explicit paths. Automatic
shortcut addition is Deck-only; Steam's manual Add a Non-Steam Game works elsewhere.

## What changes

All setup output goes under the new output directory: `game/`, `prefix/`,
`play.sh`, optional desktop entry, logs and receipts. The helper first creates `original/disc` as a Linux symlink to your extracted
disc; the stock installer validates and reuses it. This avoids Wine turning the
installer’s Windows junction command into an empty `disc?` directory. No executable patch or source build.
The helper clears inherited `NFL2K5_*` and `RECOMP_*` developer settings, and uses
a new prefix instead of your existing franchise or experimental prefix.
The repack may create its own normal user files within this new prefix/game folder.
The installer may create its own Windows shortcuts inside the prefix.

Keep the helper directory and disc in place; generated paths are absolute. To move
or upgrade, use a new output directory and rerun setup rather than overwriting it.
Back up saves before deleting an installation. Remove its non-Steam shortcut
through Steam. This helper never uninstalls your disc or existing game installation.

## If it fails

- Installation: read `setup-proton.log` and `installer.log` in the output folder.
  Failed installs are retained for diagnosis; retry into a **new** output folder.
- Launch: run `./play.sh` from Konsole and inspect the game's own logs. A successful
  installer or validation command does not prove gameplay works.
- Controls: launch from Gaming Mode, select Gamepad, and check that compatibility
  is not forced on `play.sh`.
- Missing disc: confirm `default.xbe` and `vc_53450030` still exist at the path used
  during setup. Do not download retail assets from this project.

## Development and license

```sh
python3 -m unittest -v
```

MIT License, Copyright (c) 2026 Cosmo Kay, for **this setup tooling only**.
The upstream repack, Proton, Steam and game assets retain their own terms and
credits. No rights to redistribute them are granted by this project's license.
