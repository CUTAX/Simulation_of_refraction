import peasy.*;
PeasyCam cam;

Hemisphere Hemisphere;
Lens Lens;
Refraction[] refractions;
XyzVector XyzVector;
IntersectionOfEllipseAndLine[] Intersection;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ
float sr; //レンズのSR
float[] incidenceAngle; 
float theta=10;
float phi=0;

int numberOfLight;
float minDisFromCenter[];
float maxDisFromCenter[];
int minNumFromCenter[];
int maxNumFromCenter[];

float psiPitch=30;
float psi;
int psiNum;
float x1[], y1[], x2[], y2[];

PFont font;
int textSize=20;

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
  Hemisphere.divisionSet(5, 36);
  numberOfLight=floor(sr/pitch)+1; //光線の数

  refractions = new Refraction[numberOfLight];
  incidenceAngle=new float[numberOfLight];

  for (int i=0; i<refractions.length; i++) {
    incidenceAngle[i]=asin(i*pitch/sr);
    refractions[i] = new Refraction(1, 1.49, incidenceAngle[i]);
  }
  
    font =loadFont("OCRAExtended-48.vlw");
  textFont(font);
}

void draw() {
  pushMatrix();
  background(0);
  //屈折の計算
  for (int i=0; i<refractions.length; i++) {
    refractions[i].calculation();
  }
  //光線中心からのレンズまでの距離を計算
  psiNum=floor(360/psiPitch)-1;

  Intersection=new IntersectionOfEllipseAndLine[psiNum];
  x1=new float[psiNum];
  y1=new float[psiNum];
  x2=new float[psiNum];
  y2=new float[psiNum];
  minDisFromCenter=new float[psiNum];
  maxDisFromCenter=new float[psiNum];
  minNumFromCenter=new int[psiNum];
  maxNumFromCenter=new int[psiNum];

  for (int i=0; i<psiNum; i++) {
    psi=i*psiPitch;
    Intersection[i]=new IntersectionOfEllipseAndLine(
      d/2.0*cos(radians(theta)), d/2.0, 
      (sr-h)*sin(radians(theta)), 0, 
      tan(radians(psi)), 0);
    Intersection[i].calculation();
    x1[i]=Intersection[i].x1();
    y1[i]=Intersection[i].y1();
    x2[i]=Intersection[i].x2();
    y2[i]=Intersection[i].y2();

    if (psi>=0||psi<180) {  
      if (y1[i]<0||y2[i]<0) {
        minDisFromCenter[i]=0.0;
        maxDisFromCenter[i]=0.0;
      }
      if (y1[i]<0||y2[i]>=0) {
        minDisFromCenter[i]=0.0;
        maxDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
      } else {
        minDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
        maxDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
      }
    }
    if (psi>=180||psi<360) {  
      if (y1[i]>0||y2[i]>0) {
        minDisFromCenter[i]=0.0;
        maxDisFromCenter[i]=0.0;
      }
      if (y1[i]<0||y2[i]>=0) {
        minDisFromCenter[i]=0;
        maxDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
      } else {
        minDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
        maxDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
      }
    }

    minNumFromCenter[i]=floor(minDisFromCenter[i]/pitch);
    maxNumFromCenter[i]=floor(maxDisFromCenter[i]/pitch);
  }

  //描写の開始
  XyzVector.display();

  //レンズの描写(半球)
  pushMatrix();
  fill(0,100,255,50);
  //translate(0, 0, -sr+h);
  Hemisphere.display();
  popMatrix();

  //光線の描写
  pushMatrix();
  rotateX(radians(90));
  rotateY(radians(0));
  rotateZ(radians(theta));

  for (int j=0; j<psiNum; j++) {
    psi=psiPitch*j;
  pushMatrix();

    rotateY(radians(psi));

    for (int i=minNumFromCenter[j]; i<maxNumFromCenter[j]; i++) {
      pushMatrix();
      translate(i*pitch, sqrt(sq(Lens.sr())-sq(i*pitch)), 0 );
      rotateZ(-incidenceAngle[i]);


      refractions[i].display();
      popMatrix();
    }
  popMatrix();
    
  }
  popMatrix();
  
  popMatrix();  //3D表示終了
  
  /*text drawing*/
    hint(DISABLE_DEPTH_TEST);
  textSize(textSize);
  textAlign(LEFT, TOP);
  fill(255);
  text("psiNum="+nf(psiNum, 2, 0), 0, (textSize+5)*0);
  //text("cameraEyeY="+nf(cameraEyeY, 3, 1), 0, (textSize+5)*1);
  //text("cameraEyeZ="+nf(cameraEyeZ, 3, 1), 0, (textSize+5)*2);

  //text("cameraUpX="+nf(cameraUpX, 1, 2), 0, (textSize+5)*4);
  //text("cameraUpY="+nf(cameraUpY, 1, 2), 0, (textSize+5)*5);
  //text("cameraUpZ="+nf(cameraUpZ, 1, 2), 0, (textSize+5)*6);
  
  //text("scale="+nf(scale, 1, 2), 0, (textSize+5)*8);
  
  hint(ENABLE_DEPTH_TEST);
}