import peasy.*;
PeasyCam cam;

Refraction[] refractions = new Refraction[9];
Lens Lens;
XyzVector XyzVector;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ
float incidenceAngle; 

void setup() {
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(500);

  ortho(-width/2, width/2, -height/2, height/2, -1000, 1000);

  size(displayWidth, displayHeight, P3D);

  Lens=new Lens(d, h);
  XyzVector=new XyzVector(100);

  for (int i=0; i<refractions.length; i++) {
    incidenceAngle=asin(i*pitch/Lens.sr());
    refractions[i] = new Refraction(1, 1.49, incidenceAngle);
  }
}

void draw() {
  background(0);


  for (int i=0; i<refractions.length; i++) {
    refractions[i].calculation();

    XyzVector.display();
    
    pushMatrix();
    rotateX(radians(90));
    Lens.display();
    pushMatrix();
    translate(-i*pitch, sqrt(sq(Lens.sr())-sq(i*pitch))-Lens.sr()+h, 0 );
    //rotateZ(incidenceAngle);
    refractions[i].display();
    popMatrix();
    popMatrix();
  }
}