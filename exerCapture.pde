//for using web camera
import codeanticode.gsvideo.*;
//for exporting gif animation
import gifAnimation.*;
//for using class 'Date'
import java.util.Date;
//instance
GSCapture video;
GifMaker gifExport;

int frameLen = 5; //a gif animation consists of 5 frames
int galleryLen = 3; //gallery consists of 3 gif animations

boolean isCapturing = false; //true >> capture by your interval
boolean isExportMode = false; //true >> to export gif

PImage[] images = new PImage[frameLen]; //save past 5 jpg images
int imagesHead = 0;

Gif[] gifs = new Gif[galleryLen];
PImage[][] gifFrames = new PImage[galleryLen][frameLen];
int gifsHead = 0;

//save past 3 gif images

int videoWidth = 640;
int videoHeight = 480;
int thumbnailScale = frameLen; //for views
int galleryScale = galleryLen;

int jumpInterval = 800; //unit is milli-second
int nowMillis;
int lastMillis;
int diffMillis;

boolean intervalDetect;

int captureCount;

PImage img;
void setup() {
  size(videoWidth+videoWidth/galleryScale, videoHeight +videoHeight/thumbnailScale);
  noStroke();
  background(150);
  video = new GSCapture(this, videoWidth, videoHeight);
  video.start();

  img = loadImage("neko.png");
}


float bx, by, vy;
void draw() {
  nowMillis = millis();
  diffMillis = nowMillis - lastMillis;
  intervalDetect = (diffMillis >= jumpInterval);

  if (video.available()) {
    video.read();
    image(video, 0, 0, videoWidth, videoHeight);
    img = video.get();
  }
  //capture the scene
  if (isCapturing) {
    if (intervalDetect) {
      saveImage(img);
      captureCount++;
      //thumbnail under the video
      showImages();
      if (captureCount >= frameLen) {
        isCapturing = false;
        captureCount = 0;
      }
    }
  }
  //export gif animation
  else if (isExportMode) {
    String GifName = "GifAni"+String.format("%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS%1$tL", new Date())+".gif";
    gifExport = new GifMaker(this, GifName);
    gifExport.setRepeat(0);
    for (int i = 0; i < frameLen; i++) {
      gifExport.addFrame(images[i]);
      gifFrames[gifsHead][i] = images[i];
    } 
    gifExport.finish();
    gifsHead++;
    if (gifsHead > galleryLen -1)gifsHead = 0;
    isExportMode = false;
  }
  //to display galleries on the left-side
  showGifs();

  //blink texture
  fill(0, 56*sin(map(diffMillis, 0, 816, 0, 2*PI))+56);
  /***********************************/
  
  rect(0, 0, videoWidth, videoHeight);
  
  /***********************************/
  //ball indicate shutter timing
  bx = videoWidth+videoWidth/galleryScale/2;
  by = videoHeight/thumbnailScale/2*sin(map(diffMillis, 0, 816, 0, 2*PI))+height;
  fill(0);
  /***********************************/
  
  ellipse(bx, by, 10, 10);
  
  /***********************************/

  //detect interval
  if (intervalDetect) {
    lastMillis = nowMillis;
  }
}


void keyPressed() {
  switch(key) {
  case ' ':
    isCapturing = true;
    break;
  case 'c':

    break;
  case 'e':
    if (!isCapturing) {
      isExportMode = true;
      isCapturing = false;
    }
    break;
  case RIGHT:

    jumpInterval+=10;
    //println("interval : "+jumpInterval);
    fill(0);
    text("interval : "+jumpInterval, width-50, height-50);
    break;
  case LEFT:
    jumpInterval-=10;
    fill(0);
    text("interval : "+jumpInterval, width-50, height-50);
    //println("interval : "+jumpInterval);
    break;
  default:
    break;
  }
}

void saveImage(PImage img) {
  String filename = String.format("%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS%1$tL", new Date()) + ".jpg";

  img.save(filename);
  images[imagesHead] = img;
  imagesHead++;
  if (imagesHead >= images.length) {
    imagesHead = 0;
  }
}

void showImages() {
  int thumbWidth = videoWidth / thumbnailScale;
  int thumbHeight = videoHeight / thumbnailScale;
  for (int i=0; i<images.length; i++) {
    int idx = (imagesHead + i) % images.length;
    int x = i * videoWidth / images.length;
    if (images[idx] != null) {
      image(images[idx], x, videoHeight, thumbWidth, thumbHeight );
    }
  }
}

//your must use this method 'showGifs()' only once or never
//3 galleries on the left-side 
float cnt = 0;
void showGifs() {
  //println("cnt : "+cnt);
  int galleryWidth = videoWidth / galleryScale;
  int galleryHeight = videoHeight / galleryScale;

  fill(150);
  rect(videoWidth, 0, galleryWidth, height);

  for (int i = 0; i < galleryLen; i++) {
    int y = (i)*galleryHeight; 
    if (gifFrames[i][int(cnt)] != null) {
      image(gifFrames[i][int(cnt)], videoWidth, y, galleryWidth, galleryHeight );
    }
  }
  cnt += 1.f/6.f;
  if (cnt > frameLen -1)cnt = 0;
}

