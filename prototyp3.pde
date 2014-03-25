float factor=0.15;
HeadTrackingCam myCam;
void setup(){
  //init
  size(1080, 1920, P3D);
  background(0);
  lights();
  myCam = new HeadTrackingCam(this);
  myCam.safePrepareHeadTracking();
}

void draw()
{ 
  background(0);
  camera(width/2, 400, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  translate(width/2, height/2, 0);
  stroke(255);
  noFill();
  int invertMouseX = width-mouseX;
  if( myCam.headTrackingEnabled )
  {
    myCam.processHeadTracking();
    // when myCam.showCam is true the video will be shown for Debug purposes
    myCam.showVideo(-width/2+50,-height/2);   
    invertMouseX = int((myCam.percentages.x)*float(width));
  }
  pushMatrix();
    stroke(255);
    rotateY((-PI/2+PI*(float(invertMouseX)/width))*factor);
    translate(-50,0,-120);
    wartburg();
  popMatrix();

}

void keyPressed() {
  if (key == '+')
  {
    factor+=0.05;
  }
  else if (key == '-')
  {
    factor-=0.05;
  }
  else 
  {
    myCam.keyboardInput(key);
  }
}

void wartburg()
{
  pushMatrix();
    translate(0,-100,0);
    box(400,200,100);
  popMatrix();
  pushMatrix();
    translate(230,-10,180);
    cylinder(40,20,10);
  popMatrix();
  pushMatrix();
    rotateY(-0.2);
    translate(350,-87,250);
    box(80,175,80);
    translate(0,-112,0);
    rotateX(PI/2.0);
    beginShape();
    vertex(-50, -50, -25);
    vertex( 50, -50, -25);
    vertex(   0,    0,  25);
    
    vertex( 50, -50, -25);
    vertex( 50,  50, -25);
    vertex(   0,    0,  25);
    
    vertex( 50, 50, -25);
    vertex(-50, 50, -25);
    vertex(   0,   0,  25);
    
    vertex(-50,  50, -25);
    vertex(-50, -50, -25);
    vertex(   0,    0,  25);
    endShape();
  popMatrix();
  pushMatrix();
    translate(0,-65,350);
    box(120,130,120);
  popMatrix();
  pushMatrix();
    rotateY(0.1);
    translate(-270,-140,0);
    box(75,280,75);
       translate(0,-165,0);
    rotateX(PI/2.0);
    beginShape();
    vertex(-50, -50, -25);
    vertex( 50, -50, -25);
    vertex(   0,    0,  25);
    
    vertex( 50, -50, -25);
    vertex( 50,  50, -25);
    vertex(   0,    0,  25);
    
    vertex( 50, 50, -25);
    vertex(-50, 50, -25);
    vertex(   0,   0,  25);
    
    vertex(-50,  50, -25);
    vertex(-50, -50, -25);
    vertex(   0,    0,  25);
    endShape();
  popMatrix();
  pushMatrix();
    translate(-220,-50,250);
    rotateY(PI/2+0.3);
    box(200,100,75);
  popMatrix();
  stroke(100);
  fill(128);
  pushMatrix();
   scale(1,0.4,1);
   translate(50,32,120);
   cylinder(400,60,15);
  popMatrix();
}

void captureEvent(Capture c) {
  //Propagate Capture Event
  myCam.captureEvent(c);
}
  
void cylinder(float w, float h, int sides)
{
  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];
 
  //get the x and z position on a circle for all the sides
  for(int i=0; i < x.length; i++){
    angle = TWO_PI / (sides) * i;
    x[i] = sin(angle) * w;
    z[i] = cos(angle) * w;
  }
 
  //draw the top of the cylinder
  beginShape(TRIANGLE_FAN);
 
  vertex(0,   -h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
  }
 
  endShape();
 
  //draw the center of the cylinder
  beginShape(QUAD_STRIP); 
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], -h/2, z[i]);
    vertex(x[i], h/2, z[i]);
  }
 
  endShape();
 
  //draw the bottom of the cylinder
  beginShape(TRIANGLE_FAN); 
 
  vertex(0,   h/2,    0);
 
  for(int i=0; i < x.length; i++){
    vertex(x[i], h/2, z[i]);
  }
 
  endShape();
}
