double? parseMoedaBr(String? valor) {
  if (valor == null) return null;
  final digits = valor.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return double.tryParse(digits) == null ? null : double.parse(digits) / 100.0;
}

String? emptyToNull(String? s) {
  final t = s?.trim();
  return (t == null || t.isEmpty) ? null : t;
}

class PrefsKeys {
  static const profile = 'profile_json';
}