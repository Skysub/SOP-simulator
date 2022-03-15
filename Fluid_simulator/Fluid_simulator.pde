
MainLogic mainLogic;


void setup() {
  mainLogic = new MainLogic();
  frameRate(144);
  size(550, 250);
}

void draw() {
  background(0);
  mainLogic.Update();
}

void keyPressed() {
  mainLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  mainLogic.HandleInput(keyCode, false);
} 
