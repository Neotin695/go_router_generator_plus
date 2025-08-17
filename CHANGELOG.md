# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- (Place your upcoming changes here)

### Changed
- 

### Fixed
- 

---

## [0.0.8] - 2025-08-18
### Added
- Scan annotations across **library parts** using `LibraryReader` (now works even if screens are in `part` files).
- `GoX` context extension with helpers like `context.goToHome()` generated automatically.
- Warning log when no `@RoutePage` is found in `lib/**.dart`.

### Changed
- Improved suffix stripping to handle `Screen`, `Page`, `View`, `Widget` **case-insensitively**  
  (e.g. `HomeScreen`, `HomePage`, `Homepage` → `/home`, `HomeRoute`).
- Cleaner generated header & imports ordering.

### Fixed
- Empty `routes.g.dart` in multi-file libraries where annotations were in parts.

## [0.0.2] - 2025-08-18
### Added
- Single-builder pipeline (`routes_emitter`) that emits `lib/routes.g.dart` directly.

### Changed
- Simplified `build.yaml` (removed multi-builder collector pattern).
- Depend on `glob` for reliable source scanning.

### Fixed
- `build.yaml` parsing issues on some setups.
- Cross-isolate collection bug that produced empty outputs.

## [0.0.1] - 2025-08-17
### Added
- `@RoutePage()` annotation.
- Automatic route name & path inference:
  - `UserProfileScreen` → `UserProfileRoute` & `/user-profile`.
- Generated APIs:
  - `appRoutes: List<GoRoute>`
  - `<Screen>Route.name / .path / .page(GoRouterState)`
- Optional overrides: `@RoutePage(name: 'StartRoute', path: '/')`.
- `fullscreenDialog` support.

---

[Unreleased]: https://github.com/<your-username>/go_router_autogen/compare/v0.0.3...HEAD
[0.0.3]: https://github.com/<your-username>/go_router_autogen/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/<your-username>/go_router_autogen/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/<your-username>/go_router_autogen/releases/tag/v0.0.1
