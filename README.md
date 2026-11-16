# sponge-de

Sponge OS desktop environment components: the Qt6 `sponge-de` desktop
shell (panel, launcher, notifications, themes, quick settings,
background) plus its sibling DE services and acceptance probes. This
repository is the phase16 repository split of the DE sources out of the
umbrella sponge-os repository, with their history preserved.

## Contents

- `src/sponge-de/` — the Qt6 Widgets desktop shell (qmake project:
  `sponge_de.pro` + `target.mk`). See `src/sponge-de/README.md` for the
  component design and current status.
- `src/sponge_launcher/` — package launcher menu component.
- `src/sponge_settings/` — settings entry shell: lists and opens
  provider-owned settings windows; no settings UI of its own.
- `src/settings_providers/` — provider-owned settings backends.
- `src/sponge_notifier/` — notification daemon (`notif_request` /
  `notifications` Report/ROM bus).
- `src/sponge_decorator_bridge/` — window decorator bridge.
- `src/test/` — the DE acceptance probes: sponge_de_probe, theme_probe,
  notify_probe, launcher_probe, quickmenu_probe, multipanel_probe,
  panel_menu_probe, shortcuts_probe, settings_failure_probe,
  settings_focus_probe, settings_providers_probe,
  settings_thirdparty_probe, settings_vct_probe, bg_probe,
  de_survival_probe, qscreen_race_probe, release_resize_probe,
  workflow_probe, stability_probe, leak_audit_probe.

## Shared umbrella services

The umbrella sponge-os repository owns the shared code these components
build against — `repos/sponge/include/sponge/` (`backend_client.h`,
`version.h`, ...) and `repos/sponge/lib/src/sponge_backend_client/` —
and this repository duplicates none of it. Genode's
`select_from_repositories` resolves those files across registered
repositories: `src/sponge-de/target.mk` derives
`SPONGE_SHARED_INCLUDE_DIR` / `SPONGE_BACKEND_CLIENT_DIR` (the parent
directories of the selected files) and exports them to the qmake run,
so `src/sponge-de/sponge_de.pro` needs no `../../` paths.

`sponge_themed` deliberately stays in the umbrella repository (D16C.2).

## Run scenarios

The Genode `run/` scenarios stay in the umbrella repository (e.g.
`run/sponge-de.run`, `run/sponge-notify.run`, `run/sponge-theme.run`):
run scripts orchestrate cross-repository components and remain owned
there. This repository contributes component binaries and probes only.

## Build

Register this repository in the build's `REPOSITORIES` (the umbrella
wires it in) and build the standard Genode targets; the sponge-de
target stays qmake-driven through `qt6_qmake`. For standalone qmake
runs, set `SPONGE_SHARED_INCLUDE_DIR` and `SPONGE_BACKEND_CLIENT_DIR`
in the environment (normally exported by `target.mk`).

History is preserved from the umbrella repository via a path-filtered
fast-export; paths in this repository are repository-local (`src/...`,
not `repos/sponge/src/...`).
