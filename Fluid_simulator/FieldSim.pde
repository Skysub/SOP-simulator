class FieldSim {

  int N;
  int iter;
  int scale;
  Fluid fluid;

  float t = 0;
  int timer = 0, timerR = 0;
  long timerS = 0;

  FieldSim(int N, int iter) {
    this.N = N;
    this.iter = iter;
    this.scale = int(width/N);

    //standard viscosity er 0.0000001
    fluid = new Fluid(0.2, 0, 0.0000001, N, iter, scale);
  }

  long Update() {
    int cx = int(5);
    int cy = int(0.5*height/scale);
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        fluid.addDensity(cx+i, cy+j, random(50, 150));
        //fluid.addDensity(cx+i, cy+j, 100);
      }
    }
    for (int i = 0; i < 2; i++) {
      //float angle = noise(t) * TWO_PI * 2;
      //PVector v = PVector.fromAngle(angle);
      PVector v = new PVector(1, 0);
      v.mult(0.1);
      t += 0.01;
      fluid.addVelocity(cx, cy, v.x, v.y );
    }

    timerS = System.nanoTime();
    fluid.step();
    timerS = System.nanoTime()-timerS;
    //println(timerS);
    return timerS;
  }

  void Draw(boolean showVel, boolean paused, boolean showVelF, boolean UI) {
    textSize(40);
    background(0);

    fill(255);
    stroke(255);
    timerR = millis();
    if (!showVel && !showVelF)fluid.RenderD();
    else if (!showVelF) fluid.RenderV();
    else fluid.RenderVelF();
    timerR = millis()-timerR;

    if (UI) {
      fill(255);
      stroke(255);
      if (paused)text("Sim time:      "+0f, 10, 90);
      else text("Sim time:      "+(int(timerS/100000f)/10000f), 10, 90);
      text("Render time: "+(timerR/1000f), 10, 135);

      //fluid.renderV();
      //fluid.fadeD();

      timer = millis()-timer;
      //text("Frametime: "+int(floor(timer/1000f))+"."+(timer-1000*int(floor(timer/1000f))),10, 45);
      text("Frametime:   "+(timer/1000f), 10, 45);
      text("FrameRate:   "+floor(1f/((timer/1000f))), 500, 45);
      text("Resolution: "+N+"x"+N, 10, 180);
      //println(timer);
      timer = millis();
    }
  }
}
