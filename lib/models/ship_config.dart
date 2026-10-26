class ShipConfig {
  final String id;
  final String nameKey;
  final String spriteSheet;
  final double shotCooldown;
  final double speedMultiplier;

  const ShipConfig({
    required this.id,
    required this.nameKey,
    required this.spriteSheet,
    this.shotCooldown = 0.6,
    this.speedMultiplier = 1.0,
  });

  static const ShipConfig alphaScout = ShipConfig(
    id: 'alpha_scout',
    nameKey: 'nave_alpha_scout',
    spriteSheet: 'character1.png',
    shotCooldown: 0.6,
    speedMultiplier: 1.0,
  );

  static const ShipConfig betaInterceptor = ShipConfig(
    id: 'beta_interceptor',
    nameKey: 'nave_beta_interceptor',
    spriteSheet: 'character2.png',
    shotCooldown: 0.4,
    speedMultiplier: 1.25,
  );

  static const List<ShipConfig> all = [alphaScout, betaInterceptor];

  static ShipConfig fromId(String? id) {
    if (id == null) return alphaScout;
    return all.firstWhere((s) => s.id == id, orElse: () => alphaScout);
  }
}
