/*
Milestones: 12/28/2014: moving object interface built
 12/30/14: made working turrets and bullets and bullet deleting system
 12/31/14: fully implemented basic viruses, made health, virus deleting system, and collision checker
 To-Do list: 
 make protagonist move to empty square if stopped randomly
 make putting down turrets system 
 make money and upgrade system
 customize malwares and turrets
 THIS IS SASHA'S JOB DOWN HERE PROBABLY
 make UI
 make graphics 
 */
float gridSize = 20;
float gridHeight;
float gridWidth;
int malwaresNumber;
bullet[] bullets = new bullet[200];
virus[] malwares = new virus[50];
turret[] turrets = new turret[50];
engineer protagonist = new engineer(gridSize, gridSize, gridSize);
engineer[] engineers = {
  protagonist
};
movingObject[][] movingObjects = {
  engineers, bullets, malwares
};
int gameState = 1;

/*
  How to make movement:
  First, movement works by setting a future destination
  and then letting speed control the time it takes to 
  get there in frames. Thus, there are two ways of setting 
  the future destination: using coordinates on the 28 by 18 
  artificial grid or the natural 400 by 600 Processing grid.
  The coordinates on the artificial grid work like this:
  the top left corner has coordinate (1,1) and going down 
  one increments the Y value and going left increments the X
  value. The setMovementCo method in the moving_object class
  sets the future position based on the regular coordinates, like
  (200, 300.5). The setMovementGrid method sets the future
  position based on artificial grid coordinates, like
  (15, 20).
*/

void setup() {
  frameRate(60);
  size(600, 400);

  gridWidth = width/gridSize - 2;
  gridHeight = height/gridSize - 2;


  engineers[0].initializeObj(convertToCo(gridWidth / 2), convertToCo(gridHeight / 2));//Consolidated Grid Positioning

  drawBackground();
}

void draw() {
  if (gameState == 0) {
    drawBackground();
    updateObjects();
    manageRandomMalwares(malwaresNumber);
    print(movingObjectCounter(bullets), "\n\n");
    /*  if (bullets[0] != null) {
     print(bulletCounter(), "\n");
     print( "\n", malwares[0].deltaY, "\n");
     }*/
    drawEverything();
  }
  else if (gameState == 1) {
    PImage img = loadImage("titlescreen.png");
    image(img, 0, 0);
  }
  else {
  }
}

void keyPressed() {
  if (gameState == 0) {
    if (key == '1') {
      if (turretCounter() != turrets.length) {
        if (checkTurretCollision() == 0) {
          turrets[turretCounter()] = new firewall(gridSize);
          turrets[turretCounter() - 1].initializeTurret(floor(engineers[0].xPos / gridSize) * gridSize, floor(engineers[0].yPos / gridSize) * gridSize);
        }
      }
    }
    if (key == 'd') {
      int turretsCounting = 0; 
      for (int t = 0; t < turrets.length; t++) {
        if (turrets[t] != null) {
          if (engineers[0].xPos > turrets[t].xPos && engineers[0].xPos < turrets[t].xPos + (2 * gridSize) && engineers[0].yPos > turrets[t].yPos && engineers[0].yPos < turrets[t].yPos + (2 * gridSize)) {
            turrets[t] = null;
            turretsCounting++;
            if (turretCounter() - 1 == t) {
              turrets[turretCounter() - 1] = null;
            }
          } 
          else {
            turrets[t - turretsCounting] = turrets[t];
          }
        }
      }
    }
    if (key == 'a') {
      if (malwaresNumber < 50) {
        malwaresNumber++;
      }
    }
    if (key == 's') {
      if (malwaresNumber > 0) {
        malwares[malwaresNumber - 1] = null;
        malwaresNumber--;
      }
    }
  }
  else {
  }
}


void mousePressed() {
  if (gameState == 0) {
    if ((engineers[0].futureX == floor(engineers[0].xPos / gridSize) * gridSize + (gridSize / 2) && 
      engineers[0].futureY == (engineers[0].yPos / gridSize) * gridSize + (gridSize / 2)) || 
      engineers[0].futureX < gridSize || engineers[0].futureX > width - gridSize || 
      engineers[0].futureY < gridSize || engineers[0].futureY > height - gridSize) {
      engineers[0].trigger = false;
    } 
    else {
      engineers[0].setMovementCo(mouseX, mouseY);
    }
  }
  else if (gameState == 1) {
    gameState--;
  }
  else {
  }
}



//Utility Methods
float convertToCo(float x) {
  x = (x * gridSize) + (gridSize / 2);
  return x;
}

float convertToGrid(float y) {
  y = (y - (gridSize / 2)) / gridSize;
  return y;
}
int movingObjectCounter(movingObject[] bulletss) {
  int countsBullets = 0;
  for (int m = 0; m < bulletss.length; m++) {
    if (bullets[m] != null) {
      countsBullets++;
    }
  }
  return countsBullets;
}

int turretCounter() {
  int countsTurrets = 0;
  for (int s = 0; s < turrets.length; s++) {
    if (turrets[s] != null) {
      countsTurrets++;
    }
  }
  return countsTurrets;
}


void drawBackground() {
  background(200);  
  for (int a = 0; a < width/gridSize - 1; a++) {
    line((a + 1) * gridSize, gridSize, (a + 1) * gridSize, height - gridSize);
  }
  for (int b = 0; b < height/gridSize - 1; b++) {
    line(gridSize, (b + 1) * gridSize, width - gridSize, (b + 1) * gridSize);
  }
}

int checkTurretCollision() {
  for (int r = 0; r < turrets.length; r++) {
    if (turrets[r] != null) {
      if (engineers[0].xPos > turrets[r].xPos - (1.5 * gridSize) && 
        engineers[0].xPos < turrets[r].xPos + (2 * gridSize) && 
        engineers[0].yPos > turrets[r].yPos - (1.5 * gridSize) && 
        engineers[0].yPos < turrets[r].yPos + (2 * gridSize)) {
        return r + 1;
      } 
      else {
        continue;
      }
    }
  }
  return 0;
}

//End Utilities

//Update Loops

/* this turret update loop locks onto any viruses and draws the
 range if you hover over it with your mouse*/
void handleTurrets() {
  for (int e = 0; e < turrets.length; e++) {
    if (turrets[e] != null) {
      turrets[e].lockOn(malwares, bullets);
      if (mouseX > turrets[e].xPos && mouseX < turrets[e].xPos + (gridSize * 2) && mouseY > turrets[e].yPos && mouseY < turrets[e].yPos + (gridSize * 2)) {
        turrets[e].drawRange();
        turrets[e].drawAvailableSpace();
      }
    }
  }
}

void drawEverything() {
  for (int h = 0; h < turrets.length; h++) {
    if (turrets[h] != null) {
      fill(255);
      turrets[h].drawObj();
    }
  }

  for (int f = 0; f < movingObjects.length; f++) {
    for (int g = 0; g < movingObjects[f].length; g++) {
      if (movingObjects[f][g] != null) {
        if (f == 2) {
          fill(malwares[g].malwareColor);
        } 
        else {
          fill(255);
        }
        movingObjects[f][g].drawObj();
      }
    }
  }
}

void updateObjects() {
  for (int i = 0; i < movingObjects.length; i++) {
    for (int j = 0; j < movingObjects[i].length; j++) {
      if (movingObjects[i][j] != null) {
        movingObjects[i][j].velocityCheck();
        movingObjects[i][j].movingObjectUpdate();
      }
    }
  }
  updateBullets();
  updateMalwares();  
  handleTurrets();
}

/* this updates bullets checks if a bullet has hit it's destination 
 and makes it null while shifting all the other bullets over when 
 there's a null bullet*/

void updateBullets() {
  for (int l = 0; l < bullets.length; l++) {
    int bulletCounter = 0;
    if (bullets[l] != null) {
      if (bullets[l].confirmHit()) {        
        bulletCounter++;
        bullets[l] = null;
      } 
      else {
        bullets[l - bulletCounter] = bullets[l];
      }
    }
  }
}

/*this updates malwares so if a malware is destroyed, it gets
 turned into a null and all the other malwares are shifted over*/

void updateMalwares() {
  for (int o = 0; o < malwares.length; o++) {
    int malwareCounter = 0;
    if (malwares[o] != null) {
      if (malwares[o].checkHitAndDeath(bullets)) {
        malwareCounter++;
        malwares[o] = null;
      } 
      else {
        malwares[o - malwareCounter] = malwares[o];
      }
    }
  }
}

void manageRandomMalwares(int p) {
  for (int q = 0; q < p; q++) {
    if (malwares[q] == null) {
      malwares[q] = new virus(gridSize, gridSize / 2, gridSize / 2);
      malwares[q].internalVelocity = 1;
      malwares[q].velocity = 1;
      malwares[q].initializeObj(floor(random(gridSize, width - gridSize) / gridSize) * gridSize - (gridSize / 2), floor(random(gridSize, height - gridSize) / gridSize) * gridSize - (gridSize / 2));
      malwares[q].currentHealth = 10;
      malwares[q].originalHealth = 10;
    }
    if (malwares[q].trigger == false) {
      malwares[q].randomMovement();
      malwares[q].calculateValues();
      malwares[q].trigger = true;
    }
  }
}

void renderText(String textToRender) {
  textSize(24);
  text(textToRender, 20, height-1);
}
void renderNums(float num) {
  textSize(24);
  text(num, 100, height-1);
}

//End Update Loops

