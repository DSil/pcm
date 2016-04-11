PImage img;
Boolean grayscale;

void setup() {
  img = loadImage("PCMLab8.png");
  grayscale = false;
  size(img.width, img.height);
}

void draw() {
   image(img, 0,0);
   if(grayscale){
     rgb2gray(img);
   }
   drawHistogram(img);
}

void stop() {

}


  

void keyPressed() {
  if(key=='g'){
     grayscale = !grayscale; 
  }
}

void rgb2gray(PImage img){
  loadPixels();
  img.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = x + y*width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, 
      // before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      float luminance = 0.3 * r + 0.59 * g  + 0.11*b;
      pixels[loc] =  color(luminance, luminance, luminance);          
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
  
  stroke(255);
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int which = int(map(i, 0, img.width, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(histogram[which], 0, histMax, img.height, 0));
    line(i, img.height, i, y);
  }
  
}
