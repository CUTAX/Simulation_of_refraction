import peasy.*;
PeasyCam cam;

Refraction[] refractions;
Lens Lens;
XyzVector XyzVector;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ
float sr; //レンズのSR
float[] incidenceAngle; 

int numberOfLight;

void setup() {
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(500);

  ortho(-width/2, width/2, -height/2, height/2, -1000, 1000);
  size(displayWidth, displayHeight, P3D);

  XyzVector=new XyzVector(100);

  Lens=new Lens(d, h);
  sr=Lens.sr();
  numberOfLight=floor(sr/pitch)+1; //光線の数

  refractions = new Refraction[numberOfLight];
  incidenceAngle=new float[numberOfLight];

  for (int i=0; i<refractions.length; i++) {
    incidenceAngle[i]=asin(i*pitch/sr);
    refractions[i] = new Refraction(1, 1.49, incidenceAngle[i]);
  }
}

void draw() {
  background(0);
  //屈折の計算
  for (int i=0; i<refractions.length; i++) {
    refractions[i].calculation();
  }

  //描写の開始
  XyzVector.display();
  pushMatrix();
  rotateX(radians(90));
  Lens.display();//レンズの描写

//光線の描写
  for (int j=0; j<8; j++) {
    rotateY(radians(45*j));
    for (int i=0; i<refractions.length; i++) {
      pushMatrix();
      translate(i*pitch, sqrt(sq(Lens.sr())-sq(i*pitch))-Lens.sr()+h, 0 );
      rotateZ(-incidenceAngle[i]);
      refractions[i].display();
      popMatrix();
    }
  }
  popMatrix();
}