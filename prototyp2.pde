
PImage bgr,p1,p2,p3,p4;
int time;
int currMode=0;
PShape zacken;
boolean showText=false;
int yPosTextbox=1920-250;

void setup(){
  //init
  size(1080, 1920, P3D);

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
  
  zacken= createShape();
  zacken.beginShape();
  zacken.fill(255, 196);
  zacken.noStroke();
  zacken.vertex(0, 0);
  zacken.vertex(100, 0);
  zacken.vertex(50, -50);
  zacken.endShape();
}

void draw(){
  highlightImages(mouseX);
}

int determineMode(int xpos)
{
   if(xpos < 260)
   {    
     return 1;   
   }
   else if(xpos > 260 && xpos < 600)
   {    
     return 2;    
   }
   else if(xpos > 600 && xpos < 850)
   {    
     return 3;    
   }
   else  if(xpos > 850)
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
