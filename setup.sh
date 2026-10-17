#!/usr/bin/env bash
# Copyright (c) 2026 Cosmo Kay. MIT License; see LICENSE.
set -euo pipefail
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if ! command -v python3 >/dev/null 2>&1; then
    echo 'Python 3 is required (included with SteamOS).' >&2
    exit 1
fi
# Keep explicit command-line options available without duplicating the installer.
if (( $# )); then
    exec python3 "$script_dir/setup.py" "$@"
fi
if [[ $(uname -s) != Linux ]]; then
    echo 'Run this script on your Steam Deck or Linux PC.' >&2
    exit 1
fi
for tool in curl sha256sum; do
    command -v "$tool" >/dev/null 2>&1 || { echo "Required tool missing: $tool" >&2; exit 1; }
done
printf '\n2K5 Remade — Steam Deck setup\n'
printf 'Known issue: the tested stock release crashes before the menu.\n'
printf 'This sets up a separate installation; it does not fix that crash.\n\n'
read -r -p 'Continue with this experimental setup? [y/N] ' answer
[[ $answer == y || $answer == Y ]] || exit 0
steam=''
for candidate in "$HOME/.local/share/Steam" "$HOME/.steam/steam"; do
    if [[ -d $candidate/steamapps ]]; then steam=$candidate; break; fi
done
read -r -p "Steam folder [${steam:-enter path}]: " value
steam=${value:-$steam}
[[ -d $steam/steamapps ]] || { echo 'Steam folder not found.' >&2; exit 1; }
proton="$steam/steamapps/common/Proton - Experimental/proton"
if [[ ! -f $proton ]]; then
    echo 'Install Proton Experimental in Steam → Library → Tools, then rerun setup.' >&2
    echo 'For another installed Proton version, supply --proton and the other setup.py options.' >&2
    exit 1
fi
printf '\nEnter paths without surrounding quotes. Spaces are supported.\n'
read -r -p 'Extracted Xbox disc folder (contains default.xbe and vc_53450030): ' disc
# Expand a typed ~/ without evaluating arbitrary shell input.
disc=${disc/#\~\//$HOME/}
[[ -f $disc/default.xbe && -d $disc/vc_53450030 ]] || {
    echo 'That is not a complete extracted Xbox disc folder.' >&2; exit 1;
}
output="$HOME/Games/2K5-Repack-Proton"
read -r -p "New install folder [$output]: " value
output=${value:-$output}
output=${output/#\~\//$HOME/}
[[ ! -e $output && ! -L $output ]] || { echo 'Choose an install folder that does not already exist.' >&2; exit 1; }
cache="${XDG_CACHE_HOME:-$HOME/.cache}/2k5-repack-proton/v0.6.1-hotfix"
mkdir -p -- "$cache"
installer="$cache/NFL2K5-PC-Setup.exe"
expected=37600d962775721db113328844da5aa8148a0633b94b976d6a2eee6d1514a588
valid_installer() {
    [[ -f $installer ]] && [[ $(sha256sum -- "$installer" | cut -d ' ' -f1) == "$expected" ]]
}
if ! valid_installer; then
    echo 'Downloading the original repack installer (about 165 MiB)…'
    partial=$(mktemp "$cache/installer.XXXXXX")
    trap 'rm -f -- "${partial:-}"' EXIT
    curl --fail --location --proto '=https' --tlsv1.2 \
        --output "$partial" \
        'https://github.com/BeyondTomrrow/2K5Remade/releases/download/v0.6.1-hotfix/NFL2K5-PC-Setup.exe'
    actual=$(sha256sum -- "$partial" | cut -d ' ' -f1)
    [[ $actual == "$expected" ]] || { echo 'Installer checksum mismatch; stopping.' >&2; exit 1; }
    mv -- "$partial" "$installer"
    trap - EXIT
fi
args=(--installer "$installer" --disc "$disc" --proton "$proton" --steam "$steam" --output "$output")
if command -v steamos-add-to-steam >/dev/null 2>&1; then
    args+=(--add-to-steam)
fi
python3 "$script_dir/setup.py" "${args[@]}"
printf '\nSetup finished. In Steam, use 2K5 Remade (Repack).\n'
printf 'Leave Force compatibility tool OFF and select the Gamepad template.\n'
printf 'If no shortcut appeared, add %s/play.sh as a non-Steam game.\n' "$output"
printf 'The stock startup crash remains unresolved; see TESTING.md.\n'
