HeadTrackingCam myCam;

//luther poster
PImage bgr,p1,p2,p3,p4,pbgr;
int time;
int currMode=0;
PShape zacken;
float multiplier=3.0f;

void setup(){
  //init
  size(1080, 1920, P3D);
  myCam = new HeadTrackingCam(this);
  myCam.safePrepareHeadTracking();
  prepareImages();
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

void draw(){
  float percent=float(mouseX)/float(width);
  percent*=multiplier;
  noStroke();
  noFill();
  background(0);
  if( myCam.headTrackingEnabled )
  {
    myCam.processHeadTracking();
    percent = (1.0-myCam.percentages.x);
    percent*=multiplier;
  }
  image(bgr, -3-5*percent/multiplier, 0);
  image(pbgr, 5*multiplier-10*percent, 240);
  image(p3, 10*multiplier-20*percent, 240);  
  image(p1, 16*multiplier-32*percent, 240);
  image(p4, 1080-p4.width+14*multiplier-28*percent, 240);
  image(p2, 23*multiplier-46*percent, 240);
  
  if( myCam.headTrackingEnabled)
  {
    // when myCam.showCam is true the video will be shown for Debug purposes    
    myCam.showVideo(0,0);   
  }
}

// Head Tracking
void captureEvent(Capture c) {
  //Propagate Capture Event
  myCam.captureEvent(c);
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
  else 
  {
    myCam.keyboardInput(key);
  }
}

