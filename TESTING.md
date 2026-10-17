# Clean-install test — October 16, 2026

**Result: installation succeeds; stock game startup is blocked.** This is not a
playability claim. No source-built game, franchise addon, sidecar, shader override,
ray tracing or copied existing Proton prefix was used.

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

## Findings

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

The exact reason the stock runtime chose/fails this address layout still needs
investigation. No kernel settings were weakened and no binary was patched to
bypass it. A supported runtime fix or proven stock-compatible Proton configuration
is required before recommending this release as playable on Deck.

## Acceptance

- [x] Fresh prefix and original upstream installer completed.
- [x] Linux disc link workaround verified without modifying the upstream installer.
- [x] Separate Steam shortcut added using Valve's helper.
- [x] Existing franchise executable, 205 saves and original Xbox executable unchanged.
- [ ] Original executable launches and renders menus — blocked by startup crash.
- [ ] Exhibition starts and a play completes — blocked by startup crash.
- [ ] Game saves, exits normally and reloads a new save — blocked by startup crash.
- [ ] Gaming Mode gamepad works, including both triggers — blocked by startup crash.

Five offline tests pass locally and on GitHub Actions. They exercise setup,
launcher argv/environment and failure handling; they do not run the retail game.
