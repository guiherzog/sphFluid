/*
  classe da partícula. guarda sua posição,
  aceleração, velocidade, próxima posição,
  vizinhos(ns?), se está na superfície, etc.
*/
class Particle
{
  float x = 0, y = 0, vx = 0, vy = 0, ax = 0, ay = 0, nextX = 0, nextY = 0;
  int cellX = 0, cellY = 0;
  PVector pv, yv = new PVector();
  int nn = 1;
  Particle[] ns = new Particle[5000];
  boolean surfaceParticle = false;
  PImage img;
  Particle(float x, float y)
  {
    this.x = x;
    this.y = y;
    //img = loadImage("waterP.png");
  }
  void addN(Particle nID)
  {
    if (nn < 5000) ns[nn] = nID;
  }
}
