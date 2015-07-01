class engineer extends movingObject {
  engineer(float engiWide, float engiTall, float engiGridsize) {
    super(engiWide, engiTall, engiGridsize);
    internalVelocity = 1.5;
  }
  float firstFutureX, firstFutureY;

  void setFutures(float firstFutureX_, float firstFutureY_) {
    setFuture(gridify(firstFutureX_), gridify(firstFutureY_));
  }

  float gridify(float gridFloat) {
    return floor(gridFloat / gridSize) * gridSize + (gridSize / 2);
  }
}

