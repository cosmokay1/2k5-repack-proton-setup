# 2K5 Remade: Proton setup

Set up the [2K5 Remade Windows repack](https://github.com/BeyondTomrrow/2K5Remade)
on Steam Deck or Linux using Proton.

**Work in progress:** installation works, but the tested stock release crashes
before reaching the menu. See [test results](TESTING.md).

## Setup on Steam Deck

1. Switch to Desktop Mode and install **Proton Experimental** from Steam → Library → Tools.
2. Download and extract this repo.
3. Have your own extracted Xbox disc ready. Its folder must contain `default.xbe`
   and `vc_53450030`.
4. Open Konsole in this repo and run:

```sh
bash setup.sh
```

The script finds Steam and Proton Experimental, asks for your disc and installation
folders, downloads and verifies the original repack installer, installs into a
fresh Proton prefix, and adds a Steam shortcut. Python 3 is required and is
included with SteamOS. It does not need sudo or a separate PC.

5. Find **2K5 Remade (Repack)** in Steam. Leave **Force compatibility tool**
   unchecked—the script already starts Proton. Select the **Gamepad** controller
   template and launch from Gaming Mode.

If it doesn't appear in Steam, add `play.sh` from the output folder as a non-Steam
game. On other Linux PCs, adjust the Steam and Proton paths and add it manually.

## Troubleshooting

Check `setup-proton.log` and `installer.log` in the output folder. Keep your disc
folder in place. Retry failed installations into a new output folder.

This helper uses a separate Proton prefix and leaves existing installations alone.
It includes no game files and does not modify the repack executable.

## Credits and license

Repack: [BeyondTomrrow/2K5Remade](https://github.com/BeyondTomrrow/2K5Remade).
Setup helper: [Cosmo Kay](https://github.com/cosmokay1), [MIT License](LICENSE).
The repack and game assets retain their own terms and credits.
