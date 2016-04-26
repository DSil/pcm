import processing.video.*;
Movie movie;

void setup() {
  movie = new Movie(this, "PCMLab9.mov");
  movie.play();
  size(movie.width, movie.height);
}

void draw() {
  image(movie, 0, 0);
}

void movieEvent(Movie m) {
  m.read();
}


