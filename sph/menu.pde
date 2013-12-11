class Menu
{

  
  // Atributos //
  float gravity;
  float damping;
  int nParticles;
  float maxSpeed;
  float tension;
  float repulsion;
  float sticky;
  ControlP5  cp5;
  
  Menu(     ControlP5 cp5,
            float g,
            float d,
            int  nP,
            float mS,
            float t,
            float r,
            float s
            )
  {
    this.gravity = g;
    this.damping = d;
    this.nParticles = nP;
    this.maxSpeed = mS;
    this.tension = t;
    this.repulsion = r;
    this.sticky = s;
    noStroke();
    
    cp5.addSlider("Gravidade")
     .setPosition(width*0.01,5)
     .setRange(0,0.10)
     .setValue(g);
     ;
    cp5.addSlider("Damping")
     .setPosition(width*0.21,5)
     .setRange(0,255)
     ;
    cp5.addSlider("Particles")
     .setPosition(width*0.81,5)
     .setRange(10,1500)
     ;    
  }
  void update()
  {
    fill(150);
    noStroke();
    rect(0,0,width,height*0.03);

  } 
}
