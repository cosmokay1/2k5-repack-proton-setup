# Clean-install acceptance

Status: in progress; no compatibility claim until actual execution is recorded.

Target: original BeyondTomrrow/2K5Remade release `v0.6.1-hotfix`, unmodified
`NFL2K5-PC-Setup.exe`, Steam Deck, fresh Proton Experimental prefix.

Offline tests cover argument boundaries, environment isolation, paths with spaces,
Steam identity preservation, existing-output refusal, failed-install logs and
incomplete disc rejection. These do not substitute for the following live checks:

- [ ] Fresh prefix and original upstream installer completed.
- [ ] Original executable launches and renders menus.
- [ ] Exhibition starts and a play completes.
- [ ] Game saves, exits normally and reloads its own newly created save.
- [ ] Steam Gaming Mode gamepad works, including both triggers.
- [ ] Existing franchise installation and saves remain unchanged.

No AI, companion process, custom renderer or ray tracing is part of this test.
