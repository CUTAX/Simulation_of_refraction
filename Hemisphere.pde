class Hemisphere {
  float sr;
  float thetaStart, thetaEnd;
  float phiStart, phiEnd;
  int  thetaDivision=18, phiDivision=36;
  float  thetaDivisionAngle, phiDivisionAngle;

  //初期化用メソッド(コンストラクタ)
  Hemisphere(float _sr, 
    float _thetaStart, float _thetaEnd, 
    float _phiStart, float _phiEnd) {
    sr=_sr;
    thetaStart=_thetaStart;
    thetaEnd =_thetaEnd;
    phiStart=_phiStart;
    phiEnd =_phiEnd;
  }

  void divisionSet(int _thetaDivision, int _phiDivision) {
    thetaDivision=_thetaDivision;
    phiDivision=_phiDivision;
  }

  void display() {
    float[][] x =new float [thetaDivision+1][phiDivision+1];
    float[][] y =new float [thetaDivision+1][phiDivision+1];
    float[][] z =new float [thetaDivision+1][phiDivision+1];
    //float theta, phi;
    thetaDivisionAngle=(thetaEnd-thetaStart)/thetaDivision;
    phiDivisionAngle=(phiEnd-phiStart)/phiDivision;
    for (int j=0; j<phiDivision+1; j++) {
      for (int i=0; i<thetaDivision+1; i++) {
        x[i][j]=sr*sin(radians(thetaDivisionAngle*i))*sin(radians(phiDivisionAngle*j));
        y[i][j]=sr*sin(radians(thetaDivisionAngle*i))*cos(radians(phiDivisionAngle*j));
        z[i][j]=sr*cos(radians(thetaDivisionAngle*i));
      }
    }

    //for (int j=0; j<phiDivision+1; j++) {
    //  for (int i=0; i<thetaDivision+1; i++) {
    //    strokeWeight(3);
    //    point(x[i][j], y[i][j], z[i][j]);
    //    strokeWeight(1);
    //  }
    //}

    noStroke();
    for (int i=0; i<thetaDivision; i++) {  
      beginShape(TRIANGLE_STRIP);
      for (int j=0; j<phiDivision+1; j++) {

        vertex(x[i][j], y[i][j], z[i][j]);
        vertex(x[i+1][j], y[i+1][j], z[i+1][j]);
      }

      endShape();
    }  
    noFill();
    stroke(1);
  }
}