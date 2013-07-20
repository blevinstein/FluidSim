import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Fluid_3D extends PApplet {



final int N=50;
final int M=50;
final float SCALE=.25f;

final float DRAG = .003f;
final float GRAVITY=1;
final float TIMESTEP=.05f;

final float INIT = 0;
float h[][] = new float[N][M];
float vx[][] = new float[N-1][M];
float vy[][] = new float[N][M-1];

Shape boundary;

public void setup() {
  size(N*12,M*9,OPENGL);
  clear();
  boundary = new Square(.2f,.2f,.8f,.8f);
  //boundary = new Circle(.5,.5,.4);
  //boundary = new Ellipse(.5,.5,.2,.5);
}

public void clear() {
  for(int i=0;i<N;i++)
    for(int j=0;j<M;j++)
      h[i][j] = INIT;
  for(int i=0;i<N-1;i++)
    for(int j=0;j<M;j++)
      vx[i][j] = 0;
  for(int i=0;i<N;i++)
    for(int j=0;j<M-1;j++)
      vy[i][j] = 0;
}

public void step() {
  for(int i=0;i<N-1;i++)
    for(int j=0;j<M;j++) {
      if(!boundary.contains(i*1.0f/N,j*1.0f/M)) continue;
      vx[i][j] -= vx[i][j]*DRAG;
      vx[i][j] -= (h[i+1][j]-h[i][j])*GRAVITY*TIMESTEP;
    }
  for(int i=0;i<N;i++)
    for(int j=0;j<M-1;j++) {
      if(!boundary.contains(i*1.0f/N,j*1.0f/M)) continue;
      vy[i][j] -= vy[i][j]*DRAG;
      vy[i][j] -= (h[i][j+1]-h[i][j])*GRAVITY*TIMESTEP;
    }
  for(int i=0;i<N-1;i++)
    for(int j=0;j<M;j++) {
      h[i][j] -= vx[i][j]*TIMESTEP;
      h[i+1][j] += vx[i][j]*TIMESTEP;
    }
  for(int i=0;i<N;i++)
    for(int j=0;j<M-1;j++) {
      h[i][j] -= vy[i][j]*TIMESTEP;
      h[i][j+1] += vy[i][j]*TIMESTEP;
    }
}

public void mouseDragged() {
  drop(10);
}

public void mouseClicked() {
  drop(100);
}

public void drop(int amount) {
  int i = floor(map(mouseX,0,width,0,N));
  int j = floor(map(mouseY,0,height,0,M));
  if(boundary.contains(i*1.0f/N,j*1.0f/M))
    h[i][j] += amount;
}

public void draw() {
  step();
  
  background(0);
  boundary.plot();
  
  translate(width/2,height/2);
  scale(N*SCALE);
  rotateX(PI/3);
  translate(0,-N/3,0);
  
  stroke(255);
  noFill();
  //noStroke();
  //fill(0,0,255);
  beginShape(QUADS);
  for(int i=0;i<N-1;i++)
    for(int j=0;j<M-1;j++) {
      vertex(i-N/2,j-M/2,h[i][j]);
      vertex(i+1-N/2,j-M/2,h[i+1][j]);
      vertex(i+1-N/2,j+1-M/2,h[i+1][j+1]);
      vertex(i-N/2,j+1-M/2,h[i][j+1]);      
    }
  endShape();
}
interface Shape {
  public boolean contains(float x,float y);
  public void plot();
}

class Square implements Shape {
  float x1,y1,x2,y2;
  Square(float x1,float y1,float x2,float y2) {
    this.x1=min(x1,x2);
    this.y1=min(y1,y2);
    this.x2=max(x1,x2);
    this.y2=max(y1,y2);
  }
  public boolean contains(float px,float py) {
    return (px >= x1) && (px <= x2) && (py >= y1) && (py <= y2);
  }
  public void plot() {
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
  public boolean contains(float px,float py) {
    return dist(x,y,px,py)<r;
  }
  public void plot() {
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
  public boolean contains(float px,float py) {
    return dist(0,0,(px-x)/a,(py-y)/b)<1;
  }
  public void plot() {
    stroke(255);
    ellipseMode(CENTER);
    ellipse(x*width,y*width,a*width,b*height);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Fluid_3D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
