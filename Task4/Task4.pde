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
int option = 4; //0 = ver video; 1 = stroboscopic segmentation; 2 = parameterisable threshold; 3 = twin-comparison; 4 = parameterisable threshold with otsu

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

  if(option !=0){
  
    histogram = calculateHistogram(frame);
    if(option == 4){
      threshold = int( otsu(histogram, width*height));
    }
    if(option !=1){
      if(detectTransitions(prev_histogram, histogram)) {
        saveFrame("Frame-Transition-##.png");
        t1.println(movie.time());
        if(option==3){
          if (cumulative >= thresholdTC) {
            saveFrame("Frame-Twin-Comparison-##.png");
            tc.println(movie.time());
          }
          cumulative = 0;
        }
      }
    }
    
    if(option == 1){
      if(frameTrigger) {
        frameTrigger = false;
        saveFrame("Frame-##.png");
        output.println(movie.time());
      }
    }
    
    prev_histogram = histogram;
    switch(option){
       case 0: break;
       case 1:  output.flush();
       case 2: t1.flush();
       case 3: tc.flush();
       case 4: break;
    }
    
    
    
    if(movie.time() >= duration) {
      switch(option){
         case 0: break;
         case 1:  output.flush();
         case 2: t1.flush();
         case 3: tc.flush();
         case 4: break;
      }
      exit();
    }
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
  return difference > threshold;
}



float otsu(int [] histogram,int total) {
    int sum = 0;
    for (int i = 1; i < 256; ++i)
        sum += i * histogram[i];
    int sumB = 0;
    int wB = 0;
    int wF = 0;
    int mB;
    int mF;
    float max = 0.0;
    float between = 0.0;
    float threshold1 = 0.0;
    float threshold2 = 0.0;
    for (int i = 0; i < 256; ++i) {
        wB += histogram[i];
        if (wB == 0)
            continue;
        wF = total - wB;
        if (wF == 0)
            break;
        sumB += i * histogram[i];
        mB = sumB / wB;
        mF = (sum - sumB) / wF;
        between = wB * wF * (mB - mF) * (mB - mF);
        if ( between >= max ) {
            threshold1 = i;
            if ( between > max ) {
                threshold2 = i;
            }
            max = between;            
        }
    }
    return (( threshold1 + threshold2 ) / 2.0)*10000;
}

