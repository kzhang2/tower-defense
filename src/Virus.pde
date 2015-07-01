class virus extends movingObject {
  virus(float gridSize_, float wide_, float tall_) {
    super(wide_, tall_, gridSize_);
    virusType = "virus";
  }
  void randomMovement() {
    futureX = floor(random(gridSize, width - gridSize) / gridSize) * gridSize - (gridSize / 2);
    futureY = floor(random(gridSize, height - gridSize) / gridSize) * gridSize - (gridSize / 2);
    velocityCheck();
  }
  float originalHealth;
  float currentHealth;
  float malwareColor = 255;

  boolean checkHitAndDeath(bullet[] bullets) {
    for (int n = 0; n < bullets.length; n++) {
      if (bullets[n] != null) {
        if (bullets[n].hitTarget != true) {
          if (sqrt(sq(xPos - bullets[n].xPos) + sq(yPos - bullets[n].yPos)) < wide + bullets[n].wide) {
            currentHealth -= bullets[n].bulletDamage;
            bullets[n].hitTarget = true;
            malwareColor = currentHealth / originalHealth * 255;            
//            print("I'm hit \n", currentHealth, "\n", malwareColor, "\n");
          } 
          else {
            continue;
          }
        }
      }
    }
    if (currentHealth <= 0) {
      return true;
    } 
    else {
      return false;
    }
  }
}

