Solver s = new Solver();
void setup()
{
  size(500, 300, JAVA2D);
  background(0);
  //frameRate(24);
  s.setBnd(0, height, width, 0, 10);
  stroke(0, 0, 255);
  strokeWeight(2);
  fill(255);
}
void draw()
{
  background(255);
  s.step();
  for (int i = 0; i < s.np; i ++){
    V p = s.ps[i];
    line(p.x, p.y, p.x + p.vx, p.y + p.vy);
    //ellipse(p.x, p.y, 6, 6);
  }
  //filter(BLUR, 3);
  //filter(THRESHOLD);
  fill(0, 0, 255);
  text("framerate: " + round(frameRate) + 
  "   number of particles:" + s.np + 
  "   gravity: " + s.gravity +
  "   damping: " + s.damping +
  "\nmaxSpeed: " + s.maxSpeed +
  "   tension: " + s.tension +
  "   repulsion: " + s.repulsion +
  "   stickyness: " + s.stickyness, 30, 30);
}
class Box
{
  float x, y, w, h;
  Box(float nx, float ny, float nw, float nh){
    nw /= 2;
    nh /= 2;
    x = nx + nw;
    y = ny + nh;
    w = nw;
    h = nh;
  }
}
class Circle
{
  float x, y, r, px, py;
  Circle(float nx, float ny, float nr){
    x = nx;
    y = ny;
    r = nr;
  }
  void update()
  {
    px = x;
    py = y;
  }
}

/*
  classe que calcula os valores das partículas
  e controla todas as variáveis do sistema.
*/
class Solver
{
  int np = 100;
  V[] ps = new V[5000];
  float up = 0, right = 0, left = 0, down = 0, buffer = 0;
  float cellWidth = 10;
  float cellHeight = 10;
  float d0 = 12;
  float w0 = 30;
  float d1 = 10;
  float d2 = 15;
  float gravity = 0.02;
  float damping = 0.99;
  float maxSpeed = 4;
  float tension = 0.008;
  float repulsion = 0.0008;
  float stickyness = 1;
  PVector lm = new PVector(0, 0);
   
  Solver()
  {
    for (int i = 0; i < np; i ++)
    {
      ps[i] = new V();
    }
  }
  //eu que fiz
  void addParticle(){
    if(keyPressed && key == 'p'){
      s.np ++;
      s.ps[s.np - 1] = new V();
      s.ps[s.np - 1].x = 50;
      s.ps[s.np - 1].y = 50;
    }  
  }
  // set bounds? limites da tela?
  void setBnd(float nup, float ndown, float nright, float nleft, float nbuffer)
  {
    up = nup;
    right = nright;
    down = ndown;
    left = nleft;
    buffer = nbuffer;
  }
  //chamadas do codigo para todo draw
  void step()
  {
    ellipse(mouseX, mouseY, 10, 10);
    interactions();
    flock();
    //addParticle();
    //advect(ps[np - 1]);
    lm.x = mouseX;
    lm.y = mouseY;
  }
  
  /*
    recalcula os valores de uma particula:
      - aumenta a velocidade e/ou diminui-a se passar do máximo;
      - aumenta a aceleracao;
      - calcula a proxima posicao;
      - modifica a velocidade com base no clique do mouse;
  */
  void advect(V p)
  {
    p.nn = 0;
    p.x = ((p.x + p.vx) + p.nextX) / 2;
    p.y = ((p.y + p.vy) + p.nextY) / 2;
    p.vx += p.ax;
    p.vy += p.ay;
    p.vy += gravity;
    p.ax *= 0.9;
    p.ay *= 0.9;
    p.nextX = p.x + p.vx;
    p.nextY = p.y + p.vy;
    if (p.vx > maxSpeed) p.vx = maxSpeed;
    if (p.vx < -maxSpeed) p.vx = -maxSpeed;
    if (p.vy > maxSpeed) p.vy = maxSpeed;
    if (p.vy < -maxSpeed) p.vy = -maxSpeed;
    p.cellX = int(p.x / cellWidth);
    p.cellY = int(p.y / cellHeight);
    float dx = p.x - mouseX;
    float dy = p.y - mouseY;
    float dist = sqrt(dx * dx + dy * dy);
    if (dist < 40)
    {
      if (mousePressed && !keyPressed)
      {
        if (mouseButton == LEFT)
        {
          p.vx = (p.vx + (mouseX - lm.x) * 0.5) / 2;
          p.vy = (p.vx + (mouseY - lm.y) * 0.5) / 2;
        }
      }
    }
    if (dist < 20) if (mousePressed)if (mouseButton == RIGHT) p.vy = -2;
  }
  
  /* 
    flock = bando, grupo (en-pt)
    faz as ligações entre as particulas e modifica sua aceleração e talvez a densidade
  */
  void flock()
  {
    for (int i = 0; i < np - 1; i ++){
      V p1 = ps[i];
      advect(p1);
      constrict(p1);
      for (int j = i + 1; j < np; j ++){
        V p2 = ps[j];
        float dist = dist(p1.x, p1.y, p2.x, p2.y);
        if (dist < d0){
          float coeff = (dist * 0.1) * w0;
          p1.vx = WM(p1.vx, p2.vx, coeff);
          p1.vy = WM(p1.vy, p2.vy, coeff);
        }
        if (dist < 20)p1.nn ++;
        densStep(p1, p2, dist);
      }
    }
  }
  /* 
    Se as duas particulas estiverem numa distancia pequena o
    suficiente para ambas se influenciarem, é feito novamente
    o cálculo de suas acelerações/velocidades, num esquema de
    colisão. 
  */
  void densStep(V p1, V p2, float dist)
  {
    if (abs(p1.cellX - p2.cellX) < 2 && abs(p1.cellY - p2.cellY) < 2)
    {
      float dx = p1.x - p2.x;
      float dy = p1.y - p2.y;
      float temp = 2;
      float dr;
      if (dist > d1 && dist < d1 * 4) dr = (d1 + dist) / 2;
      else dr = d1;
      if (dist < d1)
      {
        float angle = atan2(dy, dx);
        float ax = cos(angle) * cub(dr - dist) * repulsion;
        float ay = sin(angle) * cub(dr - dist) * repulsion;
        p1.vx += ax;
        p1.vy += ay;
        p2.vx -= ax;
        p2.vy -= ay;
        if (ax > temp) ax = temp;
        if (ax < -temp) ax = -temp;
        if (ay > temp) ay = temp;
        if (ay < -temp) ay = -temp;
      }
      if (dist < d2)
      {
        float angle = atan2(dy, dx);
        float ax = cos(angle) * (dr - dist) * tension;
        float ay = sin(angle) * (dr - dist) * tension;
         
        if (ax > temp) ax = temp;
        if (ax < -temp) ax = -temp;
        if (ay > temp) ay = temp;
        if (ay < -temp) ay = -temp;
        p1.vx += ax;
        p1.vy += ay;
        p2.vx -= ax;
        p2.vy -= ay;
      }
    }
  }
  /*
    compressão (en-pt)?
    quando passa do limite da borda, volta para a posição
    máxima antes dela e tem a velocidade naquele eixo = 0.
  */
  void constrict(V p)
  {
    float bounce = 1;
    if (p.y > down - buffer)
    {
      p.y = down - buffer;
      p.vy = -abs(p.vy * 0.5);
    }
    if (p.x > right - buffer)
    {
      p.x = right - buffer;
      p.vx = 0;
    }
    if (p.y < up + buffer)
    {
      p.y = up + buffer;
      p.vy = 0;
    }
    if (p.x < left + buffer)
    {
      p.x = left + buffer;
      p.vx = 0;
    }
    if (p.y > down - 10) p.vx *= stickyness;
    if (p.x > right - 10) p.vy *= stickyness;
    if (p.y < up + 10) p.vx *= stickyness;
    if (p.x < left + 10) p.vy *= stickyness;
  }
  
  /*
    interações com o mouse.
    aumenta e diminui o número de partículas.
  */
  void interactions()
  {
    if (keyPressed && key == CODED && keyCode == UP)
    {
      if (mousePressed && mouseButton == LEFT)
      {
        for (int i = 0; i < 1; i ++)
        {
          np ++;
          ps[np - 1] = new V();
          ps[np - 1].y = mouseY;
          ps[np - 1].x = mouseX + random(40) - 20;
          ps[np - 1].nextX = ps[np - 1].x;
          ps[np - 1].nextY = ps[np - 1].y;
          ps[np - 1].vy = -2;
        }
      }
      if (mousePressed && mouseButton == RIGHT)
      {
        if (np > 3)np -= 3;
      }
    }
  }
  float S(float x)
  {
    return x * x;
  }
  float cub(float x)
  {
    return x * x * x;
  }
  float WM(float x1, float x2, float w)
  {
    return (x1 * w + x2) / (w + 1);
  }
}

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
  V(){
    //img = loadImage("waterP.png");
  }
  void addN(V nID)
  {
    if (nn < 5000) ns[nn] = nID;
  }
}