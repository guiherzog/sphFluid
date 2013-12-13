import controlP5.*;

PImage sprite;
// Atributos Configuráveis
float partSize = 10;
Solver s;
Menu menu;

int number_particles = 2000;
float gravity = 0.02;
float damping = 0.99;
float maxSpeed = 4;
float tension = 0.008;
float repulsion = 0.00008;
float stickyness = 1;
public float max_energy, del_energy, total_energy, group_energy;

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
                  
  s = new Solver(gravity,
                  damping,
                  number_particles,
                  maxSpeed,
                  tension,
                  repulsion,
                  stickyness);
                  
  s.setBnd(0, height, width, 0, 50);
  stroke(0, 0, 255);
  strokeWeight(2);
  fill(255);
  max_energy = (pow(2*s.maxSpeed, 2) + s.gravity * height) / 2;
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
  total_energy = 0;
  group_energy = 0;
  updateVariables();
  for (int i = 0; i < s.np; i ++){
    Particle p = s.ps[i];
    //drawParticle(new PVector(p.x,p.y),1);
    p.calcEnergy(gravity);
    total_energy += p.energy;
    if (p.selected)
      group_energy += p.energy;
    del_energy = 255 - (255 * p.energy / max_energy);
    fill(255,(int)del_energy,(int)del_energy);
    ellipse(p.x, p.y, partSize, partSize);
  }
  fill(0, 0, 255);
  
  text(round(frameRate), width - 20, 20);
  menu.energia1.setText("Energia total: " + (int)total_energy + " J");
  menu.energia2.setText("Energia selecionada: " + (int)group_energy + " J");

}
void updateVariables()
{
   s.gravity = menu.cp5.getController("Gravidade").getValue() / 500;
   s.maxSpeed = menu.cp5.getController("Velocidade Max").getValue() / 2.5;
   s.tension = menu.cp5.getController("Tensao").getValue() / 125;
   s.repulsion = menu.cp5.getController("Repulsao").getValue() / 1250;
   s.stickyness = (10 - menu.cp5.getController("Viscosidade").getValue()/5) / 10;
   s.np = (int)menu.cp5.getController("Particulas").getValue();
   partSize = menu.cp5.getController("Tamanho da particula").getValue();
   max_energy = (pow(2*s.maxSpeed, 2) + s.gravity * height) / 2;
}

