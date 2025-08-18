# Changelog
All notable changes to this project will be documented in this file.
This project follows [Semantic Versioning](https://semver.org) and the
[Keep a Changelog](https://keepachangelog.com) format.

## [Unreleased]
### Added
- (Place upcoming changes here)

---

## [0.0.10] - 2025-08-18
### Changed
- Consolidated and expanded **README.md** into a single, self-contained file with a full Table of Contents, end‑to‑end install & usage, advanced notes, troubleshooting, and FAQ.

### Fixed
- Build break: **`Undefined name 'routesEmitter'`** by exposing a top‑level factory in `lib/builder.dart`.
- Pub.dev validation: missing **`glob`** dependency added to `dependencies`.
- Stability: more resilient library scanning when annotations live in `part` files (LibraryReader-based pass).

### Notes
- **No breaking changes.** Regenerate code with:
  ```bash
  dart run build_runner clean
  dart pub get
  dart run build_runner build --delete-conflicting-outputs
  ```

## [0.0.9] - 2025-08-18
### Added
- README overhaul (Quick Start, Troubleshooting, Naming rules).
### Fixed
- VS Code formatter note (trailing commas) in docs.
### Changed
- Minor generator logs and comments.

## [0.0.8] - 2025-08-18
### Added
- Warning when no `@RoutePage` is found under `lib/**.dart`.
### Fixed
- Windows path edge cases when scanning files.
- Deduplicated imports order in `routes.g.dart`.

## [0.0.7] - 2025-08-18
### Changed
- Faster file scanning with `glob` and ignoring `*.g.dart`.
### Fixed
- Occasional empty output due to duplicate scanning.

## [0.0.6] - 2025-08-18
### Added
- `GoX` extension with helpers `context.goToX()`.
### Changed
- More descriptive error messages during emit.

## [0.0.5] - 2025-08-18
### Added
- `fullscreenDialog` support in generated `Page` factories.
### Fixed
- Generated `page(...)` signature stability across go_router updates.

## [0.0.4] - 2025-08-18
### Changed
- Improved suffix stripping: handles `Homepage` as `Home` (case-insensitive).
### Fixed
- Kebab-case conversion for consecutive capitals (e.g., `APISettingsPage` → `/api-settings`).

## [0.0.3] - 2025-08-18
### Added
- Part-aware scanning using `LibraryReader` (annotations in `part` files now detected).
### Fixed
- Empty `routes.g.dart` when annotations live outside the primary library unit.

## [0.0.2] - 2025-08-18
### Changed
- Simplified to **single builder** pipeline `routes_emitter` that writes `lib/routes.g.dart` directly.
### Fixed
- `build.yaml` parsing issues and cross-isolate state sharing bug.

## [0.0.1] - 2025-08-17
### Added
- `@RoutePage()` annotation.
- Automatic name & path inference:
  - Remove suffix: `Screen|Page|View|Widget` (case-insensitive).
  - Convert `CamelCase` → `kebab-case` in paths.
- Generated APIs:
  - `appRoutes: List<GoRoute>`
  - `<Screen>Route.name / .path / .page(GoRouterState)`

---

[Unreleased]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.10...HEAD
[0.0.10]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.9...v0.0.10
[0.0.9]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.8...v0.0.9
[0.0.8]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/neotin695/go_router_generator_plus/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/neotin695/go_router_generator_plus/releases/tag/v0.0.1
