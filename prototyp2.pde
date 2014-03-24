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
PImage bgr,p1,p2,p3,p4;
int time;
int currMode=0;
PShape zacken;
boolean showText=false;
int yPosTextbox=1920-250;

//debug
boolean showCam=false;
boolean headTrackingEnabled=true;
boolean headTrackingPossible=true;

void setup(){
  //init
  size(1080, 1920, P3D);
  try {
    prepareHeadTracking();
  }
  catch (Exception e) {
    println("No Camera Found - default to Mouse-X-Position");
    headTrackingPossible = false;
    headTrackingEnabled = false;
  }
  
  prepareImages();
  prepareShape();
}
void prepareShape(){
  zacken= createShape();
  zacken.beginShape();
  zacken.fill(255, 196);
  zacken.noStroke();
  zacken.vertex(0, 0);
  zacken.vertex(100, 0);
  zacken.vertex(50, -50);
  zacken.endShape();
}
void prepareImages(){
    //bgr image
  bgr = loadImage("bgr_fullhd.jpg");
  tint(255, 128); 
  image(bgr, 0, 0);
  //peeps
  tint(255, 255);
  p1 = loadImage("person1_fullhd_240offset.png");
  image(p1, 0, 240);
  p2 = loadImage("person2_fullhd_240offset.png");
  image(p2, 0, 240);
  p3 = loadImage("person3_fullhd_240offset.png");
  image(p3, 0, 240);
  p4 = loadImage("person4_fullhd_240offset.png");
  image(p4, 1080-p4.width, 240); //right aligned
}
void prepareHeadTracking()
{
  //headtracking
  video = new Capture(this, captureWidth, captureHeight);
  opencv = new OpenCV(this, captureWidth, captureHeight);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw(){
  float pos = mouseX;
  if( headTrackingEnabled )
  {
    opencv.loadImage(video);
    processHeadTracking();
    pos= (1.0-percentages.x) * width;
  }
  highlightImages(int(pos));
   if(showCam && headTrackingPossible)
    image(video, 0, 0 );
}

int determineMode(int xpos)
{
   if(xpos < 320)
   {    
     return 1;   
   }
   else if(xpos > 320 && xpos < 600)
   {    
     return 2;    
   }
   else if(xpos > 600 && xpos < 800)
   {    
     return 3;    
   }
   else  if(xpos > 800)
   {    
     return 4;    
   }
   return 0;  
}
void highlightImages(int xpos)
{
  int newMode = determineMode(xpos);
  if(millis() - time >= 5000)
  {
     tint(255, 255);//show 100%
     image(bgr, 0, 0); 
  }
  if( newMode != currMode) // change!
  {  
    time=millis();
    currMode=newMode;
    background(255);
    if(currMode==1)
    {    
      tint(255, 128); //show half transparent
      image(bgr, 0, 0);
      tint(255, 255);//show 100%
      image(p1, 0, 240);    
    }
    else if(currMode==2)
    {    
      tint(255, 128); //show half transparent
      image(bgr, 0, 0);
      tint(255, 255);//show 100%
      image(p2, 0, 240);    
    }
    else if(currMode==3)
    {    
      tint(255, 128); //show half transparent
      image(bgr, 0, 0);
      tint(255, 255);//show 100%
      image(p3, 0, 240);    
    }
    else if(currMode==4)
    {    
      tint(255, 128); //show half transparent
      image(bgr, 0, 0);
      tint(255, 255);//show 100%
      image(p4, 1085-p4.width, 240);    
    }
    drawTextbox();
  }
}
void keyPressed() {
  if (key == 'T' || key == 't') {
    showText=!showText;
  }
  else if (key == 'd' || key == 'D')
  {
    showCam = !showCam;
  }
  else if (key == 'h' || key == 'H')
  {
    if( headTrackingPossible )
      headTrackingEnabled = !headTrackingEnabled;
  }
}
void drawTextbox()
{
  fill(255, 196);
  noStroke();
  rect(0, yPosTextbox, width, 250);
  int xpos = 40;
  if( currMode==2)
    xpos = 450;
  else if( currMode==3)
    xpos = 700;
  else if( currMode==4)
    xpos = 900;      
  shape(zacken, xpos, yPosTextbox);
  
  if( showText )
  {
    fill(0,255);  
    textSize(80);
    text("Lorem ipsum", 50, yPosTextbox+75);
    textSize(32);
    String s = "dolor sit amet, consectetur adipiscing elit. Pellentesque porttitor tortor urna. Maecenas vitae ligula sed lectus ultricies ullamcorper ut sed nisi. Pellentesque eget nisl consectetur.";
    text(s, 55, yPosTextbox+105, width-100, 200);
  }
}

// Head Tracking
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

void captureEvent(Capture c) {
  c.read();
}
PVector convertPixelPosToPercentage(Rectangle[] faces, int pos)
{
  return new PVector(float(faces[pos].x)/float((captureWidth-faces[pos].width)),
                     float(faces[pos].y)/float((captureHeight-faces[pos].height)));
}
