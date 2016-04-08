import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
AudioMetaData metaInfo; 
CustomLowPass effect;
PFont font;
int bufferSize;
int currentColor;
Boolean showMetaInfo;

class CustomLowPass implements AudioEffect {
  private float freq;
  
  CustomLowPass(float freq) {
    this.freq = freq;
  }
  
  void process(float[] signal) {
    for(int i = 1; i < 1024; i++)
      signal[i] = signal[i-1] + freq * (signal[i] - signal[i-1]);
  }
  
  void process(float[] sigLeft, float[] sigRight) {
    process(sigLeft);
    process(sigRight);
  }
}

void setup() {
  size(800, 600, P3D);
  minim = new Minim(this);
  song = minim.loadFile("01 PCM Rock Sample.mp3");
  effect = new CustomLowPass(0.075);
  song.addEffect(effect);
  metaInfo = song.getMetaData();
  font = createFont("Sans-Serif", 12);
  textFont(font);
  showMetaInfo = true;
  bufferSize = song.bufferSize();
  rectMode(RADIUS);
  currentColor = 0xFFFF0000;
}

void draw() {
  background(0);
  pushMatrix();
  translate(400, 300);
  if(!song.isPlaying()) {
   fill(255);
   textFont(createFont("Sans-Serif", 50));
   text("SONG PAUSED. PRESS P TO PLAY",0,300,400,300);
   textFont(font);
  }
  fill(currentColor);
  for (int i = 0; i < bufferSize - 50; i+=50) {
      for(int j = 0; j < 50; j+=2) {
        pushMatrix();
          translate(-10 * j, 0);
          rect(0, 0, 5, song.left.get(i+j)*100,2);
        popMatrix();
        pushMatrix();
          translate(10 * j, 0);
          rect(0, 0, 5, song.right.get(i+j)*100,2);
        popMatrix();
     }
  }
  popMatrix();
  if (showMetaInfo) {
     displayMetaInfo();
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}

void displayMetaInfo() {
  pushMatrix();
  fill(255,255,255);
  int yi = 15;
  int y = 25;
  text("File Name: " + metaInfo.fileName(), 5, y);
  text("Length (in seconds): " + metaInfo.length()/1000, 5, y+=yi);
  text("Title: " + metaInfo.title(), 5, y+=yi);
  text("Author: " + metaInfo.author(), 5, y+=yi); 
  text("Album: " + metaInfo.album(), 5, y+=yi);
  popMatrix();
}
  

void keyPressed() {
  if(key == 'm') {
    if (song.isMuted()) {
      song.unmute();
    }
    else {
      song.mute();
    }
  }
  if(key == 'p') {
   if(song.isPlaying())
    song.pause();
   else
    song.play();   
  }
  else if(key == 'i')
    showMetaInfo = !showMetaInfo;
  else if(key == 'r')
    currentColor = 0xFFFF0000;
  else if(key == 'g')
    currentColor = 0xFF00FF00;
  else if(key == 'b')
    currentColor = 0xFF0000FF;
}
