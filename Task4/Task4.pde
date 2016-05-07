import processing.video.*;
Movie movie;
PrintWriter output, t1, tc;
boolean frameTrigger;
final int TIMER = 5050;
float duration;
PImage frame;
int[] histogram = new int[256];
int[] prev_histogram = new int[256];
int threshold = 250000;
int thresholdTC = 500000;
int cumulative = 0;

void setup() {
  movie = new Movie(this, "PCMLab10.mov");
  movie.play();
  duration = movie.duration();
  size(960,540);
  frameTrigger = false;
  thread("timer");
  output = createWriter("stroboscopic_segmentation.txt");
  t1 = createWriter("detected_transitions.txt");
  tc = createWriter("twin_comparison.txt");
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
  if(detectTransitions(prev_histogram, histogram)) {
    saveFrame("Frame-Transition-##.png");
    t1.println(movie.time());
    if (cumulative >= thresholdTC) {
      saveFrame("Frame-Twin-Comparison-##.png");
      tc.println(movie.time());
    }
    cumulative = 0;
  }
  
  if(frameTrigger) {
    frameTrigger = false;
    saveFrame("Frame-##.png");
    output.println(movie.time());
  }
  prev_histogram = histogram;
  output.flush();
  t1.flush();
  tc.flush();
  if(movie.time() >= duration) {
    output.close();
    t1.close();
    tc.close();
    exit();
  }
}

void timer() {
  while(movie.time() != duration) {
    frameTrigger = true;
    delay(TIMER);
  }
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
    difference += abs(prev_histogram[i]-actual_histogram[i]);
  }
  cumulative += difference;
  return difference;
}

boolean detectTransitions(int [] prev_histogram, int [] actual_histogram){
  int difference = histogramDifferences(prev_histogram, histogram);
  //print(difference+"|");
  return difference > threshold;
}


