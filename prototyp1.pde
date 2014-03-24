import gab.opencv.*;
import processing.video.*;
import java.awt.*;

//headtracking
Capture video;
OpenCV opencv;
int captureWidth = 320;
int captureHeight = 240;
PVector pos = new PVector(captureWidth/2, captureHeight/2, 0); //xpos, ypos, ID
PVector percentages = new PVector(0.5, 0.5, 0); //xpos, ypos, ID
int currFace = -1;
boolean smooth=false;

//luther poster
PImage bgr,p1,p2,p3,p4,pbgr;
int time;
int currMode=0;
PShape zacken;
float multiplier=3.0f;

//debug
boolean showCam=false;
boolean headTrackingEnabled=true;
void setup(){
  //init
  size(1080, 1920, P3D);
  
  prepareHeadTracking();
  prepareImages();
}
void prepareHeadTracking()
{
  //headtracking
  video = new Capture(this, captureWidth, captureHeight);
  opencv = new OpenCV(this, captureWidth, captureHeight);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}
void prepareImages(){
  //bgr image
  bgr = loadImage("bgr_darkend_fullHD_wider_cleaner.jpg");
  image(bgr, 0, 0);
  //peeps
  tint(255, 255);
  p1 = loadImage("person1_fullhd_240offset.png");
  //image(p1, 0, 240);
  p2 = loadImage("person2_fullhd_240offset.png");
  //image(p2, 0, 240);
  p3 = loadImage("person3_fullhd_240offset.png");
  //image(p3, 0, 240);
  p4 = loadImage("person4_fullhd_240offset.png");
  //image(p4, 1080-p4.width, 240); //right aligned
  pbgr= loadImage("backgroundpeople_fullhd_240offset.png");
}

/*PShape createShapeFromImg(PImage inImg)
{
  PShape tmp = createShape();
  tmp.beginShape();
  tmp.texture(inImg);
  tmp.noStroke();
  tmp.vertex(0, 0, 0, 0, 0);
  tmp.vertex(inImg.width, 0, 0, inImg.width, 0);
  tmp.vertex(inImg.width,  inImg.height, 0, inImg.width, inImg.height);
  tmp.vertex(0,  inImg.height, 0, 0, inImg.height);
  tmp.endShape();
  return tmp;
}*/

void draw(){
  float percent=float(mouseX)/float(width);
  percent*=multiplier;
  noStroke();
  noFill();
  background(0);
  if( headTrackingEnabled )
  {
    opencv.loadImage(video);
    processHeadTracking();    
    percent = (1.0-percentages.x);
    percent*=multiplier;
  }
  image(bgr, -3-5*percent/multiplier, 0);
  image(pbgr, 5*multiplier-10*percent, 240);
  image(p3, 10*multiplier-20*percent, 240);  
  image(p1, 16*multiplier-32*percent, 240);
  image(p4, 1080-p4.width+14*multiplier-28*percent, 240);
  image(p2, 23*multiplier-46*percent, 240);
  
  if(showCam)
    image(video, 0, 0 );
  
}
void processHeadTracking() {
   // start video
  opencv.loadImage(video);

  // start face tracking
  Rectangle[] faces = opencv.detect();
  if ( faces.length > 0)
  {  
    int tmpCurr=0;
    float dist= PVector.dist(pos, new PVector(faces[0].x,faces[0].y,0.0));
    //find closest face to previous position
    for (int i = 1; i < faces.length; i++) {   
      float tmpDist = PVector.dist(pos, new PVector(faces[i].x,faces[i].y,0.0)); 
      if( tmpDist < dist)
      {
        tmpCurr=i;
        dist = tmpDist;
      }
    }
    currFace = tmpCurr;//face closest to the old position!
    // positioning 
    pos.x = faces[currFace].x;
    pos.y = faces[currFace].y;
  }

  if(faces.length < 1) // no face found
  {
    currFace = -1;
    //move slowly back to middle
    if(percentages.x < 0.49 || percentages.x > 0.51)
      percentages.x+=(0.5 - percentages.x)*0.02;
    if(percentages.y < 0.49 || percentages.y > 0.51)
      percentages.y+=(0.5 - percentages.y)*0.02;
     smooth=true;
  }
  else
  {    
    PVector newPerc = convertPixelPosToPercentage(faces,currFace);
    float difference = PVector.dist(newPerc,percentages); 
    if( difference > 0.025) // large jump between percentages, smooth
    {
      //percentages.x = percentages.xNewPerc.x
      percentages.x+=(newPerc.x - percentages.x)*difference;
      percentages.y+=(newPerc.y - percentages.y)*difference;
      // smooth
      smooth=true;
    }
    else
    {
      percentages = newPerc;
      smooth=false;
    }
  }
  
  if(showCam)
  {
    //highlight Faces
    for (int i = 0; i < faces.length; i++) { 
      if( i != currFace)
        stroke(0, 255, 0);
      else 
        stroke(255, 0, 0);   
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
     if(smooth)
       stroke(0, 255, 255);
     else
       stroke(0, 0, 255);         
     ellipse(percentages.x*width/2, percentages.y*height/2, 3, 3);
  }
}
// Head Tracking
void captureEvent(Capture c) {
  c.read();
}
PVector convertPixelPosToPercentage(Rectangle[] faces, int pos)
{
  return new PVector(float(faces[pos].x)/float((captureWidth-faces[pos].width)),
                     float(faces[pos].y)/float((captureHeight-faces[pos].height)));
}
// Key-Input
void keyPressed() {
  if (key == '+')
  {
    multiplier+=0.1;
  }
  else if (key == '-')
  {
    multiplier-=0.1;
  }
  else if (key == 'd' || key == 'D')
  {
    showCam = !showCam;
  }
  else if (key == 'h' || key == 'H')
  {
    headTrackingEnabled = !headTrackingEnabled;
  }
}

