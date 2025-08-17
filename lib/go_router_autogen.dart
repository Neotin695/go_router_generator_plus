library go_router_autogen;

export 'annotations.dart' show RoutePage;

import 'package:build/build.dart';
import 'package:go_router_autogen/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder routeBuilder(BuilderOptions options) => LibraryBuilder(
  RoutePageGenerator(),
  generatedExtension: '.routes.g.dart',
  allowSyntaxErrors: false,
);

Builder routesEmitter(BuilderOptions options) => RoutesEmitter();
