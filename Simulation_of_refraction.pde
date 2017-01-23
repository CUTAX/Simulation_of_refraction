import peasy.*;
PeasyCam cam;

Refraction[] refractions = new Refraction[9];
Lens Lens;
XyzVector XyzVector;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ

void setup() {
  //cam = new PeasyCam(this, 200);
  //cam.setMinimumDistance(500);
  //cam.setMaximumDistance(500);

  //ortho(-width/2, width/2, -height/2, height/2, -100, 100);

  size(displayWidth, displayHeight, P3D);

  Lens=new Lens(d, h);
  XyzVector=new XyzVector(100);

  for (int i=0; i<refractions.length; i++) {
    refractions[i] = new Refraction(1, 1.49, degrees(asin(i*pitch/Lens.sr())));
  }
}

void draw() {
  background(0);
  translate(width/2, height/2);
  for (int i=0; i<refractions.length; i++) {
    refractions[i].calculation();
    pushMatrix();
    translate(i*pitch, sqrt(sq(Lens.sr())-sq(i*pitch))-Lens.sr()+h,0 );
    rotateZ(asin(i*pitch/Lens.sr()));
    refractions[i].display();
    popMatrix();
  }
  Lens.display();
  XyzVector.display();
}