import processing.video.*;
Movie movie1, movie2, movie_aux; 
PImage frame;
int nframe, numPixels, movie=2;
Boolean wipe, fade, fadingOut, fadingIn;
int filter, alpha;


void setup() {
  movie1 = new Movie(this, "PCMLab11-1.mov");
  movie2 = new Movie(this, "PCMLab11-2.mov");
  movie_aux = movie2;
  movie_aux.play();
  nframe =0;
  numPixels = 320; wipe = false; fade = false; fadingOut =false; fadingIn = false;
  size(320,240);
  alpha = 0;
}


void draw() {
  image(movie_aux, 0, 0, 320, 240);
  frame = get(0,0,width,height);
  nframe++; 
  
  if(fade){ 
     fadeOut(frame, alpha);
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

void changeMovie(){
 movie_aux.pause();
 if(movie==1){
   movie=2;
   movie_aux = movie2;
 }else{
  movie = 1;
  movie_aux = movie1; 
 }
 movie_aux.play();
 movie_aux.loop();
}
