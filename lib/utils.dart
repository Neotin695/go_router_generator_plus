// utils.dart

String inferRouteClass(String className) {
  final base = _stripRouteSuffix(className);
  return '${_capitalize(base)}Route';
}

String inferPath(String className) {
  final base = _stripRouteSuffix(className);
  return '/${_toKebab(base)}';
}

/// يشيل أي لاحقة شائعة: Screen/Page/View/Widget … الخ
String _stripRouteSuffix(String className) {
  // non-case-sensitive + يشمل تركيبات شائعة
  final suffixPattern = RegExp(
    r'(ScreenView|ScreenWidget|Screen|Page|View|Widget)$',
    caseSensitive: false,
  );

  final withoutSuffix = className.replaceAll(suffixPattern, '');

  // لو الاسم كله كان "HomePage" أو "Homepage" هيشيل "Page"/"page" صح
  // لو ما فيش لاحقة، هنستخدم الاسم كما هو
  final base = withoutSuffix.isEmpty ? className : withoutSuffix;
  return base;
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
