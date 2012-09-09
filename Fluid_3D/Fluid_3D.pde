import processing.opengl.*;

final int N=50;
final int M=50;
final float SCALE=.25;

final float DRAG = .003;
final float GRAVITY=1;
final float TIMESTEP=.05;

final float INIT = 0;
float h[][] = new float[N][M];
float vx[][] = new float[N-1][M];
float vy[][] = new float[N][M-1];

Shape boundary;

void setup() {
  size(N*12,M*9,OPENGL);
  clear();
  boundary = new Square(.2,.2,.8,.8);
  //boundary = new Circle(.5,.5,.4);
  //boundary = new Ellipse(.5,.5,.2,.5);
}

void clear() {
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

void step() {
  for(int i=0;i<N-1;i++)
    for(int j=0;j<M;j++) {
      if(!boundary.contains(i*1.0/N,j*1.0/M)) continue;
      vx[i][j] -= vx[i][j]*DRAG;
      vx[i][j] -= (h[i+1][j]-h[i][j])*GRAVITY*TIMESTEP;
    }
  for(int i=0;i<N;i++)
    for(int j=0;j<M-1;j++) {
      if(!boundary.contains(i*1.0/N,j*1.0/M)) continue;
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

void mouseDragged() {
  drop(10);
}

void mouseClicked() {
  drop(100);
}

void drop(int amount) {
  int i = floor(map(mouseX,0,width,0,N));
  int j = floor(map(mouseY,0,height,0,M));
  if(boundary.contains(i*1.0/N,j*1.0/M))
    h[i][j] += amount;
}

void draw() {
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
