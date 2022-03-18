class ParSim { //<>// //<>// //<>// //<>// //<>// //<>//

  ArrayList<Particle> particles;
  ArrayList<ArrayList<Particle>> neighbors;
  Grid grid;
  DistanceField distanceField;
  IntList reds;

  float timeStep = 0.03; //Amount of time passed pr. simulation step
  float radius = 10; //radius of the particles
  float viscLD = 1; //viscosity linear dependency
  float viscQD = 0; //viscosity quadratic dependency
  float k = 10;  //Stiffness used in DoubleDensityRelaxation
  float kN = 10; //Near-stiffness used in DoubleDensityRelaxation
  float densityBase = 50;
  int particlesTotal;

  int timer = 0, timerR = 0;
  long timerS = 0;

  ParSim(int particlesTotal) {
    reds = new IntList();
    this.particlesTotal = particlesTotal;
    particles = new ArrayList<Particle>();
    neighbors = new ArrayList<ArrayList<Particle>>();
    grid = new Grid(this);
    distanceField = new DistanceField();

    for (int i = 0; i < particlesTotal; i++) {    
      particles.add(new Particle(random(0, 1024), random(0, 1024), 0, 0));
    }

    for (int i = 0; i < particlesTotal; i++) {    
      neighbors.add(new ArrayList<Particle>());
      for (int j = 0; j < particlesTotal; j++) {
        //neighbors.get(i).add(particles.get(j));
      }
    }
  }

  long Update() {
    timerS = System.nanoTime();
    SimStep();
    timerS = System.nanoTime()-timerS;
    return timerS;
  }

  void Draw() {
    timerR = millis();
    for (int i = 0; i < particlesTotal; i++) {
      particles.get(i).Draw(reds.hasValue(i));
    }
    timerR = millis()-timerR;

    textSize(40);
    fill(255);
    stroke(255);
    text("Sim time:      "+(int(timerS/100000f)/10000f), 10, 90);
    text("Render time: "+(timerR/1000f), 10, 135);

    timer = millis()-timer;
    //text("Frametime: "+int(floor(timer/1000f))+"."+(timer-1000*int(floor(timer/1000f))),10, 45);
    text("Frametime:   "+(timer/1000f), 10, 45);
    text("FrameRate:   "+floor(1f/((timer/1000f))), 500, 45);
    //println(timer);
    timer = millis();
  }

  void SimStep() {
    if (frameCount > 100)ApplyExternalForces();
    ApplyViscosity();
    AdvanceParticles();
    UpdateNeighbors();
    DoubleDensityRelaxation();
    //ResolveCollisions();
    //UpdateVelocity();
  }

  //Step 1
  void ApplyExternalForces() {
    for (int i = 0; i < particles.size(); i++) {
      if (grid.PosToIndex(particles.get(i).getPos())[0]>9 && grid.PosToIndex(particles.get(i).getPos())[1]>9 && grid.PosToIndex(particles.get(i).getPos())[0]<12 && grid.PosToIndex(particles.get(i).getPos())[1]<12) {
        particles.get(i).setVel(new PVector(10, 0).add(particles.get(i).getVel()));
        //println(particles.get(i).getVel());
        reds.append(i);
      }
    }
  }

  //Step 2
  void ApplyViscosity() {
    for (int i = 0; i < particles.size(); i++) {
      for (int j = 0; j < neighbors.get(i).size(); j++) {
        Particle p = particles.get(i), n = neighbors.get(i).get(j);
        //PVector Vpn = n.getPos().sub(p.getPos());
        PVector Vpn = new PVector(n.getPos().x-p.getPos().x, n.getPos().y-p.getPos().y);
        float velInward = new PVector(p.getVel().x-n.getVel().x, p.getVel().y-n.getVel().y).dot(Vpn);
        if (velInward > 0) {
          float l = Vpn.mag();
          velInward = velInward/l;
          Vpn.div(l);
          float q = l/radius;
          PVector I = Vpn.mult(0.5*timeStep*(1-q)*(viscLD*velInward+viscQD*(velInward*velInward)));
          particles.get(i).setVel(p.getVel().sub(I));
        }
      }
    }
  }

  //Step 3
  void AdvanceParticles() {
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).setPosPrev(particles.get(i).getPos().copy());
      particles.get(i).setPos(new PVector(timeStep*particles.get(i).getVel().x, timeStep*particles.get(i).getVel().y).add(particles.get(i).getPos()));
      grid.MoveParticle(i, particles.get(i).getPos(), particles.get(i).getPosPrev());
    }
  }

  //Step 4
  void UpdateNeighbors() {
    for (int i = 0; i < particles.size(); i++) {
      neighbors.get(i).clear();
      for (int j = 0; j < grid.getPossibleNeighbors(particles.get(i).getPos(), i).size(); j++) {
        if (new PVector(particles.get(i).getPos().x, particles.get(i).getPos().y).sub(         grid.getPossibleNeighbors(particles.get(i).getPos(), i).get(j).getPos()).mag() < radius         ) {
          neighbors.get(i).add(grid.getPossibleNeighbors(particles.get(i).getPos(), i).get(j));
        }
      }
    }
  }

  //Step 5
  void DoubleDensityRelaxation() {
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      float density = 0;
      float densityNear = 0;
      for (int j = 0; j < neighbors.get(i).size(); j++) {
        Particle n = neighbors.get(i).get(j);
        float tempN = new PVector(p.getPos().x, p.getPos().y).sub(new PVector(n.getPos().x, n.getPos().y)).mag();
        float q = 1f-(tempN/radius);
        density = density + (q*q);
        densityNear = densityNear + (q*q*q);
      }
      float P = k * (density - densityBase);
      float Pnear = kN * densityNear;
      PVector delta = new PVector(0, 0);
      for (int j = 0; j < neighbors.get(i).size(); j++) {
        Particle n = neighbors.get(i).get(j);
        float tempN = new PVector(p.getPos().x, p.getPos().y).sub(new PVector(n.getPos().x, n.getPos().y)).mag();
        if (tempN == 0) tempN = 0.001f;
        float q = 1f-(tempN/radius);
        PVector Vpn = new PVector(p.getPos().x, p.getPos().y).sub(new PVector(n.getPos().x, n.getPos().y)).div(tempN);
        PVector D = Vpn.mult(0.5*(timeStep*timeStep)*(P*q+Pnear*(q*q)));
        neighbors.get(i).get(j).setPos(neighbors.get(i).get(j).getPos().add(D));
        delta.sub(D);
      }
      particles.get(i).setPos(p.getPos().add(delta));
    }
  }

  //Step 6
  void ResolveCollisions() {
    for (int i = 0; i < particles.size(); i++) {
    }
  }

  //Step 7
  void UpdateVelocity() {
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).setVel(particles.get(i).getPos().copy().sub(particles.get(i).getPosPrev()).div(timeStep));
    }
  }
}
