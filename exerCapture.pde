//commited to git

import codeanticode.gsvideo.*;
import gifAnimation.*;
import java.util.Date;

GSCapture video;
GifMaker gifExport;

boolean isCapturing = false;
GifMaker[] gifAnimes = new GifMaker[3];

int videoWidth = 640;
int videoHeight = 480;
int thumbnailScale = 10;

void setup(){
  size(videoWidth, videoHeight +videoHeight/thumbnailScale);
  video =new GSCapture(this, videoWidth, videoHeight);
  video.start();
}

void draw(){
  println("video.available : "+video.available());
  if (video.available()) {
    video.read();
    image(video, 0, 0, videoWidth, videoHeight);
  }
}

void mousePressed(){
  
}
