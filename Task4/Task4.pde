import processing.video.*;
Movie movie;
PrintWriter output, t1, tc, txt;
boolean frameTrigger;
final int TIMER = 5050;
float duration, averageDiff = 0.0;
PImage frame;
int[] histogram = new int[256];
int[] prev_histogram = new int[256];
int threshold = 250000;
int thresholdTC = 50000;
float thresholdMean = 0.0;
int diff;
int nframe;
int cumulative = 0;
int option = 5; //0 = ver video; 1 = stroboscopic segmentation; 2 = parameterisable threshold; 3 = twin-comparison; 4 = parameterisable threshold with otsu

void setup() {
  movie = new Movie(this, "PCMLab10.mov");
  movie.play();
  duration = movie.duration();
  size(960,540);
  frameTrigger = false;
  thread("timer");
  if (option == 1) output = createWriter("stroboscopic_segmentation.txt");
  else {
    t1 = createWriter("detected_transitions.txt");
    tc = createWriter("twin_comparison.txt");
    txt = createWriter("transition_report.txt");
  }
  for (int i = 0; i < 256; i++) {
    prev_histogram[i] = 0;
  }
  nframe = 0;
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  image(movie, 0, 0);
  frame = get(0,0,width,height);
  nframe++;

  if(option !=0){
  
    histogram = calculateHistogram(frame);
    
    if(option == 4)
      threshold = int(otsu(histogram, width*height));
    
    diff = histogramDifferences(prev_histogram, histogram);

    
    if(option == 5) {
      averageDiff = ((averageDiff * (nframe - 1)) + diff) / nframe;
      thresholdMean = averageDiff * 10.0;

      if (nframe == 1 || diff >= thresholdMean) {
        saveFrame("Mean-Transition-" + nframe + ".png");
        txt.println(nframe + "\t" + diff + "\t" + thresholdMean + "\t" + thresholdMean);
      }
    }
    
    if(option != 1) {
      if(diff >= threshold) {
        saveFrame("Frame-Transition-" + nframe + ".png");
        t1.println(movie.time());
        txt.println(nframe + "\t" + diff + "\t" + threshold + "\t" + threshold);
      }
      else if(option != 4 && diff >= thresholdTC) {
          if (cumulative >= threshold || cumulative == 0) {
            saveFrame("Frame-Twin-Comparison-" + nframe + ".png");
            tc.println(movie.time());
            txt.println(nframe + "\t" + diff + "\t" + threshold + "\t" + thresholdTC);
          }
          cumulative = 0;
      }
     }
    else {
      if(frameTrigger) {
        frameTrigger = false;
        saveFrame("Frame-" + nframe + ".png");
        output.println(movie.time());
      }
    }   
  }    
  prev_histogram = histogram;
  switch(option) {
     case 1: output.flush(); break;
     case 5:
     case 4:
     case 2: t1.flush();
     case 3: tc.flush();
     default : txt.flush();
  }
    
  if(movie.time() >= duration) {
    switch(option){
       case 1: output.close(); break;
       case 5:
       case 4:
       case 2: t1.close();
       case 3: tc.close();
       default: txt.close();
    }
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

