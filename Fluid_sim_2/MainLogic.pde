class MainLogic {
  Keyboard kb;
  ParSim parSim;
  float[] testResults;

  MainLogic() {
    kb = new Keyboard();
    parSim = new ParSim(300);
    //QuickRunTest();
  }

  void Update() {

    //specielTest();
    parSim.Draw();
    parSim.Update();

    //MakePNGs(600);
  }

  void QuickRunTest() {
    testResults = new float[100]; //fra 10 til 1100
    for (int i = 0; i < 100; i++) {
      testResults[i] = 0;
    }

    for (int i = 1; i<101; i++) {
      println("partikler:" + (i*30));
      parSim = new ParSim(i*30);

      //int tid = millis();
      float punkter = 0;
      long ialt = 0;
      /*while (millis() < tid+10000) {
       ialt += fieldSim.Update();
       punkter++;
       }*/
      for (int j = 0; j<100; j++) {        
        ialt = ialt + parSim.Update();
        //delay(10);
        //println(ialt);

        punkter++;
      }
      testResults[i-1] = ialt/punkter;
    }
    Table table = new Table();

    table.addColumn("Partikler");
    table.addColumn("Average sim time (ns)");

    TableRow newRow;
    for (int i = 1; i < 101; i++) {
      newRow = table.addRow();
      newRow.setInt("Partikler", i*30);
      newRow.setFloat("Average sim time (ns)", testResults[i-1]);
    }
    saveTable(table, "data/test.csv");
    exit();
  }




  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    //println(x);
  }

  void MakePNGs(int frames) {
    if (frameCount < frames+1) {
      saveFrame("images/ny_IMG_####.png");
      println(frameCount);
    } else exit();
  }

  void specielTest() {
    long ialt = 0;
    for (int i = 0; i < 10; i++) {
      ialt += parSim.Update()/1000000;
      println(i);
    }
    println("Resultat: "+ialt/10);
    exit();
  }
}
