# Clean-install test — October 16, 2026

**Updated result: the unchanged published repack boots, accepts controller input,
and runs exhibition gameplay on the Deck. The original ESPN scorebug is visible.**
The owner confirmed gameplay and controls. A captured frame shows the ESPN bug
with score, possession, down/distance, quarter/game clock and play clock.

No source-built game, franchise addon, sidecar, ray tracing or copied existing
Proton prefix was used for the working session. The setup now installs a standard
Microsoft shader-compiler dependency and writes ordinary stock settings.

## Reproduction

- Upstream: BeyondTomrrow/2K5Remade `v0.6.1-hotfix`.
- Download: upstream release asset `NFL2K5-PC-Setup.exe` (172,591,559 bytes).
- Installer SHA-256: `37600d962775721db113328844da5aa8148a0633b94b976d6a2eee6d1514a588`.
- Installed `NFL2K5.exe` SHA-256: `9a7d8da69912955019a9f539db98739202a169835985eaf35f78ac6333a3f48d`.
- Steam Deck, x86-64 SteamOS, original Xbox disc files already supplied by owner.
- Proton Experimental: `1791989105 experimental-11.0-20261014-x86_64`.
- New empty prefix, no previous registry or game saves imported.
- No mod patch selected; installer-shipped content left as supplied.

Run the README setup command, then `./play.sh --validate`, or launch the separate
**2K5 Remade (Repack)** Steam shortcut. The latter uses the generated shell shim;
Steam is not asked to wrap it in a second Proton instance.

## Initial failures (preserved for diagnosis)

1. First attempt: Wine's stock installer junction command created an empty
   directory literally named `disc?`, rather than a usable `original/disc` link.
   The helper now pre-creates a normal Linux symlink which the installer validates
   and reuses. The second installation was in another brand-new prefix.
2. The corrected setup completed with installer exit 0. Its optional stock team
   builder took roughly 90 seconds after file extraction; this was not a hang.
3. Stock `--validate` exited 5. Its own session log reported:

```text
mapped 65536 KB at 0x000000007FFF0000 (offset +2147418112 from Xbox base)
WARNING: contiguous window at 0x80000000 failed (error 487)
WARNING: could not map Xbox kernel VA 0x80010000
[CRASH] exception=0xC0000005 host=0x142BF621B
[CRASH] operation=0 address=0xFFFF1000
```

4. Launch through the actual separate Steam shortcut reproduced the same failure
   before a menu appeared. No exhibition or save/reload claim follows.
5. An additional fresh-prefix check with installed Proton 9.0
   (`1749140930 proton-9.0-4f`) exited 53 without a game session log. Its cause was
   not established; this does not prove the same mapping failure on Proton 9.
6. Hash verification: existing franchise executable and all 205 existing saves
   unchanged; supplied original Xbox executable unchanged. No disposable game or
   installer process remained running at the end of the checks.

## Working settings and evidence

- Launch through Steam with Proton's supported `runinprefix` verb. This avoids the
  original `run`/`waitforexitandrun` startup path that faulted in memory initialization.
- Use the Microsoft x64 `d3dcompiler_47.dll` with a process-local native override.
  Wine's built-in HLSL compiler rejected the game's vertex shader; the Microsoft
  dependency removed that error. The executable itself is byte-for-byte unchanged.
- Select **ESPN (Original)**. The initially selected NBC HTML package logged
  `CreateCoreWebView2Environment failed` and hid the game's original scorebug.
  Switching to the built-in presentation restores it without installing WebView2.
- Use borderless mode, 1280×800 output and **2× render scale**, rather than 3×.
- Pause the separate compiler while playing. Its CPU load contributed to hitches.
- The verified live process loaded **Wine's OpenGL renderer**, not DXVK. The helper
  now selects that backend explicitly. A DXVK validation-only experiment reached
  the later allocator self-test but did not establish gameplay performance.

Four recent 10-second runtime samples at scale 2 averaged **58.1, 59.2, 60.0 and
59.9 FPS**. Their 1% lows were **31.1, 33.0, 44.6 and 47.0 FPS**. These are observed
samples, not a locked-60 claim, a controlled same-scene comparison or a full-match
benchmark. Earlier scale-3 samples with the compiler active fell into the 40s and
sometimes lower. Both workload and scene changed; do not attribute all gains to
one setting.

The first working session used the owner's already installed Windows SDK compiler
DLL. The Bash helper downloads the x64 compiler from Microsoft's SDK cabinet:

- Cabinet SHA-256: `f736e161547095bb8d98c636b85fdfeb4070fefeee3c3745db3ce88f6eb1d9de`.
- DLL SHA-256: `e994847e01a6f1e4cbdc5a864616ac262f67ee4f14db194984661a8d927ab7f4`.
- Independent Windows/Proton dependency smoke checks successfully compiled
  `vs_5_0` with `precise` and `ps_5_0` with `earlydepthstencil` using this download.
- Cabinet/member source metadata can be cross-checked in the
  [Winetricks recipe](https://github.com/Winetricks/winetricks/blob/master/src/winetricks).
  No Winetricks code or Microsoft binary is bundled with this repo.

The newly automated dependency path still needs a complete fresh-install gameplay
rerun. No kernel settings were weakened and no game executable was patched.

## Upstream version

`v0.6.1-hotfix` remains the newest **published release** checked October 16, 2026.
Upstream `master` is newer at `ca7b9d9b8fbd890058fd9cadf9f2a8b83e0ff9fb`, pinning
runtime `2ebf55d72b0f7882bf70d08e5aff51ae170efb65`. A separate unchanged-source Windows
build was staged, but is **paused while the owner plays**. It is not the installed
or verified binary, and no unreleased binary is distributed here.

## Acceptance

- [x] Fresh prefix and original upstream installer completed.
- [x] Linux disc link workaround verified without modifying the upstream installer.
- [x] Separate Steam shortcut added using Valve's helper.
- [x] Existing franchise executable, 205 saves and original Xbox executable unchanged.
- [x] Original executable launches and renders menus with the compatibility settings.
- [x] Exhibition gameplay observed and confirmed by the owner.
- [ ] Explicit save/exit/reload acceptance is still pending.
- [x] Gaming Mode controls confirmed working by the owner.
- [ ] Explicit LT/RT mapping regression check still pending for this stock entry.
- [x] Original ESPN scorebug visually verified.
- [x] Runtime performance samples recorded with the compiler paused.

The Bash entry point now downloads the pinned upstream installer, verifies its
SHA-256, prompts for paths and delegates installation to the Python helper.
Eleven offline tests cover both entry points, including cancellation, checksum
rejection, paths with spaces, launcher environment and failed installation.
All eleven passed on the development Mac and on the actual Steam Deck; `bash -n`
also passed on both. These are component tests, separate from the live game evidence above.
