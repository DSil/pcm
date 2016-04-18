PImage img;
Boolean grayscale, threshold, negative, colorized, sepia, contrast;

// Define the contrast lvl here
//int contrastParam;

void setup() {
  img = loadImage("PCMLab8.png");
  grayscale = false;
  threshold = false;
  negative = false;
  colorized = false;
  sepia = false;
  contrast = false;
  size(img.width*2, img.height);
}

void draw() {
  clear();
  background(0xFFCDCDCD);
   image(img, 0,0);
   if(grayscale) rgb2gray(img);
   if(threshold) thresholding(img, 150);
   if(negative) negation(img);
   if(colorized) superColor(img);
   if(sepia) sepiate(img);
   if(contrast) increaseContrast(img, contrast_value);
   drawHistogram(img);   
}

void keyPressed() {
  if(key=='g')
     grayscale = !grayscale;
  else if(key == 't')
    threshold = !threshold;
  else if(key == 'n')
    negative = !negative;
  else if(key == 'c')
    colorized = !colorized;
  else if(key == 's')
    sepia = !sepia;
  else if(key == 'r')
    contrast = !contrast;
  else if(key == CODED) {
    if(keyCode == UP) {
      contrast_value = (contrast_value == 255) ? contrast_value + 1 : contrast_value;
    }
    else if(keyCode == DOWN) {
      //Decrease contrast
    }
  }
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

void superColor(PImage img) {
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
      
      if (r > g && r > b)
        pixels[loc-y*img.width+y*width] =  color(255, 0, 0);
      else if (g > r && g > b)
        pixels[loc-y*img.width+y*width] =  color(0, 255, 0);
      else
        pixels[loc-y*img.width+y*width] =  color(0, 0, 255);          
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
      
      // Apply threshold
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

void sepiate(PImage img){
  loadPixels();
  img.loadPixels();
  float luminance,r,g,b,nr,ng,nb;
  int loc;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      loc = x + y*img.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
      
      // Set the display pixel to the image pixel
      
      nr = r * 0.393 + g * 0.769 + b * 0.189;
      ng = r * 0.349 + g * 0.686 + b * 0.168;
      nb = r * 0.272 + g * 0.534 + b * 0.131;
      pixels[loc-y*img.width+y*width] =  color(nr, ng, nb);          
    }
  }
  updatePixels();
}

void increaseContrast(PImage img, int param){
  loadPixels();
  img.loadPixels();
  float r,g,b, newRed, newGreen, newBlue;
  int loc;
  float factor = (259 * (param +255)) / (255 * (259 - param));
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      loc = x + y*img.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      r = red(img.pixels[loc]);
      g = green(img.pixels[loc]);
      b = blue(img.pixels[loc]);
  
 
      newRed = round(factor * (r -128)+128);
      newGreen = round(factor * (g -128)+128);
      newBlue = round(factor * (b -128)+128);

      pixels[loc-y*img.width+y*width] =  color(newRed, newGreen, newBlue);          
    }
  }
  updatePixels();
}

void drawHistogram(PImage img){
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
