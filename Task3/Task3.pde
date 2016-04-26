import processing.video.*;
Movie movie;
PImage frame, prev_frame;
int filter; //0 = high_pass

float[][] hp_matrix = {{-1, -1, -1}, {-1, 9, -1}, {-1, -1, -1}};

void setup() {
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
  size(320,240);
  filter = 0;
}

void draw() {
  int loc;
  color c;
  prev_frame = get(0, 0, width, height);
  image(movie, 0, 0);
  frame = get(0, 0, width, height);
  image(frame, 0, 0);
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      c = apply_filter(x,y,frame);
      loc = x + y*frame.width;
      pixels[loc] = c;
    }
  }
  updatePixels();
}

void movieEvent(Movie m) {
  m.read();
}

color apply_filter(int x, int y, PImage img) {
  int xloc, yloc, loc;
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  float[][] matrix = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};
  switch (filter) {
    case 0: matrix = hp_matrix; break;
    default: break;
  }
  int matrixSize = matrix.length;
  int offset = matrixSize / 2;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      xloc = x+i-offset;
      yloc = y+j-offset;
      loc = xloc + img.width*yloc;
      loc = constrain(loc,0,img.pixels.length-1);
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  return color(rtotal, gtotal, btotal);
}


