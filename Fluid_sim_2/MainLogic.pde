class MainLogic {
  Keyboard kb;
  ParSim parSim;

  MainLogic() {
    kb = new Keyboard();
    parSim = new ParSim(250);
  }

  void Update() {
    
    parSim.Draw();
    parSim.Update();
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    //println(x);
  }
}
