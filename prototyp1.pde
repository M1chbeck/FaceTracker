
PImage bgr,p1,p2,p3,p4,pbgr;
int time;
int currMode=0;
PShape zacken, s1,s2,s3,s4;
float multiplier=1.0f;

void setup(){
  //init
  size(1080, 1920, P3D);

  //bgr image
  bgr = loadImage("bgr_darkend_fullHD_wider_cleaner.jpg");
  image(bgr, 0, 0);
  //peeps
    tint(255, 255);
  p1 = loadImage("person1_fullhd_240offset.png");
  s1 = createShapeFromImg(p1);
  //image(p1, 0, 240);
  p2 = loadImage("person2_fullhd_240offset.png");
  //image(p2, 0, 240);
  p3 = loadImage("person3_fullhd_240offset.png");
  //image(p3, 0, 240);
  p4 = loadImage("person4_fullhd_240offset.png");
  //image(p4, 1080-p4.width, 240); //right aligned
  pbgr= loadImage("backgroundpeople_fullhd_240offset.png");
}

PShape createShapeFromImg(PImage inImg)
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
}

void draw(){
  float percent=float(mouseX)/float(width);
  percent*=multiplier;
  noStroke();
  noFill();
  background(0);
  image(bgr, -3-5*percent/multiplier, 0);
  image(pbgr, 5*multiplier-10*percent, 240);
  image(p3, 10*multiplier-20*percent, 240);  
  image(p1, 16*multiplier-32*percent, 240);
  image(p4, 1080-p4.width+14*multiplier-28*percent, 240);
  image(p2, 23*multiplier-46*percent, 240);
  
}
void keyPressed() {
  if (key == '+')
  {
    multiplier+=0.1;
  }
  else if (key == '-')
  {
    multiplier-=0.1;
  }
}

