import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
int captureWidth = 320;
int captureHeight = 240;

PVector pos = new PVector(captureWidth/2, captureHeight/2, 0); //xpos, ypos, ID
PVector percentages = new PVector(0.5, 0.5, 0); //xpos, ypos, ID
int currFace = -1;
boolean smooth=false;

void setup() {
  size(640, 480, P3D);
  video = new Capture(this, captureWidth, captureHeight);
  opencv = new OpenCV(this, captureWidth, captureHeight);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}
boolean sketchFullScreen() {
  return false;
}
void draw() {
  background(0);
  scale(2); // double size o.O
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  noStroke();
  stroke(0, 255, 0);
  strokeWeight(2);
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
PVector convertPixelPosToPercentage(Rectangle[] faces, int pos)
{
  return new PVector(float(faces[pos].x)/float((captureWidth-faces[pos].width)),
                     float(faces[pos].y)/float((captureHeight-faces[pos].height)));
}

/*** old scene *****
{   
  float xpos = faces[0].x/(float)(captureWidth-40.0)*width; // 40 offset
  float ypos = faces[0].y/(float)(captureHeight-40.0)*height; // 40 offset
  float zpos = (height/2) / tan(PI*30.0 / 180.0);
  float close = 200.0;
  float far = 500.0;
  zpos -= faces[0].width*2.0;
  camera(width-xpos, ypos, zpos, width/2.0, height/2.0, -400, 0, 1, 0); 
  //camera(width-xpos, ypos, zpos, width-xpos, ypos, -400, 0, 1, 0);
  println("width: " + faces[0].width+ " zpos: "+zpos);
  pushMatrix();
  translate(width/2, height/2, -100);
  scale(1,1,0.01);
  stroke(255);
  noFill();
  sphere(50);
  popMatrix();

  pushMatrix();
  translate(width/3, height/3, -200);
  sphere(50);
  popMatrix();

  pushMatrix();
  translate(2*width/3, 3*height/4, -350);
  sphere(50);
  popMatrix();

  pushMatrix();
  translate(width/2, height/2, -100);
  box(width, height, width*2);
  popMatrix();
}/**/
