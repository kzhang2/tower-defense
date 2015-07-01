class bullet extends movingObject {
  float bulletDamage;
  bullet (float bulletWide, float bulletTall, float bulletGridsize, float bulletVelocity, float bulletDamage_) {
    super(bulletWide, bulletTall, bulletGridsize);
    velocity = bulletVelocity;
    bulletDamage = bulletDamage_;
  }
  void fireBulletUpdate (movingObject malware) {
    partition = (malware.xPos - xPos) / (velocity - malware.velocity);
    partition = abs(partition);
    setFuture(malware.deltaX * partition + malware.xPos, malware.deltaY * partition + malware.yPos);
    deltaX = (futureX - xPos) / partition;
    deltaY = (futureY - yPos) / partition;
  }
  
  boolean hitTarget;

  boolean confirmHit() {
    if (futureX == xPos) {
      return true;
    } 
    else {
      return false;
    }
  }
}

