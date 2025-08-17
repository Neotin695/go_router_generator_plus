import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:go_router_autogen/utils.dart';
import 'package:source_gen/source_gen.dart';
import 'annotations.dart';

class RoutesEmitter implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$lib$': ['routes.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final routes = <_RouteMeta>[];
    final imports = <String>{};
    final routeChecker = const TypeChecker.fromRuntime(RoutePage);

    // مسح كل ملفات lib/**.dart في مشروع الأبلكيشن
    await for (final id in buildStep.findAssets(Glob('lib/**.dart'))) {
      // تجاهل الملفات المولدة
      if (id.path.endsWith('.g.dart')) continue;

      // لازم يكون Library (لو جزء part هنقفله؛ هنعدّي على الـ library اللي بيشمله)
      if (!await buildStep.resolver.isLibrary(id)) continue;

      final lib = await buildStep.resolver.libraryFor(id);
      final reader = LibraryReader(lib);

      // دي المهمّة: تقرأ كل العناصر في كل units (تشمل parts)
      for (final annotated in reader.annotatedWith(routeChecker)) {
        final el = annotated.element;
        if (el is! ClassElement) continue;

        final className = el.name;
        final ann = annotated.annotation;
        final routeName =
            ann.peek('name')?.stringValue ?? inferRouteClass(className);
        final path = ann.peek('path')?.stringValue ?? inferPath(className);
        final fullscreenDialog =
            ann.peek('fullscreenDialog')?.boolValue ?? false;

        routes.add(
          _RouteMeta(
            importUri: lib.source.uri.toString(),
            className: className,
            routeName: routeName,
            path: path,
            fullscreenDialog: fullscreenDialog,
          ),
        );
        imports.add(lib.source.uri.toString());
      }
    }

    final buf = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:go_router/go_router.dart';");

    for (final uri in imports.toList()..sort()) {
      buf.writeln("import '$uri';");
    }
    buf.writeln();

    for (final r in routes) {
      buf.writeln('''
class ${r.routeName} {
  static const String name = '${r.routeName}';
  static const String path = '${r.path}';

  static Page<dynamic> page(GoRouterState state) => ${r.fullscreenDialog}
    ? const MaterialPage(fullscreenDialog: true, child: ${r.className}())
    : const MaterialPage(child: ${r.className}());
}
''');
    }

    buf.writeln('final List<GoRoute> appRoutes = <GoRoute>[');
    for (final r in routes) {
      buf.writeln('''
  GoRoute(
    name: ${r.routeName}.name,
    path: ${r.routeName}.path,
    pageBuilder: (context, state) => ${r.routeName}.page(state),
  ),
''');
    }
    buf.writeln('];');

    if (routes.isEmpty) {
      log.warning(
        'go_router_autogen: لم يتم العثور على أي @RoutePage داخل lib/**.dart',
      );
    } else {
      buf.writeln('\nextension GoX on BuildContext {');
      for (final r in routes) {
        final short = r.routeName.replaceAll('Route', '');
        buf.writeln('  void goTo$short() => go(${r.routeName}.path);');
      }
      buf.writeln('}');
    }

    await buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      buf.toString(),
    );
  }
}

class _RouteMeta {
  _RouteMeta({
    required this.importUri,
    required this.className,
    required this.routeName,
    required this.path,
    required this.fullscreenDialog,
  });

  final String importUri;
  final String className;
  final String routeName;
  final String path;
  final bool fullscreenDialog;
}
