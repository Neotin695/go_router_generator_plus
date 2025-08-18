# go_router_generator_plus

Code generator for **go_router** that builds your route table from a single annotation:

```dart
@RoutePage()
class HomeScreen extends StatelessWidget { ... }
```

- **Zero configuration in your app** – just annotate screens and run the generator.
- **Smart names & paths** – `HomeScreen`, `HomePage`, or even `Homepage` → `HomeRoute` & `/home`.
- **Single generated file** – `lib/routes.g.dart` exposes `appRoutes`, `<Screen>Route` helpers, and `context.goToX()` shortcuts.
- **Works with library parts** – annotations inside `part` files are detected.

> This is a **code generator** (build_runner). Do **not** edit generated files.

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Install](#install)
  - [From pub.dev](#from-pubdev)
  - [Local path (development)](#local-path-development)
- [Quick Start](#quick-start)
- [What gets generated?](#what-gets-generated)
- [Naming & Path Rules](#naming--path-rules)
- [Options & Overrides](#options--overrides)
  - [`fullscreenDialog`](#fullscreendialog)
  - [Override name/path](#override-namepath)
  - [Dynamic path params](#dynamic-path-params)
  - [Query params](#query-params)
- [Advanced Usage](#advanced-usage)
  - [Working with `part` files](#working-with-part-files)
  - [ShellRoute & nested routes (manual wiring)](#shellroute--nested-routes-manual-wiring)
  - [Deep linking basics](#deep-linking-basics)
- [Regenerating / Watch mode](#regenerating--watch-mode)
- [Suggested Project Layout](#suggested-project-layout)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Compatibility](#compatibility)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)
- [For Package Maintainers (internal)](#for-package-maintainers-internal)

---

## Features
- **Zero-config for your app** – you don’t need any `build.yaml` in the app.
- **Smart inference**:
  - Strips route-ish suffixes (case-insensitive): `Screen`, `Page`, `Homepage`, `View`, `Widget`.
  - Converts `CamelCase` to `kebab-case` for paths: `UserProfileScreen` → `/user-profile`.
  - Special-case: `Homepage` is treated as `Home` → `/home`.
- **Generated API**:
  - `final List<GoRoute> appRoutes`
  - `<Screen>Route.name` / `.path` / `.page(GoRouterState)`
  - `extension GoX on BuildContext` → `context.goToHome()`, etc.
- **Part-friendly**: detects `@RoutePage` in library parts (via `LibraryReader`).
- **Optional overrides**: set `name`/`path`, enable `fullscreenDialog`.
- **Helpful warnings**: logs a warning if no `@RoutePage` is found under `lib/**.dart`.

---

## Requirements
- Dart SDK: `>=3.3.0 <4.0.0`
- Flutter
- `go_router: ^14.2.0`

> You do **not** add a `build.yaml` to your app. The generator’s `build.yaml` lives inside this package.

---

## Install

### From pub.dev
Add to your **app** `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.2.0
  go_router_generator_plus: ^0.0.9   # use the latest available

dev_dependencies:
  build_runner: ^2.4.11
```

Run:
```bash
dart pub get
```

### Local path (development)
If you’re testing the package locally before publishing:
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.2.0
  go_router_generator_plus:
    path: ../go_router_generator_plus

dev_dependencies:
  build_runner: ^2.4.11
```

---

## Quick Start

1) **Annotate your screens**
```dart
import 'package:flutter/material.dart';
import 'package:go_router_generator_plus/go_router_generator_plus.dart';

@RoutePage() // no name/path required
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () => context.goToProfile(), // generated shortcut
        child: const Text('Go to Profile'),
      ),
    ),
  );
}

@RoutePage(fullscreenDialog: true)
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Profile')));
}
```

2) **Generate**
```bash
dart run build_runner build --delete-conflicting-outputs
```

3) **Use the generated API**
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.g.dart'; // GENERATED

final _router = GoRouter(routes: appRoutes);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(routerConfig: _router);
}

// Navigate
// context.go(HomeRoute.path);
// context.goToHome(); // from GoX extension
```

---

## What gets generated?
After running the generator you’ll get a single file:

- `lib/routes.g.dart`
  - `final List<GoRoute> appRoutes`
  - One helper class per annotated screen, e.g. `HomeRoute`:
    - `static const String name`
    - `static const String path`
    - `static Page<dynamic> page(GoRouterState state)`
  - `extension GoX on BuildContext`:
    - `context.goToHome()`, `context.goToProfile()`, …

**Do not** edit this file manually.

---

## Naming & Path Rules
- **Base name** = class name **without** a route-ish suffix (case-insensitive):
  - Suffixes removed: `Screen`, `Page`, `Homepage`, `View`, `Widget`.
- **Route class**: `<Base>Route`
  - `HomeScreen` → `HomeRoute`
  - `UserProfileView` → `UserProfileRoute`
- **Path**: `/<base in kebab-case>`
  - `UserProfile` → `/user-profile`
  - `APISettingsPage` → `/api-settings`
- **Special-case**:
  - `Homepage` → `Home` → `/home`

---

## Options & Overrides

### `fullscreenDialog`
Force a `MaterialPage(fullscreenDialog: true)`:
```dart
@RoutePage(fullscreenDialog: true)
class TermsPage extends StatelessWidget { ... }
```

### Override name/path
If you want explicit identifiers:
```dart
@RoutePage(name: 'StartRoute', path: '/')
class SplashScreen extends StatelessWidget { ... }
```

### Dynamic path params
Provide a custom path and read from `GoRouterState`:
```dart
@RoutePage(path: '/users/:id')
class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'];
    return Scaffold(body: Center(child: Text('User $id')));
  }
}
```

### Query params
Handled by `go_router` normally:
```dart
// /search?q=hello
final q = GoRouterState.of(context).uri.queryParameters['q'];
```

---

## Advanced Usage

### Working with `part` files
The generator scans **all units** of a library (using `LibraryReader`). You can place annotated classes inside `part` files and they will be picked up as long as the library is under `lib/` and you import:
```dart
import 'package:go_router_generator_plus/go_router_generator_plus.dart';
```

### ShellRoute & nested routes (manual wiring)
This generator currently outputs **flat** `GoRoute`s. If you need `ShellRoute` or nested structures, you can either:
- Use this generator for most pages and manually add shell/nested routes around them, or
- Override paths to fit your nesting manually.

Example (manual shell + generated routes):
```dart
final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        ...appRoutes, // generated flat routes
      ],
    ),
  ],
);
```

### Deep linking basics
As long as your app registers the scheme/host appropriately, the generated paths are just normal `go_router` paths, so universal links/deep links will route correctly.

---

## Regenerating / Watch mode
Regenerate whenever you add/rename/remove annotated screens:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Or keep it running:
```bash
dart run build_runner watch -d
```

---

## Suggested Project Layout
```
lib/
  main.dart
  home_screen.dart        // @RoutePage()
  profile_page.dart       // @RoutePage()
  routes.g.dart           // <-- GENERATED (do not edit)
```

---

## Troubleshooting

**`routes.g.dart` is empty**  
- Ensure your screens live under **`lib/`**.  
- Ensure each annotated file imports the package:  
  ```dart
  import 'package:go_router_generator_plus/go_router_generator_plus.dart';
  ```
- Then run:
  ```bash
  dart run build_runner clean
  dart pub get
  dart run build_runner build --delete-conflicting-outputs
  ```

**`Failed to parse build.yaml` (when building/publishing the package, not your app)**  
Your package `build.yaml` (in the package root) should be:
```yaml
builders:
  routes_emitter:
    import: "package:go_router_generator_plus/builder.dart"
    builder_factories: ["routesEmitter"]
    build_extensions:
      "$lib$": ["routes.g.dart"]
    auto_apply: dependents
    build_to: source
```

**`Undefined name 'routesEmitter'`**  
Ensure a top-level factory exists in `lib/builder.dart`:
```dart
Builder routesEmitter(BuilderOptions _) => RoutesEmitter();
```

**`This package does not have glob in the dependencies`**  
Add the dependency to the **package** `pubspec.yaml`:
```bash
dart pub add glob
```

**Trailing commas being removed in VS Code**  
Use Dart as the formatter for `.dart` files and disable Prettier for Dart:
```json
{
  "[dart]": { "editor.defaultFormatter": "Dart-Code.dart-code", "editor.formatOnSave": true },
  "prettier.disableLanguages": ["dart"]
}
```

---

## FAQ

**Do I need to add `build.yaml` to my app?**  
No. The generator’s `build.yaml` ships inside this package.

**Can I override the generated path or route name?**  
Yes, via `@RoutePage(name: 'CustomName', path: '/custom')`.

**Will it pick up annotations inside `part` files?**  
Yes. The generator uses `LibraryReader` to scan all units in a library.

**Does it support ShellRoute or nested routes automatically?**  
Not yet. You can still use the generated flat routes inside your own shell/nesting manually.

---

## Compatibility
- Dart: `>=3.3.0 <4.0.0`
- `go_router: ^14.2.0`
- Works with projects that use library `part` files.

---

## Roadmap
- ✅ `fullscreenDialog` support.
- ✅ Detect annotated classes inside `part` files.
- ⏳ Automatic `ShellRoute` / nested routes generation.
- ⏳ Custom path/param annotations (e.g., `@PathParam('id')`).
- ⏳ Unit tests for the generator.

---

## Contributing
Contributions are welcome! Please file issues/PRs and update **CHANGELOG.md** for notable changes. Add tests for generator behavior where possible.

---

## Changelog
See **CHANGELOG.md** in the repository for detailed release notes.

---

## License
MIT

---

## For Package Maintainers (internal)
If you are maintaining this package, the generator builder is declared via **`build.yaml`** in the package root:

```yaml
builders:
  routes_emitter:
    import: "package:go_router_generator_plus/builder.dart"
    builder_factories: ["routesEmitter"]
    build_extensions:
      "$lib$": ["routes.g.dart"]
    auto_apply: dependents
    build_to: source
```

And you must expose the factory in `lib/builder.dart`:
```dart
Builder routesEmitter(BuilderOptions _) => RoutesEmitter();
```
Make sure `glob` is in the `dependencies` (package `pubspec.yaml`), and **do not** add `flutter` as a dependency to the generator package itself unless you actually import Flutter at build time.
