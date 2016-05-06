import processing.video.*;
Movie movie;
PrintWriter output, t1;
boolean frameTrigger;
final int TIMER = 5050;
float duration;
PImage frame;
int[] histogram = new int[256];
int[] prev_histogram = new int[256];
int threshold = 300000;

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
  
  histogram = calculateHistogram(frame);
  boolean transition = detectTransitions(prev_histogram, histogram, threshold);
  if(transition){
    saveFrame("Frame-Transition-##.png");
    t1.println(movie.time());
  }
  
  if(frameTrigger) {
    frameTrigger = false;
    saveFrame("Frame-##.png");
    output.println(movie.time());
  }
  prev_histogram = histogram;
  
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
   // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(get(i, j)));
      histogram[bright]++; 
    }
  }
  return histogram;
}

int histogramDifferences(int[] prev_histogram, int [] actual_histogram){
  int difference = 0;
  for (int i = 0; i < prev_histogram.length; i++) {
    difference = difference + abs(prev_histogram[i]-actual_histogram[i]);
  }
  return difference;
}

boolean detectTransitions(int [] prev_histogram, int [] actual_histogram, int threshold){
  int difference = histogramDifferences(prev_histogram, histogram);
  print(difference+"|");
  if(difference > threshold){
     return true;
  }
  return false;
}


