//ellipse (x-x0)^2/a^2+(y-y0)^2/b^2=1
//a=x半径、b=Y半径、(x0、y0)=中心座標
//line y=cx+d

class IntersectionOfEllipseAndLine {
  float a, b, c, d, x0, y0;
  float A, B, C, D;
  float x1, y1, x2, y2;
  boolean isRealNumber;

  //初期化用メソッド(コンストラクタ)
  IntersectionOfEllipseAndLine(
    float _a, float _b, 
    float _x0, float _y0, 
    float _c, float _d
    ) {
    a= _a;
    b= _b;
    x0= _x0;
    y0= _y0;
    c= _c;
    d= _d;
  }

  void calculation() {
    A = 1.0/sq(a)+sq(c)/sq(b);
    B = -2.0*x0/sq(a)+2.0*c*(d-y0)/sq(b);
    C = sq(x0)/sq(a)+sq(d-y0)/sq(b)-1.0;
    D=sq(B)-4.0*A*C;

    if (d<0) {
      isRealNumber=false;
    } else {
      isRealNumber=true;
      x1=(-B-sqrt(D))/(2*A);
      y1=c*x1+d;
      x2=(-B+sqrt(D))/(2*A);
      y2=c*x2+d;
    }
  }

  boolean isRealNumber() {
    return isRealNumber;
  }
  float x1() {
    return x1;
  }
  float y1() {
    return y1;
  }
  float x2() {
    return x2;
  }
  float y2() {
    return y2;
  }

  void display() {
    noFill();
    stroke(255, 0, 0);
    point(x0, y0);
    ellipse(x0, y0, 2.0*a, 2.0*b);
    line(0, 0, 300, 300*c);
    stroke(0);
  }
}