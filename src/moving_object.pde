class movingObject {
  float wide, tall, gridSize;
  float velocity;
  float internalVelocity;
  float partition = 1;
  float counter = 0;
  boolean trigger = false;
  String virusType;
  movingObject (float wide_, float tall_, float gridSize_) {
    wide = wide_;
    tall = tall_;
    gridSize = gridSize_;
  }
  float xPos, yPos;
  float futureX, futureY;
  float deltaX, deltaY;
  void drawObj() {
    ellipse(xPos, yPos, wide, tall);
  }

  void setMovementCo(float pointX, float pointY){
    counter = 0;
    setFuture((floor(pointX / gridSize) * gridSize) + gridSize / 2, (floor(pointY / gridSize) * gridSize) + gridSize / 2);
    calculateValues();
    trigger = true;
  }
  
  void setMovementGrid(float gridXL, float gridYL){
    counter = 0;
    setFuture((gridXL * gridSize) + (gridSize / 2), (gridYL * gridSize) + (gridSize / 2));
    calculateValues();
    trigger = true;
  }

  void calculateValues() {
    partition = sqrt(sq(futureX - xPos) + sq(futureY - yPos)) / velocity;    
    deltaX = (futureX - xPos) / partition;
    deltaY = (futureY - yPos) / partition;
  }

  void initializeObj(float objX, float objY) {
    yPos = objY;
    xPos = objX;
    futureX = xPos;
    futureY = yPos;
    drawObj();
  }

  void move(float xComp, float yComp) {
    xPos += xComp;
    yPos += yComp;
  }

  void setFuture(float futureX_, float futureY_) {
    futureX = futureX_;
    futureY = futureY_;
    velocityCheck();
  }

  void velocityCheck() {
    if (xPos - futureX == 0 && yPos - futureY == 0) {
      velocity = 0;
    } 
    else {
      velocity = internalVelocity;
    }
  }

  void movingObjectUpdate() {
    if (counter == ceil(partition)) {
      counter = 0;
      xPos = futureX;
      yPos = futureY;
      deltaX = 0;
      deltaY = 0;
      trigger = false;
    }
    if (trigger) {
      move(deltaX, deltaY);
      counter++;
    }
  }
}

