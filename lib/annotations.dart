import 'package:meta/meta.dart';

@immutable
class RoutePage {
  const RoutePage({this.name, this.path, this.fullscreenDialog = false});

  final String? name;
  final String? path;
  final bool fullscreenDialog;
}
