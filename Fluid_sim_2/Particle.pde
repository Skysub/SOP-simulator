class Particle {

  PVector pos, vel, posPrev;

  Particle(float px, float py, float vx, float vy) {
    setPos(px, py);
    setVel(vx, vy);
  }

  Particle Copy(Particle in) {
    Particle out = new Particle(in.getPos().x, in.getPos().y, in.getVel().x, in.getVel().y);
    out.setPosPrev(new PVector(in.getPosPrev().x, in.getPosPrev().y));
    return out;
  }

  void Draw(boolean red) {
    fill(255);
    if(red) fill(255,100,100);
    stroke(0);
    circle(pos.x-5, pos.y-5, 10);
    //println(pos);
    //println("drew a circle " + millis());
  }

  PVector getPos() {
    return pos;
  }

  PVector getPosPrev() {
    return posPrev;
  }

  PVector getVel() {
    return vel;
  }

  void setPosPrev(float x, float y) {
    posPrev = new PVector(x, y);
  }

  void setPos(float x, float y) {
    pos = new PVector(x, y);
  }

  void setVel(float x, float y) {
    vel = new PVector(x, y);
  }

  void setPos(PVector v) {
    pos = new PVector(v.x, v.y);
  }

  void setPosPrev(PVector v) {
    posPrev = new PVector(v.x, v.y);
  }

  void setVel(PVector v) {
    vel = new PVector(v.x, v.y);
  }
}
