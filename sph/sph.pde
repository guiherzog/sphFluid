import controlP5.*;

PImage sprite;  
// Atributos Configuráveis
float partSize = 10;
Solver s;
Menu menu;

int number_particles = 100;
float gravity = 0.02;
float damping = 0.99;
float maxSpeed = 4;
float tension = 0.08;
float repulsion = 0.0008;
float stickyness = 1;

void setup()
{
  sprite = loadImage("sprite.png");
  size(800, 600);
  background(0);
  //frameRate(24);
  menu = new Menu(new ControlP5(this),
                  gravity,
                  damping,
                  number_particles,
                  maxSpeed,
                  tension,
                  repulsion,
                  stickyness);
                  
  s =  new Solver(gravity,
                  damping,
                  number_particles,
                  maxSpeed,
                  tension,
                  repulsion,
                  stickyness);
                  
  s.setBnd(0, height, width, 0, 5);
  stroke(0, 0, 255);
  strokeWeight(2);
  fill(255);
 
}
void drawParticle(PVector center, float opacity) {
  beginShape(QUAD);
  noStroke();
  tint(255, opacity * 255);
  texture(sprite);
  normal(0, 0, 1);
  vertex(center.x - partSize/2, center.y - partSize/2, 0, 0);
  vertex(center.x + partSize/2, center.y - partSize/2, sprite.width, 0);
  vertex(center.x + partSize/2, center.y + partSize/2, sprite.width, sprite.height);
  vertex(center.x - partSize/2, center.y + partSize/2, 0, sprite.height);                
  endShape();  
}
void draw()
{  
  background(0);
  s.step();
  menu.update();
  updateVariables();
  for (int i = 0; i < s.np; i ++){
    Particle p = s.ps[i];
    //drawParticle(new PVector(p.x,p.y),1);
    fill(0, 0, 255);
    ellipse(p.x, p.y, 20, 20);
  }
  fill(0, 0, 255);
}
void updateVariables()
{
   s.gravity = menu.cp5.getController("Gravidade").getValue();
}

