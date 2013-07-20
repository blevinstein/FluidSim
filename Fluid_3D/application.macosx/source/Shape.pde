interface Shape {
  boolean contains(float x,float y);
  void plot();
}

class Square implements Shape {
  float x1,y1,x2,y2;
  Square(float x1,float y1,float x2,float y2) {
    this.x1=min(x1,x2);
    this.y1=min(y1,y2);
    this.x2=max(x1,x2);
    this.y2=max(y1,y2);
  }
  boolean contains(float px,float py) {
    return (px >= x1) && (px <= x2) && (py >= y1) && (py <= y2);
  }
  void plot() {
    stroke(255);
    rectMode(CORNERS);
    rect(x1*width,y1*height,x2*width,y2*height);
  }
}

class Circle implements Shape {
  float x,y,r;
  Circle(float x,float y,float r) {
    this.x=x;
    this.y=y;
    this.r=r;
  }
  boolean contains(float px,float py) {
    return dist(x,y,px,py)<r;
  }
  void plot() {
    stroke(255);
    ellipseMode(CENTER);
    ellipse(x*width,y*width,r*width,r*height);
  }
}

class Ellipse implements Shape {
  float x,y,a,b;
  Ellipse(float x,float y,float a,float b) {
    this.x=x;
    this.y=y;
    this.a=a;
    this.b=b;
  }
  boolean contains(float px,float py) {
    return dist(0,0,(px-x)/a,(py-y)/b)<1;
  }
  void plot() {
    stroke(255);
    ellipseMode(CENTER);
    ellipse(x*width,y*width,a*width,b*height);
  }
}
