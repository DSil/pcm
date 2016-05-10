import processing.video.*;
Movie movie1, movie2, movie_aux; 
PImage frame;
int nframe, numPixels;
Boolean wipe, fade, fadingOut, fadingIn;
int filter, alpha; //0 = high_passl, 1 = low_pass, 2 = edge_detection, 3 = emboss blur 4 = motion


void setup() {
  movie1 = new Movie(this, "PCMLab11-1.mov");
  movie2 = new Movie(this, "PCMLab11-2.mov");
  movie_aux = movie2;
  
  nframe =0;
  numPixels = 320; wipe = false; fade = false; fadingOut =false; fadingIn = false;
  size(320,240);
  alpha = 0;
  
/**  size(320,240);
  filter = -1;
  difference1 = false;
  difference2 = false;
  filterOn = false;
  horizontalFlipOn = false;
  verticalFlipOn = false;*/
}


void draw() {
 
  image(movie_aux, 0, 0, 320, 240);
  frame = get(0,0,width,height);
  nframe++; 
  
  if(fade){ 
     fadeOut(frame, alpha);
  }
  
    
  
  
  /* int loc;
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
    updatePixels();
    frame = get(0,0,width,height);
  } 
  if(verticalFlipOn)
    verticalMirror(frame);   */ 
  updatePixels();
}



void keyPressed() {
  if(key == 'w')
    wipe = !wipe;
  if (key == 'a'){
     movie1.play();
     movie1.loop();
     movie_aux = movie1;
  }
  if (key == 's'){
     movie2.play();
     movie2.loop();
     movie_aux = movie2;
   }
  if (key == 'f') { fade = !fade; fadingOut = !fadingOut;}
}

void movieEvent(Movie m) {
 m.read();
 

}

/*void horizontalMirror(PImage img){
   for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) {    
       pixels[j*width+i] = img.pixels[(width - i - 1) + j*width]; // Reversing x to mirror the image
     }
   }
}*/

/** ESTE DÁ JEITO*/
//direction  1 --> in
//direction -1 --> out
void fadeOut(PImage img, int a) {
  
   for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) { 
       img.pixels[j*width+i] = color(255, 255, 255, a);   // Reversing y to mirror the image img.pixels[(height - j - 1)*width+i];
     }
   } 
   
    if(fadingOut == true){
      if(a<255){ 
        alpha = alpha + 5;
      }
      else{
       fadingOut=false;
       fadingIn = true;
      }
   }
   else if(fadingIn == true){
      movie_aux = movie2;
      if(a>0){ 
        alpha = alpha - 5;
      }else{
       fade=false;
       fadingIn = false; 
      }
   } 
   
   image(img, 0, 0, 320, 240);
   
}

void startWipe(PImage frame1, PImage frame2){
  /*  while(numPixels>0){
      for (int i = 0; i < width; i++) {
         for (int j = 0; j < height; j++) {    
           pixels[j*width+i] = img.pixels[(height - j - 1)*width+i]; // Reversing y to mirror the image
         }
       }
      numPixels--;  
    }
    numPixels = 320;*/
}



/*color apply_filter(int x, int y, PImage img) {
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
*/
