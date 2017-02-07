//circle x^2+y^2=r^2
//r半径
//ellipse (x-x0)^2/a^2+y^2/b^2=1
//a=x半径、b=Y半径、(x0、y0)=中心座標

class IntersectionOfCircleAndEllipse {
  float r, a, b, x0;
  float A, B, C, D;
  float x1, y1, x2, y2;
  boolean isRealNumber;

  //初期化用メソッド(コンストラクタ)
  IntersectionOfCircleAndEllipse(
    float _r, 
    float _a, float _b, 
    float _x0) {
    r= _r;
    a= _a;
    b= _b;
    x0= _x0;
  }

  void calculation() {
    A = sq(b)-sq(a);
    B = -2.0*sq(b)*x0;
    C = sq(b)*sq(x0)+sq(a)*sq(r)-sq(a)*sq(b);
    D=sq(B)-4.0*A*C;

    if (D<0) {
      isRealNumber=false;
    } else {
      isRealNumber=true;
      x1=(-B-sqrt(D))/(2*A);
      y1=sqrt(sq(r)-sq(x1));
      x2=(-B+sqrt(D))/(2*A);
      y2=sqrt(sq(r)-sq(x2));
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
  float D() {
    return D;
  }

  void display() {
    noFill();
    stroke(255);
    point(x0, 0);
    ellipse(0, 0, 2*r, 2*r);
    ellipse(x0, 0, 2.0*a, 2.0*b);
    ellipse(x1, y1, 5, 5);
    ellipse(x2, y2, 5, 5);
    stroke(0);
  }
}