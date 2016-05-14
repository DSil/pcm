import processing.video.*;
Movie movie1, movie2;
Movie[] movies = {movie1, movie2};
PImage frame;
int nframe, numPixels, curr_movie=0, other_movie=1;
Boolean wipe, fade, fadingOut, fadingIn, cube, ckey;
int filter, alpha, wipePixels;


void setup() {
  movie1 = new Movie(this, "PCMLab11-1.mov");
  movie2 = new Movie(this, "PCMLab11-2.mov");
  movies[0] = movie1;
  movies[1] = movie2;
  movies[curr_movie].play();
  movies[curr_movie].loop();
  movies[other_movie].play();
  movies[other_movie].loop();
  
  wipePixels = 0;
  wipe = false; fade = false; fadingOut =false; fadingIn = false; cube = false; ckey = false;
  size(320,240);
  alpha = 0;
}


void draw() {
  image(movies[curr_movie], 0, 0, 320, 240);

  frame = get(0,0,width,height);
  
  
  if(fade){
     fadeOut(frame, alpha);
  }
  if(cube){
     startCube();
  }
  if(wipe){
   startWipe(); 
  }
  if(ckey && curr_movie == 1) {
    chromaKey(frame);
  }

   updatePixels();
}



void keyPressed() {
  if(key == 'w')
    wipe = !wipe;
  if (key == 'a'){
    changeMovie();
  }
  if (key == 'f') { fade = !fade; fadingOut = !fadingOut;}
  if (key == 'c') { cube = !cube; }
  if (key == 'k') { ckey = !ckey; }
}

void movieEvent(Movie m) {
 m.read();
 

}

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
       changeMovie();
      }
   }
   else if(fadingIn == true){
      if(a>0){ 
        alpha = alpha - 5;
      }else{
       fade=false;
       fadingIn = false; 
      }
   } 
   
   image(img, 0, 0, 320, 240);
   
}

void chromaKey(PImage frame) {
  int loc;
  float r,g,b;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      loc = j*width+i;
      r = red(frame.pixels[loc]);
      g = green(frame.pixels[loc]);
      b = blue(frame.pixels[loc]);
      //println("" + r + " " + g + " " + b);
      if (g == 255 && r < 252 && b < 252)
        frame.pixels[loc] = movies[other_movie].pixels[loc];
    }
  }
  frame.updatePixels();
  image(frame, 0, 0);
}

void startCube(){
  if(wipePixels <= width){
    image(movies[other_movie], 0, 0, wipePixels, height);
    image(movies[curr_movie], wipePixels, 0, width-wipePixels, height);
    wipePixels++;
  } else{
    wipePixels = 0;
    changeMovie();
    cube = !cube;

  }
  
}

void startWipe(){
  if(wipePixels <= width){
    image(movies[other_movie], wipePixels-width, 0, width, height);
    image(movies[curr_movie], wipePixels, 0, width, height);
    wipePixels++;
  }else{
    wipePixels = 0;
    changeMovie();
    wipe = !wipe;

  }
  
}

void changeMovie(){
 int aux_movie = curr_movie;
 curr_movie = other_movie;
 other_movie = aux_movie;
}
