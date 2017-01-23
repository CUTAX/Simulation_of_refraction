class Lens {
  float d, h, sr;

  //初期化用メソッド(コンストラクタ)
  Lens(float _d, float _h) {
    d=_d;
    h =_h;
  }

  //屈折角を計算するメソッド
  float sr() {
    sr=sq(d)/(8.0*h)+h/2.0;
    return sr;
  }


  void display() {
    strokeWeight(1);
    stroke(225);
    noFill();
    //rotateX(radians(-90));
    pushMatrix();
    arc(0, h-sr, 2.0*sr, 2.0*sr, radians(90-degrees(asin(d/(2*sr)))), radians(90+degrees(asin(d/(2*sr)))));
    popMatrix();
  }
}