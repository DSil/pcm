import processing.video.*;
Movie movie1, movie2;
Movie[] movies = {null, null};
PImage frame;
int nframe, numPixels, curr_movie=0, other_movie=1;
Boolean wipe, fade, fadingOut, fadingIn, cube, ckey, dissolving;
int filter, alpha, wipePixels;
ArrayList<Integer> pix;


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
  wipe = false; fade = false; fadingOut =false; fadingIn = false; cube = false; ckey = false; dissolving = false;
  size(movie1.width, movie1.height);
  pix = new ArrayList<Integer>(width*height);
  for(int i = 0; i < width*height; i++)
    pix.add(null);
  alpha = 0;
}


void draw() {
  image(movies[curr_movie], 0, 0, width, height);

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
  if(dissolving) {
    dissolve(frame);
  }
  if(ckey && curr_movie == 1) {
    chromaKey(frame);
  }

   //updatePixels();
}



void keyPressed() {
  if(key == 'w')
    wipe = !wipe;
  else if (key == 'a'){
    changeMovie();
  }
  else if (key == 'f') { fade = !fade; fadingOut = !fadingOut;}
  else if (key == 'c') { cube = !cube; }
  else if (key == 'k') { ckey = !ckey; }
  else if (key == 'd') { dissolving = !dissolving; }
}

void movieEvent(Movie m) {
 m.read();
 

}

void dissolve(PImage frame) {
  Integer random;
  if(pix.indexOf(null) == -1) {
    for(int i = 0; i < width*height; i++)
      pix.set(i, null);
    dissolving = !dissolving;
    changeMovie();
    return;
  }
  int step = 1000;
  while(step != 0) {
    random = (int) random(pix.size());
    pix.set(random, random);
    step--;
  }
  image(movies[other_movie], 0, 0, width, height);
  PImage otherFrame = get(0,0,width,height);
  for(int i = 0; i < pix.size(); i++) {
    random = pix.get(i);
    if(random != null)
      frame.pixels[random] = otherFrame.pixels[random];
  }
  frame.updatePixels();

  image(frame, 0, 0, width, height);
}

/** ESTE DÁ JEITO*/
//direction  1 --> in
//direction -1 --> out
void fadeOut(PImage img, int a) {
  
   for (int i = 0; i < width; i++) {
     for (int j = 0; j < height; j++) { 
       img.pixels[j*width+i] = color(255, 255, 255, a);  
     }
   } 
   
    if(fadingOut){
      if(a<255){ 
        alpha = alpha + 5;
      }
      else{
       fadingOut=false;
       fadingIn = true;
       changeMovie();
      }
   }
   else if(fadingIn){
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
