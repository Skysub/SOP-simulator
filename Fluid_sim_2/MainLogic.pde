class MainLogic {
  Keyboard kb;
  ParSim parSim;

  MainLogic() {
    kb = new Keyboard();
    parSim = new ParSim(4000);
  }

  void Update() {

    parSim.Draw();
    parSim.Update();
    MakePNGs(600);
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    //println(x);
  }

  void MakePNGs(int frames) {
    if (frameCount < frames+1) {
      saveFrame("images/IMG_####.png");
      println(frameCount);
    } else exit();
  }
}
