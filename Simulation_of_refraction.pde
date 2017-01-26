import peasy.*;
PeasyCam cam;

Hemisphere Hemisphere;
Lens Lens;
Refraction[] refractions;
XyzVector XyzVector;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ
float sr; //レンズのSR
float[] incidenceAngle; 

int numberOfLight;

void setup() {
  size(displayWidth, displayHeight, P3D);

  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(500);

  ortho(-width/2, width/2, -height/2, height/2, -1000, 1000);
  ambientLight(20, 20, 20);    //環境光を当てる
  lightSpecular(255, 255, 255);    //光の鏡面反射色（ハイライト）を設定
  directionalLight(100, 100, 100, 0, 1, -1);    //指向性ライトを設定

  XyzVector=new XyzVector(100);

  Lens=new Lens(d, h);
  sr=Lens.sr();
  Hemisphere=new Hemisphere(sr, 0.0, Lens.theta(), 0.0, 360.0);
  Hemisphere.divisionSet(5,36);
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

  //レンズの描写(半球)
  pushMatrix();
  translate(0, 0, -sr+h);
  Hemisphere.display();
  popMatrix();

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