final int N=50;
final int M=50;
final int SCALE=2;

final float DRAG = .01;
final float GRAVITY=1;
final float TIMESTEP=.1;

final float INIT = 128;
float h[][] = new float[N][M];
float vx[][] = new float[N-1][M];
float vy[][] = new float[N][M-1];

void setup() {
  size(N*SCALE,M*SCALE);
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
      vx[i][j] -= (h[i+1][j]-h[i][j])*GRAVITY*TIMESTEP + vx[i][j]*DRAG;
    }
  for(int i=0;i<N;i++)
    for(int j=0;j<M-1;j++) {
      vy[i][j] -= (h[i][j+1]-h[i][j])*GRAVITY*TIMESTEP + vy[i][j]*DRAG;
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
  drop(1000);
}

void mouseClicked() {
  drop(10000);
}

void drop(int amount) {
  if(mouseX>=0 && mouseX/SCALE<N && mouseY>=0 && mouseY/SCALE<M)
    h[mouseX/SCALE][mouseY/SCALE] += amount;
}

void draw() {
  step();
  for(int i=0;i<N;i++)
    for(int j=0;j<M;j++) {
      /*
      stroke(h[i][j]);
      point(i,j);
      */
      noStroke();
      fill(0,0,h[i][j]);
      rect(i*SCALE,j*SCALE,(i+1)*SCALE-1,(j+1)*SCALE-1);
    }
}
