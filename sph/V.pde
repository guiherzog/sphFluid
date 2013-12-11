/*
  classe da partícula. guarda sua posição,
  aceleração, velocidade, próxima posição,
  vizinhos(ns?), se está na superfície, etc.
*/
class V
{
  float x = 0, y = 0, vx = 0, vy = 0, ax = 0, ay = 0, nextX = 0, nextY = 0;
  int cellX = 0, cellY = 0;
  PVector pv = new PVector();
  PVector yv = new PVector();
  int nn = 1;
  V[] ns = new V[5000];
  boolean surfaceParticle = false;
  PImage img;
  V()
  {
    //img = loadImage("waterP.png");
  }
  void addN(V nID)
  {
    if (nn < 5000) ns[nn] = nID;
  }
}
