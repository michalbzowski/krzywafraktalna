public class Point {
  float x, y;

  Point(float x_, float y_) {
    this.x = x_;
    this.y = y_;
  }

  Point copy() {
    return new Point(x, y);
  }

  String toString() {
    return "[ " + x +" : "+y+" ]";
  }

  public Point half(Point p) {
    float x = this.x + p.x;
    float y = this.y + p.y;
    return new Point(x/2, y/2);
  }

  public boolean equals(Object obj) {
    if (obj != null && obj instanceof Point) {
      Point p = (Point)obj;
      if (this.x == p.x && this.y == p.y) {
        return true;
      }
    } 
    return false;
  }
}

