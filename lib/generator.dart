import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:go_router_generator_plus/annotations.dart';
import 'package:source_gen/source_gen.dart';
import 'utils.dart';

final _collector = <_RouteMeta>[];

class RoutePageGenerator extends GeneratorForAnnotation<RoutePage> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader ann,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) return '';

    final className = element.name; // e.g. HomeScreen
    final libUri = element.librarySource.uri; // import path

    final overrideName = ann.peek('name')?.stringValue;
    final overridePath = ann.peek('path')?.stringValue;
    final fullscreenDialog = ann.peek('fullscreenDialog')?.boolValue ?? false;

    final routeName = overrideName ?? inferRouteClass(className); // HomeRoute
    final path = overridePath ?? inferPath(className); // /home

    _collector.add(
      _RouteMeta(
        importUri: libUri.toString(),
        className: className,
        routeName: routeName,
        path: path,
        fullscreenDialog: fullscreenDialog,
      ),
    );

    // ما نولّدش كود محلي هنا؛ التجميع حيتم في RoutesEmitter.
    return '';
  }
}

class RoutesEmitter implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
    r'$lib$': ['routes.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // لو مفيش أي RoutePage، طلع ملف فاضي آمن.
    final content = _emitCollected();
    final out = buildStep.allowedOutputs.single;
    await buildStep.writeAsString(out, content);
  }

  String _emitCollected() {
    final buf = StringBuffer()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// ignore_for_file: type=lint')
      ..writeln("import 'package:flutter/material.dart';")
      ..writeln("import 'package:go_router/go_router.dart';");

    final imports = _collector.map((e) => e.importUri).toSet().toList()..sort();
    for (final uri in imports) {
      buf.writeln("import '$uri';");
    }
    buf.writeln();

    for (final r in _collector) {
      buf.writeln('''
class ${r.routeName} {
  static const String name = '${r.routeName}';
  static const String path = '${r.path}';

  static Page<dynamic> page(GoRouterState state) =>
      const MaterialPage(child: ${r.className}());
}
''');
    }

    buf.writeln('final List<GoRoute> appRoutes = <GoRoute>[');
    for (final r in _collector) {
      buf.writeln('''
  GoRoute(
    name: ${r.routeName}.name,
    path: ${r.routeName}.path,
    pageBuilder: (context, state) => ${r.routeName}.page(state),
  ),''');
    }
    buf.writeln('];');

    // اختياري: اكستنشن للتنقل السريع
    if (_collector.isNotEmpty) {
      buf.writeln('\nextension GoX on BuildContext {');
      for (final r in _collector) {
        final short = r.routeName.replaceAll('Route', '');
        buf.writeln('  void goTo$short() => go(${r.routeName}.path);');
      }
      buf.writeln('}');
    }

    _collector.clear();
    return buf.toString();
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
