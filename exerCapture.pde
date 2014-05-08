import codeanticode.gsvideo.*;
import gifAnimation.*;
import java.util.Date;

import java.applet.*;
import java.awt.*;
import java.awt.event.*;

GSCapture video;
GifMaker gifExport;

boolean isCapturing = false;
GifMaker[] gifAnimes = new GifMaker[10];

int videoWidth = 640;
int videoHeight = 480;
int thumbnailScale = 10;

void setup(){
  size(640, 528);
  video =new GSCapture(this, videoWidth, videoHeight+videoHeight/thumbnailScale);
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
