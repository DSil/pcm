import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
CustomLowPass effect;

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
  size(512, 200);
  minim = new Minim(this);
  song = minim.loadFile("01 PCM Rock Sample.mp3");
  effect = new CustomLowPass(0.075);
  song.addEffect(effect);
  song.play();
}

void draw() {
  background(0);
  stroke(100, 200, 255);
  for (int i = 0; i < song.bufferSize() - 1; i++) {
    line(i, 50 + song.left.get(i) * 100, i+1, 50 + song.left.get(i+1) * 100);
    line(i, 150 + song.right.get(i) * 100, i+1, 150 + song.right.get(i+1) * 100);
  }
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
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
}
