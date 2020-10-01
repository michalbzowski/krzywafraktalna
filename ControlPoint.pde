public class ControlPoint extends Point {
  private int ctrRadius = 3;
  private boolean canMove=false;
  private Controls controls;

  ControlPoint(float ctrX, float ctrY, PApplet app, Controls controls) {
    super(ctrX, ctrY);
    app.registerMethod("mouseEvent", this);
    this.controls = controls;
  }

  void drawControlPoint() {
    ellipseMode(RADIUS);
    fill(255, 102, 0);
    ellipse(x, y, ctrRadius, ctrRadius);
    noFill();
  }

  public void mouseEvent(MouseEvent event) {
    switch(event.getAction()) {
    case MouseEvent.PRESS:
      pressed();
      break;
    case MouseEvent.DRAG:
      dragged();
      break;
    case MouseEvent.RELEASE:
      released();
    }
  }

  public void pressed() {
    if (mouseButton == LEFT) {
      if (mouseOverPoint() &&   controls.offOtherPoints(this)) {
        canMove=true;
        x=mouseX; 
        y=mouseY;
      }
    }
  }


  private boolean mouseOverPoint() {
    if (!(mouseX<=x+ctrRadius && mouseX >=x-ctrRadius)) {
      return false;
    } 
    if (!(mouseY<=y+ctrRadius && mouseY >=y-ctrRadius)) {
      return false ;
    }
    return true;
  }

  void dragged() {
    if ( canMove && controls.offOtherPoints(this) ) {
      x=mouseX; 
      y=mouseY;
    }
  }

  public void switchOff() {
    canMove = false;
  }


  void released() {
    canMove=false;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  Point getPoint() {
    return new Point(x, y);
  }

  public boolean equals(Object obj) {

    if (obj != null && obj instanceof ControlPoint) {
      ControlPoint p = (ControlPoint)obj;
      if (abs(this.x - p.x)<  ctrRadius  && abs(this.y - p.y)< ctrRadius) {

        return true;
      }
    } 

    return false;
  }
}

