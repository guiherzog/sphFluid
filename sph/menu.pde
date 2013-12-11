int Particulas;

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
  Textlabel energia1;
  Textlabel energia2;
  
  
  
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
  cp5.setColorLabel(color(0,0));
    
    cp5.addSlider("Gravidade")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.01,7)
     .setRange(0,20)
     .setValue(9.8)
     ;
    cp5.addSlider("Velocidade Max")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.2,7)
     .setRange(1,20)
     .setValue(15)
     ;
    cp5.addSlider("Tensao")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.44,7)
     .setRange(1,10)
     .setValue(1)
     ;
    cp5.addSlider("Repulsao")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.6,7)
     .setRange(1,10)
     .setValue(1)
     ;
    cp5.addSlider("Viscosidade")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.78,7)
     .setRange(0,10)
     .setValue(0)
     ;
    cp5.addSlider("Tamanho da particula")
     .setWidth(width/15)
     .setHeight(17)
     .setPosition(width*0.44,30)
     .setRange(3,40)
     .setValue(20)
     ;
    cp5.addSlider("Particulas")
     .setWidth(width/8)
     .setHeight(17)
     .setPosition(width*0.735,30)
     .setRange(250,1500)
     .setValue(500)
     ;
    
    energia1 = cp5.addTextlabel("label1")
     .setText("")
     .setPosition(width*0.005,30)
     .setColorValue(0)
     .setFont(createFont("Aller.ttf",14))
     ;
    
    energia2 = cp5.addTextlabel("label2")
     .setText("")
     .setPosition(width*0.195,30)
     .setColorValue(0)
     .setFont(createFont("Aller.ttf",14))
     ;
  }
  void update()
  {
    fill(150);
    noStroke();
    rect(0,0,width,height*0.0895);

  } 
}
