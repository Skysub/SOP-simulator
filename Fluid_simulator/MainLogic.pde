class MainLogic {
  Keyboard kb;

  MainLogic() {
    kb = new Keyboard();
  }

  void Update() {
  }

  void HandleControls() {
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }
}
