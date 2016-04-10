import ddf.minim.*;
import ddf.minim.effects.*;
import java.util.List.*;

Minim minim;
AudioPlayer song;
AudioMetaData metaInfo; 
CustomLowPass effect;
PFont font, altFont;
int bufferSize;
int currentColor;
int[] colors = {0xFFFF0000, 0xFF00FF00, 0xFF0000FF};
float initialGain;
Boolean showMetaInfo, muted, multiColor;

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
  size(800, 600);
  minim = new Minim(this);
  song = minim.loadFile("01 PCM Rock Sample.mp3");
  effect = new CustomLowPass(0.075);
  song.addEffect(effect);
  metaInfo = song.getMetaData();
  initialGain = song.getGain();
  font = createFont("Sans-Serif", 12);
  altFont = createFont("Sans-Serif", 50);
  textFont(font);
  showMetaInfo = true;
  muted = false;
  multiColor = false;
  bufferSize = song.bufferSize();
  rectMode(RADIUS);
  currentColor = 0;
}

void draw() {
  background(0);
  pushMatrix();
  translate(400, 300);
  if(!song.isPlaying()) {
   fill(255);
   textFont(altFont);
   text("SONG PAUSED. PRESS P TO PLAY",0,300,400,300);
   textFont(font);
  }
  fill(colors[currentColor]);
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
     if(i==50)
       if(multiColor)
        currentColor = (currentColor + 1) % colors.length;
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
    if (muted) {
      fadeIn(song, 5);
      muted = false;
    }
    else {
      fadeOut(song, 5);
      muted = true;
    }
  }
  else if(key == 'p') {
   if(song.isPlaying())
    song.pause();
   else
    song.play();   
  }
  else if(key == 'f') {
    if(song.isEffected()) //Only works with one effect
      song.disableEffect(effect);
    else
      song.enableEffect(effect);
  }
  else if(key == 'i')
    showMetaInfo = !showMetaInfo;
  else if(key == 'r')
    currentColor = 0;
  else if(key == 'g')
    currentColor = 1;
  else if(key == 'b')
    currentColor = 2;
  else if(key == 'c')
    multiColor = !multiColor;
}


void fadeIn(AudioPlayer song, int duration){
  float gain = song.getGain();
  song.shiftGain(gain, initialGain, duration*1000);
  
}

/*
Param:
  - song: AudioPlayer with song loaded;
  - beginTime: Time in seconds at the fadeOut starts;
  - durantion: duration in seconds of the fadeOut.
*/

void fadeOut(AudioPlayer song, int duration){
    float gain = song.getGain();
    song.shiftGain(gain, -100, duration*1000);
}
