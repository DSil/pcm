import processing.video.*;
Movie movie;
PrintWriter output, t1;
boolean frameTrigger;
final int TIMER = 5050;
float duration;
PImage frame;
int[] histogram = new int[256];
int[] prev_histogram = new int[256];

void setup() {
  movie = new Movie(this, "PCMLab10.mov");
  movie.play();
  duration = movie.duration();
  size(960,540);
  frameTrigger = false;
  thread("timer");
  output = createWriter("stroboscopic_segmentation.txt");
  t1 = createWriter("detected_transitions.txt");
  for (int i = 0; i < 256; i++) {
    prev_histogram[i] = 0;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  image(movie, 0, 0);
  frame = get(0,0,width,height);
  //histogram = calculateHistogram(frame);
  if(frameTrigger) {
    frameTrigger = false;
    saveFrame("Frame-##.png");
    output.println(movie.time());
  }
}

void timer() {
  while(movie.time() != duration) {
    frameTrigger = true;
    delay(TIMER);
  }
  output.flush();
  output.close();
}

int[] calculateHistogram(PImage img) {
  int[] histogram = new int[256];
  int loc;
  float luminance,r,g,b;
   // Calculate the histogram
  for (int y = 0; y < img.width; y++) {
    for (int x = 0; x < img.height; x++) {
      loc = x + y*img.width;
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
      luminance = 0.3 * r + 0.59 * g  + 0.11*b;
      histogram[(int)luminance]++; 
    }
  }
  return histogram;
}
