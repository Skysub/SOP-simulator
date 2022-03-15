MainLogic mainLogic;

void setup() {
  mainLogic = new MainLogic();
  frameRate(144);
  size(1024, 1024);
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
