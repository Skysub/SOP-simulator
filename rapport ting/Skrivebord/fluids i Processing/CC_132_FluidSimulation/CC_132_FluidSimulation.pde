// Fluid Simulation
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// https://youtu.be/alhpH6ECFvQ

// This would not be possible without:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf
// Fluid Simulation for Dummies by Mike Ash
// https://mikeash.com/pyblog/fluid-simulation-for-dummies.html

final int N = 128;
final int iter = 4;
final int SCALE = 1024/N;
float t = 0;
int timer = 0, timerR = 0, timerS = 0;

Fluid fluid;

void settings() {
  size(N*SCALE, N*SCALE);
}

void setup() {
  fluid = new Fluid(0.2, 0, 0.0000001);
  frameRate(144);
  textSize(40);
}

//void mouseDragged() {
//}

void draw() {
  background(0);
  int cx = int(5);
  int cy = int(0.5*height/SCALE);
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      fluid.addDensity(cx+i, cy+j, random(50, 150));
    }
  }
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    //PVector v = PVector.fromAngle(angle);
    PVector v = new PVector(1, 0);
    v.mult(0.1);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y );
  }

  timerS = millis();
  fluid.step();
  timerS = millis()-timerS;

  fill(255);
  stroke(255);
  timerR = millis();
  fluid.renderD();
  timerR = millis()-timerR;

  fill(255);
  stroke(255);
  text("Sim time:      "+(timerS/1000f), 10, 90);
  text("Render time: "+(timerR/1000f), 10, 135);

  //fluid.renderV();
  //fluid.fadeD();

  timer = millis()-timer;
  //text("Frametime: "+int(floor(timer/1000f))+"."+(timer-1000*int(floor(timer/1000f))),10, 45);
  text("Frametime:   "+(timer/1000f), 10, 45);
  text("FrameRate:   "+floor(1f/((timer/1000f))), 500, 45);
  //println(timer);
  timer = millis();
}
