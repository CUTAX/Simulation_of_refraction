import peasy.*;
PeasyCam cam;

Hemisphere Hemisphere;
Lens Lens;
Refraction[] refractions;
XyzVector XyzVector;
IntersectionOfEllipseAndLine[] IntersectionEAndL;
IntersectionOfCircleAndEllipse IntersectionCAndE;

float pitch=10;//入射光ピッチ
float d=200;//レンズ直径
float h=50;//レンズ高さ
float sr; //レンズのSR
float[] incidenceAngle; 

float theta=0;
float phi=0;

int numberOfLight;
float minDisFromCenter[];
float maxDisFromCenter[];
int minNumFromCenter[];
int maxNumFromCenter[];

float psiPitch=10;
float psi;
int psiNum;
float x1[], y1[], x2[], y2[]; //レンズ外郭楕円とレンズ中心線の交点

boolean isRealNumCAndE;
float x3, y3;//レンズ外郭楕円とレンズSR球との接点(交点)
float psiContact; 

boolean thetaIsIncrease=false, thetaIsDecrease=false;
boolean phiIsIncrease=false, phiIsDecrease=false;

PFont font;
int textSize=20;

void setup() {
  size(1000, 500, P3D);
  //size(displayWidth, displayHeight, P3D);

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
  background(0);

/*theta,phi update*/
  if (thetaIsDecrease==true) {
    theta--;
    if (theta<=0) {
      theta=0;
    }
  }
  if (thetaIsIncrease==true) {
    theta++;
    if (theta>=80) {
      theta=80;
    }
  }
  if (phiIsDecrease==true) {
    phi--;
    if (phi<=0) {
      phi=360;
    }
  }
  if (phiIsIncrease==true) {
    phi++;
    if (phi>=360) {
      phi=0;
    }
  }


  /*屈折の計算*/
  for (int i=0; i<refractions.length; i++) {
    refractions[i].calculation();
  }
  //光線中心からのレンズまでの距離を計算
  psiNum=floor(360/psiPitch);

  IntersectionEAndL=new IntersectionOfEllipseAndLine[psiNum];
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

    IntersectionEAndL[i]=new IntersectionOfEllipseAndLine(
      d/2.0*cos(radians(theta)), d/2.0, 
      (sr-h)*sin(radians(theta)), 0.0, 
      tan(radians(psi)), 0.0);
    IntersectionEAndL[i].calculation();
    x1[i]=IntersectionEAndL[i].x1();
    y1[i]=IntersectionEAndL[i].y1();
    x2[i]=IntersectionEAndL[i].x2();
    y2[i]=IntersectionEAndL[i].y2();


    if ((psi>=0&&psi<90)||(psi>=270&&psi<360)) {  
      if (x1[i]<=0&&x2[i]>0) {
        minDisFromCenter[i]=0.0;
        maxDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
      } else if (x1[i]>0&&x2[i]>0) {
        minDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
        maxDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
      } else {
        minDisFromCenter[i]=0.0;
        maxDisFromCenter[i]=0.0;
      }
    } else if (psi>=90&&psi<270) {  
      if (x1[i]<=0&&x2[i]<=0) {
        minDisFromCenter[i]=sqrt(sq(x2[i])+sq(y2[i]));
        maxDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
      } else if (x1[i]<=0&&x2[i]>0) {
        minDisFromCenter[i]=0;
        maxDisFromCenter[i]=sqrt(sq(x1[i])+sq(y1[i]));
      } else {
        minDisFromCenter[i]=0;
        maxDisFromCenter[i]=0;
      }
    }

    IntersectionCAndE=new IntersectionOfCircleAndEllipse(
      sr, d/2.0*cos(radians(theta)), d/2.0, (sr-h)*sin(radians(theta)));
    IntersectionCAndE.calculation();
    isRealNumCAndE=IntersectionCAndE.isRealNumber();
    if (isRealNumCAndE==true) {
      x3=IntersectionCAndE.x1();
      y3=IntersectionCAndE.y1();
      psiContact=degrees(atan(y3/x3));
      if (psi<=psiContact||psi>=360-psiContact) {
        maxDisFromCenter[i]=sr;
      }
    }
    minNumFromCenter[i]=floor(minDisFromCenter[i]/pitch);
    maxNumFromCenter[i]=floor(maxDisFromCenter[i]/pitch);
  }

  //描写の開始
  XyzVector.display();

  //レンズの描写(半球)
  pushMatrix();
  fill(0, 100, 255);
  //translate(0, 0, -sr+h);
  Hemisphere.display();
  popMatrix();

  //光線の描写
  pushMatrix();
  rotateX(radians(90));
  rotateY(radians(phi));
  rotateZ(radians(theta));

  for (int j=0; j<psiNum; j++) {
    psi=psiPitch*j;
    pushMatrix();

    rotateY(radians(psi));

    for (int i=minNumFromCenter[j]; i<=maxNumFromCenter[j]; i++) {
      pushMatrix();
      translate(i*pitch, sqrt(sq(Lens.sr())-sq(i*pitch)), 0 );
      rotateZ(-incidenceAngle[i]);
      refractions[i].display();
      popMatrix();
    }
    popMatrix();
  }
  popMatrix();  //3D表示終了

  /*text drawing*/
  pushMatrix();
  camera(width/2, height/2, 1000, width/2, height/2, 0, 0, 1, 0);
  hint(DISABLE_DEPTH_TEST);//一番上に表示
  textSize(textSize);
  textAlign(LEFT, TOP);
  fill(255);
  text("psiNum="+nf(psiNum, 2, 0), 0, (textSize+5)*0);
  text("theta="+nf(theta, 3, 0)+" deg", 0, (textSize+5)*1);
  text("phi="+nf(phi, 3, 0)+" deg", 0, (textSize+5)*2);

  text("minDisFromCenter[0]="+nf(minDisFromCenter[0], 3, 2), 0, (textSize+5)*5);
  text("maxDisFromCenter[0]="+nf(maxDisFromCenter[0], 3, 2), 0, (textSize+5)*6);
  //text("cameraUpY="+nf(cameraUpY, 1, 2), 0, (textSize+5)*5);
  //text("cameraUpZ="+nf(cameraUpZ, 1, 2), 0, (textSize+5)*6);

  //text("scale="+nf(scale, 1, 2), 0, (textSize+5)*8);
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  translate(120, 300);
  line(-10, 0, 20, 0);
  line(0, -10, 0, 20);
  for (int i=0; i<psiNum; i++) {
    stroke(255, 0, 0);
    ellipse(x1[i], y1[i], 3, 3);
    text("i="+i, x1[i], y1[i]);
    stroke(0, 255, 0);
    ellipse(x2[i], y2[i], 3, 3);
    text("i="+i, x2[i], y2[i]);
  }
  popMatrix();
  popMatrix();
}

void keyPressed() {
  if (keyCode==UP) {
    thetaIsDecrease=true;
  }
  if (keyCode==DOWN) {
    thetaIsIncrease=true;
  }
  if (keyCode==LEFT) {
    phiIsIncrease=true;
  }
  if (keyCode==RIGHT) {
    phiIsDecrease=true;
  }
}

void keyReleased() {
  if (keyCode==UP) {
    thetaIsDecrease=false;
  }
  if (keyCode==DOWN) {
    thetaIsIncrease=false;
  }
  if (keyCode==LEFT) {
    phiIsIncrease=false;
  }
  if (keyCode==RIGHT) {
    phiIsDecrease=false;
  }
}