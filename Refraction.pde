class Refraction {
  float incidenceAngle, refractiveAngle, 
    refractiveIndex1, refractiveIndex2;

  //初期化用メソッド(コンストラクタ)
  Refraction(
    float _refractiveIndex1, 
    float _refractiveIndex2, 
    float _incidenceAngle
    ) {
    incidenceAngle=_incidenceAngle;
    refractiveIndex1 =_refractiveIndex1;
    refractiveIndex2 =_refractiveIndex2;
  }

  //屈折角を計算するメソッド
  void calculation() {
    refractiveAngle=degrees(asin(refractiveIndex1/refractiveIndex2*sin(radians(incidenceAngle))));
  }


  void display() {
    strokeWeight(1);
    stroke(225);
    pushMatrix();
    line(200*sin(radians(incidenceAngle)), 200*cos(radians(incidenceAngle)), 0, 0);
    line(0, 0, -200*sin(radians(refractiveAngle)), -200*cos(radians(refractiveAngle)));
    ellipse(0,0,2,2);
    popMatrix();
  }
}