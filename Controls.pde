public class Controls {
  private ArrayList<ControlPoint> points;
  private PApplet app;
  //private static Controls c;

  public Controls(PApplet app) {
    points = new ArrayList<ControlPoint>();
    this.app = app;
    //Controls.c = new Controls();
  } 

  public Controls addControlPoint(float x, float y) {
    ControlPoint cp = new ControlPoint( x, y, this.app, this) ;
    points.add( cp );  
    return this;
  }

  public void drawControlPoints() {
    for (ControlPoint cp : points) {
      cp.drawControlPoint();
    }
  }

  public ControlPoint getPoint(int n) {
    return points.get(n);
  }

  public boolean offOtherPoints(ControlPoint onlyActive) {
    for (ControlPoint p : points) {
      if (!onlyActive.equals(p)) { 
        p.switchOff();
      }
    }
    return true;
  }

  public boolean isElsePointInPosition(ControlPoint in) {
    for (ControlPoint p : points) {
      if (in.equals(p)) {

        return false;
      }
    }

    return true;
  }

  public String toString() {
    return ("Size:" + points.size());
  }
}
