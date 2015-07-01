class firewall extends turret {
  firewall(float gridSize_) {
    super(gridSize_);
    types[0] = "virus";
    bulletVelocity = 2;
    range = 150;
    delay = 20;
    bulletDamage = 1;
  }
  String turretType = "firewall";
}

