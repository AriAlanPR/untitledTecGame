extension MapIsDynamic on Map<String, dynamic> {
  String forceStringFrom({required String key}) => this[key] ?? '';
  String? asString({required String key}) => this[key]?.toString();
  int forceIntFrom({required String key}) => this[key] ?? -1;
  int? asInt({required String key}) => this[key].runtimeType == int ? this[key] : null;
  double forceDoubleFrom({required String key}) => this[key] ?? -1;
  double? asDouble({required String key}) => this[key].runtimeType == int ? this[key] : null;
}