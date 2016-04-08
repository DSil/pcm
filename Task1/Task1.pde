import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
AudioMetaData metaInfo; 
CustomLowPass effect;
int bufferSize;
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
  textFont(createFont("Sans-Serif", 12));
  showMetaInfo = true;
  song.play();
  bufferSize = song.bufferSize();
}

void draw() {
  background(0);
  stroke(100, 200, 255);
  for (int i = 0; i < bufferSize - 1; i++) {
    line(i, 50 + song.left.get(i) * 100, i+1, 50 + song.left.get(i+1) * 100);
    line(i, 150 + song.right.get(i) * 100, i+1, 150 + song.right.get(i+1) * 100);
  }
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
  int yi = 15;
  int y = 25;
  text("File Name: " + metaInfo.fileName(), 5, y);
  text("Length (in seconds): " + metaInfo.length()/1000, 5, y+=yi);
  text("Title: " + metaInfo.title(), 5, y+=yi);
  text("Author: " + metaInfo.author(), 5, y+=yi); 
  text("Album: " + metaInfo.album(), 5, y+=yi);
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
  if(key == 'i') {
    showMetaInfo = !showMetaInfo;
  }
}
