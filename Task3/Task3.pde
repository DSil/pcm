import processing.video.*;
Movie movie;
PImage frame, prev_frame;
Boolean difference1, difference2, filterOn, horizontalFlipOn, verticalFlipOn;
int filter; //0 = high_passl, 1 = low_pass, 2 = edge_detection, 3 = emboss blur

float[][] hp_matrix = {{-1, -1, -1}, {-1, 9, -1}, {-1, -1, -1}};
float[][] lp_matrix = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};
float[][] ed_matrix = {{-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1}};
float[][] emboss_matrix = {{2, 0, 0}, {0, -1, 0}, {0, 0, -1}};
float[][] motion_matrix = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};


void setup() {
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
  size(320,240);
  filter = -1;
  difference1 = false;
  difference2 = false;
  filterOn = false;
  horizontalFlipOn = false;
  verticalFlipOn = false;
}

void draw() {
  int loc;
  color c;
  prev_frame = get(0, 0, width, height);
  image(movie, 0, 0);
  frame = get(0, 0, width, height);
  image(frame, 0, 0);
  loadPixels();
  if(!difference1 && !difference2) {
    if(filterOn) {
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          c = apply_filter(x,y,frame);
          loc = x + y*frame.width;
          pixels[loc] = c;
        }
      }
    }
  }
  else if(difference1 || difference2) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        loc = x + y*frame.width;
        if(difference1)
          pixels[loc] = calculateDiff1(loc, prev_frame, frame);
        else
          pixels[loc] = calculateDiff2(loc, prev_frame, frame);
      }
    }
  }
  if(horizontalFlipOn) {
    horizontalMirror(frame);
    frame = get(0,0,width,height);
  } 
  if(verticalFlipOn)
    verticalMirror(frame);
  updatePixels();
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed() {
  if(key == 'd')
    difference1 = !difference1;
  else if(key == 'e')
    difference2 = !difference2;
  else if(key == '0' || key == '1' || key == '2' || key == '3' || key=='4')
    filter = Character.getNumericValue(key);
  else if(key == 'f')
    filterOn = !filterOn;
  else if(key == 'm')
    horizontalFlipOn = !horizontalFlipOn;
  else if(key == 'v')
    verticalFlipOn = !verticalFlipOn;
}

void horizontalMirror(PImage img){
   for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) {    
       pixels[j*width+i] = img.pixels[(width - i - 1) + j*width]; // Reversing x to mirror the image
     }
   }
}

void verticalMirror(PImage img) {
  for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) {    
       pixels[j*width+i] = img.pixels[(height - j - 1)*width+i]; // Reversing y to mirror the image
     }
   }
}

color calculateDiff1(int loc, PImage prev, PImage actual) {
  int dif = actual.pixels[loc] - prev.pixels[loc];
  if(dif > 0)
    return color(255);
  else if(dif < 0)
    return color(0);
  else return actual.pixels[loc];
}

color calculateDiff2(int loc, PImage prev, PImage actual) {
  int dif = actual.pixels[loc] - prev.pixels[loc];
  if(dif != 0)
    return color(255);
  else
    return color(0);
}

color apply_filter(int x, int y, PImage img) {
  int xloc, yloc, loc;
  float p = 0.0;
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  float[][] matrix = {{0, 0, 0}, {0, 1, 0}, {0, 0, 0}};
  switch (filter) {
    case 0: matrix = hp_matrix; break;
    case 1: matrix = lp_matrix; break;
    case 2: matrix = ed_matrix; break;
    case 3: matrix = emboss_matrix; break;
    case 4: matrix = motion_matrix; break;
    //case 5: matrix = _matrix; break;
    default: break;
  }
  int matrixSize = matrix.length;
  int offset = matrixSize / 2;
  for(int i = 0; i < matrixSize; i++)
    for(int j = 0; j < matrixSize; j++)
      p += matrix[i][j];
  if (p == 0) p = 1;
  for (int i = 0; i < matrixSize; i++) {
    for (int j = 0; j < matrixSize; j++) {
      xloc = x+i-offset;
      yloc = y+j-offset;
      loc = xloc + img.width*yloc;
      loc = constrain(loc,0,img.pixels.length-1);
      rtotal += ((red(img.pixels[loc]) * matrix[i][j])/p);
      gtotal += ((green(img.pixels[loc]) * matrix[i][j])/p);
      btotal += ((blue(img.pixels[loc]) * matrix[i][j])/p);
    }
  }
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  return color(rtotal, gtotal, btotal);
}


