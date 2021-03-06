class MainLogic {
  Keyboard kb;
  FieldSim fieldSim;
  boolean testRun;
  float[] testResults;
  boolean start = true;
  int test, punkter, ialt;
  boolean quick;
  int scale;
  boolean UI = true;

  MainLogic() {
    kb = new Keyboard();
    int res = 256;
    fieldSim = new FieldSim(res, 10);
  }

  void Update() {

    //specielTest();


    if (kb.Shift(10)) testRun = true; 
    if (kb.Shift(81)) QuickRunTest();
    if (kb.Shift(87)) RunTestIte();
    if (testRun) {
      runTest();
    } else {
      HandleControls();

      if (!kb.getToggle(32)) {
        if (!kb.getToggle(84))println(fieldSim.Update()/1000000);
      }
      if (!kb.getToggle(84))fieldSim.Draw(kb.getToggle(86), kb.getToggle(32), kb.getToggle(67), UI);
      else ; //Til partikkel baseret algoritme
    }
    //if (frameCount == 200) saveFrame("f200_UltraHigh.png");
    //if (frameCount == 150) saveFrame("f150.png");
    //MakePNGs(800);
  }

  void HandleControls() {
    if (kb.Shift(82))fieldSim = new FieldSim(128, 5);
    if (kb.getToggle(86) && kb.Shift(67)) kb.setToggle(86, false);
    if (kb.getToggle(67) && kb.Shift(86)) kb.setToggle(67, false);
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
    //println(x);
  }

  void runTest() {
    if (start) {
      testResults = new float[100]; //fra 10 til 1100
      start = false;
      test = 1;
      fieldSim = new FieldSim(test*10, 5);
    }

    ialt += fieldSim.Update();
    punkter++;

    if (punkter > 100) {
      testResults[test-1] = ialt/punkter/1f;
      test++;
      fieldSim = new FieldSim(test*10, 5);
      punkter = 0;
      println("Resolution:" + (test*10)+" x "+(test*10));
    }   

    if (!kb.getToggle(16))fieldSim.Draw(kb.getToggle(86), false, kb.getToggle(32), UI);
    //text("N: "+test*10, 10, 180);

    if (test > 100) {
      testRun = false;
      start = true;
      Table table = new Table();

      table.addColumn("Resolution");
      table.addColumn("Average sim time (ms)");

      TableRow newRow;
      for (int i = 1; i < 101; i++) {
        newRow = table.addRow();
        newRow.setInt("Resolution", i*10);
        newRow.setFloat("Average sim time (ms)", testResults[i-1]);
      }
      saveTable(table, "data/test.csv");
    }
  }

  void QuickRunTest() {
    testResults = new float[100]; //fra 10 til 1100
    for (int i = 0; i < 100; i++) {
      testResults[i] = 0;
    }

    for (int i = 1; i<101; i++) {
      println("Resolution:" + (i*10)+" x "+(i*10));
      fieldSim = new FieldSim(i*10, 5);

      //int tid = millis();
      float punkter = 0;
      long ialt = 0;
      /*while (millis() < tid+10000) {
       ialt += fieldSim.Update();
       punkter++;
       }*/
      for (int j = 0; j<100; j++) {        
        ialt = ialt + fieldSim.Update();
        //delay(10);
        //println(ialt);

        punkter++;
      }
      testResults[i-1] = ialt/punkter;
    }
    Table table = new Table();

    table.addColumn("Resolution");
    table.addColumn("Average sim time (ns)");

    TableRow newRow;
    for (int i = 1; i < 101; i++) {
      newRow = table.addRow();
      newRow.setInt("Resolution:", i*10);
      newRow.setFloat("Average sim time (ns)", testResults[i-1]);
    }
    saveTable(table, "data/test.csv");
  }

  void RunTestIte() {
    testResults = new float[100]; //fra 10 til 1100
    for (int i = 0; i < 100; i++) {
      testResults[i] = 0;
    }

    for (int i = 1; i<101; i++) {
      println("Iterations: "+i);
      fieldSim = new FieldSim(64, i);

      //int tid = millis();
      float punkter = 0;
      long ialt = 0;
      /*while (millis() < tid+10000) {
       ialt += fieldSim.Update();
       punkter++;
       }*/
      for (int j = 0; j<50; j++) {        
        ialt = ialt + fieldSim.Update();
        //delay(10);
        //println(ialt);

        punkter++;
      }
      testResults[i-1] = ialt/punkter;
    }
    Table table = new Table();

    table.addColumn("Iterations");
    table.addColumn("Average sim time (ns)");

    TableRow newRow;
    for (int i = 1; i < 101; i++) {
      newRow = table.addRow();
      newRow.setInt("Iterations", i);
      newRow.setFloat("Average sim time (ns)", testResults[i-1]);
    }
    saveTable(table, "data/test_ite.csv");
  }

  void MakePNGs(int frames) {
    if (frameCount < frames+1) {
      saveFrame("images/IMG_####.png");
      println(frameCount);
    } else exit();
  }

  void specielTest() {
    for (int i = 0; i < 1000; i++) {
      ialt += fieldSim.Update()/1000000;
      println(i);
    }
    println("Resultat: "+ialt/1000);
    exit();
  }
}
