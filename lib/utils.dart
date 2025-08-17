String inferRouteClass(String className) {
  final base = className.replaceAll(RegExp(r'(Screen|Page|View)$'), '');
  return '${_capitalize(base)}Route';
}

String inferPath(String className) {
  final base = className.replaceAll(RegExp(r'(Screen|Page|View)$'), '');
  return '/${_toKebab(base)}';
}

String _toKebab(String input) {
  final s = input.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m[1]}-${m[2]}',
  );
  return s.toLowerCase();
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
