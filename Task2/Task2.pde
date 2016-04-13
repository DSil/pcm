PImage img;
Boolean grayscale, threshold, negative;

void setup() {
  img = loadImage("PCMLab8.png");
  grayscale = false;
  threshold = false;
  negative = false;
  size(img.width*2, img.height);
}

void draw() {
  clear();
  background(0xFFCDCDCD);
   image(img, 0,0);
   if(grayscale) rgb2gray(img);
   if(threshold) thresholding(img, 250);
   drawHistogram(img);   
}

void stop() {

}


  

void keyPressed() {
  if(key=='g')
     grayscale = !grayscale;
  else if(key == 't')
    threshold = !threshold;
  else if(key == 'n')
    negative = !negative;
}

void negation(PImage img) {
  loadPixels();
  img.loadPixels();
  float luminance,r,g,b;
  int loc;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      loc = x + y*img.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);

      pixels[loc-y*img.width+y*width] =  color(255-r, 255-g, 255-b);          
    }
  }
  updatePixels();
}

void thresholding(PImage img, int l) {
  loadPixels();
  img.loadPixels();
  float luminance,r,g,b;
  int loc;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      loc = x + y*img.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      luminance = 0.3 * r + 0.59 * g  + 0.11*b;
      if (luminance > l)
        pixels[loc-y*img.width+y*width] = color(255);
      else
        pixels[loc-y*img.width+y*width] = color(0);
    }
  }
  updatePixels();
  
}

void rgb2gray(PImage img){
  loadPixels();
  img.loadPixels();
  float luminance,r,g,b;
  int loc;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      loc = x + y*img.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      luminance = 0.3 * r + 0.59 * g  + 0.11*b;
      pixels[loc-y*img.width+y*width] =  color(luminance, luminance, luminance);          
    }
  }
  updatePixels();
}


void drawHistogram(PImage img){
  int[] histogram = new int[256];
   // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(get(i, j)));
      histogram[bright]++; 
    }
  }
  
  // Find the largest value in the histogram
  int histMax = max(histogram);
  
  stroke(0xFF000000);
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, img.width, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(histogram[which], 0, histMax, img.height, 0));
    line(i+img.width, img.height, i+img.width, y);
  }
  
}
