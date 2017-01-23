class Refraction {
  float incidenceAngle;    //入射角
  float refractiveAngle;   //屈折角
  float refractiveIndex1;  //入射側屈折率
  float refractiveIndex2;  //屈折側屈折率

  //初期化用メソッド(コンストラクタ)
  Refraction(
    float _refractiveIndex1, 
    float _refractiveIndex2, 
    float _incidenceAngle
    ) {
    refractiveIndex1 =_refractiveIndex1;
    refractiveIndex2 =_refractiveIndex2;
    incidenceAngle=_incidenceAngle;
  }

  //屈折角を計算するメソッド
  void calculation() {
    refractiveAngle=asin(refractiveIndex1/refractiveIndex2*sin(incidenceAngle));
  }


  void display() {
    strokeWeight(1);
    stroke(225);
    pushMatrix();
    stroke(255,0,0);
    line(-200*sin(incidenceAngle), 200*cos(incidenceAngle), 0, 0);  //入射光描写
    stroke(255,255,0);
    line(0, 0, 200*sin(refractiveAngle), -200*cos(refractiveAngle));//反射光描写
stroke(255,255,255);
    
    ellipse(0, 0, 2, 2);
    popMatrix();
  }
}