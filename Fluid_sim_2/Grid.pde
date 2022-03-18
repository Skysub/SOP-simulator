class Grid {


  int gridSize = 32;
  IntList[][] grid = new IntList[gridSize][gridSize];
  ParSim master;
  Particle usePart = new Particle(0, 0, 0, 0);

  Grid(ParSim master) {
    this.master = master;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        grid[i][j] = new IntList();
      }
    }
  }

  void MoveParticle(int index, PVector pos, PVector posPrev) {
    int indexO = PosToIndex(posPrev)[0];
    int indexOO = PosToIndex(posPrev)[1];
    if (PosToIndex(posPrev)[0]>31 || PosToIndex(posPrev)[0]<0 || PosToIndex(posPrev)[1]> 31 || PosToIndex(posPrev)[1]<0) return;
    if (PosToIndex(pos)[0]>31 || PosToIndex(pos)[0]<0 || PosToIndex(pos)[1]> 31 || PosToIndex(pos)[1]<0) return;
    for (int i = 0; i < grid[indexO][indexOO].size(); i++) {
      if (grid[indexO][indexOO].get(i) == index) {
        grid[indexO][indexOO].remove(i);
      }
    }
    grid[PosToIndex(pos)[0]][PosToIndex(pos)[1]].append(index);
  }

  ArrayList<Particle> getPossibleNeighbors(PVector pos, int index) {
    ArrayList<Particle> possibleNeighbors = new ArrayList<Particle>();
    int[] indexes = PosToIndex(pos);
    for (int i = -1; i < 2; i++) {
      for (int j = -1; j < 2; j++) {
        if (indexes[0]+i > -1 && indexes[0]+i < 32 && indexes[1]+j > -1 && indexes[1]+j < 32) {
          for (int s = 0; s < grid[indexes[0]+i][indexes[1]+j].size(); s++) {
            if (grid[indexes[0]+i][indexes[1]+j].get(s) != index) {
              possibleNeighbors.add(usePart.Copy(master.particles.get(grid[indexes[0]+i][indexes[1]+j].get(s))));
            }
          }
        }
      }
    }
    return possibleNeighbors;
  }

  int[] PosToIndex(PVector pos) {
    int[] out = new int[2];
    out[0] = floor(pos.x/(1024/gridSize));
    out[1] = floor(pos.y/(1024/gridSize));
    return out;
  }
}
