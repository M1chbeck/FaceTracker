import gab.opencv.*;
import processing.video.*;
import java.awt.*;


class HeadTrackingCam {
  PApplet parent;
  Capture video;
  OpenCV opencv;
  Rectangle[] faces;
  int captureWidth = 320;
  int captureHeight = 240;

  //debug
  boolean showCam=true;
  boolean headTrackingEnabled=true;
  boolean headTrackingPossible=true;

  PVector pos = new PVector(captureWidth/2, captureHeight/2, 0); //xpos, ypos, ID
  PVector percentages = new PVector(0.5, 0.5, 0); //xpos, ypos, ID
  int currFace = -1;
  boolean smooth=false;
  boolean newFrame=false;

  HeadTrackingCam(PApplet p){
    parent = p;
  }
  void safePrepareHeadTracking(){
    try {
      prepareHeadTracking();
    }
    catch (Exception e) {
      println("No Camera Found - default to Mouse-X-Position");
      headTrackingPossible = false;
      headTrackingEnabled = false;
    }
  }
  
  void prepareHeadTracking(){
    
    //headtracking
    video = new Capture(parent, captureWidth, captureHeight);
    opencv = new OpenCV(parent, captureWidth, captureHeight);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = new Rectangle[0];  
    video.start();
  }
  
  PVector convertPixelPosToPercentage(Rectangle[] faces, int pos){
    return new PVector(float(faces[pos].x)/float((captureWidth-faces[pos].width)),
                       float(faces[pos].y)/float((captureHeight-faces[pos].height)));
  }
  
  void processHeadTracking() {
   // start video
    opencv.loadImage(video);
  
    // start face tracking
    faces = opencv.detect();
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
  }
  // Head Tracking
  void captureEvent(Capture c) {
    try{
      c.read();
    }
    catch (Exception e)
    {
      println("couldn't allocate pic in this frame.");
    }
  }
  void showVideo(int w,int h){
    if(!showCam) //for some reason this will glitch tracking if this function is not executed
    {
      w = width+50;
    }
    pushMatrix();
      ortho(0, width, 0, height); 
      translate(w,h);
      try{
      image(video,0,0);
      }
      catch (Exception e)
      {
        println("couldn't allocate pic from cam.");
      }
      //highlight Faces
      for (int i = 0; i < faces.length; i++) { 
        if( i != currFace)
          stroke(0, 255, 0);
        else 
          stroke(255, 0, 0);   
        rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      }
      //highlight smoothed percentage position
      if(smooth)
        stroke(0, 255, 255);
      else
        stroke(0, 0, 255);         
      ellipse(percentages.x*captureWidth, percentages.y*captureHeight, 3, 3);
    popMatrix();
  }
  void keyboardInput(int k)
  {
    if (key == 'd' || key == 'D')
    {
      showCam = !showCam;
    }
    else if (key == 'h' || key == 'H')
    {
      if( headTrackingPossible )
        headTrackingEnabled = !headTrackingEnabled;
    }
  }
}

