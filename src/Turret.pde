class turret {
  float gridSize;
  String[] types = new String[10];
  turret(float gridSize_) {
    gridSize = gridSize_;
  }
  float xPos, yPos;
  float range;
  int counter;
  float bulletVelocity;
  int delay;
  float bulletDamage;

  void drawObj() {
    rect(xPos, yPos, 2 * gridSize, 2 * gridSize);
  }

  void initializeTurret(float xPos_, float yPos_) {
    xPos = xPos_;
    yPos = yPos_;
    drawObj();
  }

  void lockOn(movingObject[] malwares, bullet[] bullets) { 
    int m = frameCount;
    if (m % delay == 0) {
      float distance;
      float finalDistance = 10000;
      int counting = 100;
      boolean typeCheck = false;
      for (int c = 0; c < malwares.length; c++) {
        for (int d = 0; d < types.length; d++) {
          if (malwares[c] != null && types[d] != null) {
            if (types[d].equals(malwares[c].virusType)) {
              typeCheck = true;
            }
          }
        }
        if (typeCheck == true) {
          distance = sqrt(sq(xPos - malwares[c].xPos) + sq(yPos - malwares[c].yPos));
          if (distance < range) {
            if (distance < finalDistance) {
              finalDistance = distance;
              counting = c;
            }
          }
        }
        typeCheck = false;
      }
      if (counting != 100) {
        for (int k = 0; k < bullets.length; k++) {
          if (bullets[k] == null) {
            bullets[k] = new bullet(gridSize / 4, gridSize / 4, gridSize, bulletVelocity, bulletDamage);
            bullets[k].initializeObj(xPos + gridSize, yPos + gridSize);
            bullets[k].fireBulletUpdate(malwares[counting]);
            bullets[k].trigger = true;              
            break;
          }
        }
      }
    }
  }

  void drawRange() {
    fill(255, 255, 255, 0);
    ellipse(xPos + gridSize, yPos + gridSize, range * 2, range * 2);
    fill(255);
  }
  
  void drawAvailableSpace(){
    fill(255, 255, 255, 0);
    stroke(255);
    rect(xPos - (1.5 * gridSize), yPos - (1.5 * gridSize), gridSize * 3.5, gridSize * 3.5);
    fill(255);
    stroke(0);
  }
}

