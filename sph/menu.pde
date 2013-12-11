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
    this.cp5 = cp5;
    noStroke();
    
    
  PFont p = createFont("Aller.ttf",12); 
  cp5.setControlFont(p,14);
  cp5.setColorLabel(color(255,128));
    
    cp5.addSlider("Gravidade")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.01,7)
     .setRange(0,0.10)
     .setValue(g)
     ;
    cp5.addSlider("Damping")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.198,7)
     .setRange(0,255)
     ;
    cp5.addSlider("Velocidade Max")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.365,7)
     .setRange(0.5,6)
     ;
    cp5.addSlider("Tensao")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.6,7)
     .setRange(10,1500)
     ;
    cp5.addSlider("Repulsao")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.758,7)
     .setRange(10,1500)
     ;
    cp5.addSlider("Viscosidade")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.01,30)
     .setRange(10,1500)
     ;
    cp5.addSlider("Particulas")
     .setWidth(width/15)
     .setHeight(15)
     .setPosition(width*0.8,30)
     .setRange(10,1500)
     ;
  }
  void update()
  {
    fill(150);
    noStroke();
    rect(0,0,width,height*0.085);

  } 
}
