import java.awt.Robot; 
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.Dimension;
import processing.serial.*; 


Serial port; 
Robot robby; 

void setup()
{
  println(Serial.list());
port = new Serial(this, Serial.list()[0],9600); //set baud rate
size(100, 100); //window size (doesn't matter)
try //standard Robot class error check
{
robby = new Robot();
}
catch (AWTException e)
{
println("Robot class not supported by your system!");
exit();
}
}

void draw()
{
int pixel; //ARGB variable with 32 int bytes where
//sets of 8 bytes are: Alpha, Red, Green, Blue
float r=0;
float g=0;
float b=0;


//get screenshot into object "screenshot" of class BufferedImage
BufferedImage screenshot = robby.createScreenCapture(new Rectangle(new Dimension(1920,1080)));



int i=0;
int j=0;
//I skip every alternate pixel making my program 4 times faster
 for(i =0;i<1920; i=i+2){
    for(j=0; j<1080;j=j+2){
      pixel = screenshot.getRGB(i,j); 
      r = r+(int)(255&(pixel>>16)); //add up reds
      g = g+(int)(255&(pixel>>8)); //add up greens
      b = b+(int)(255&(pixel)); //add up blues
}
}
r=r/(960*540); //average red 
  g=g/(960*540); //average green
  b=b/(960*540); //average blue

//println(r+","+g+","+b);

// filter values to increase saturation
float maxColorInt;
float minColorInt;

maxColorInt = max(r,g,b);
if(maxColorInt == r){
  // red
  if(maxColorInt < (225-20)){
    r = maxColorInt + 20;  
  }
}
else if (maxColorInt == g){
  //green
  if(maxColorInt < (225-20)){
    g = maxColorInt + 20;  
  }
}
else {
   //blue
   if(maxColorInt < (225-20)){
    b = maxColorInt + 20;  
  }  
}

//minimise smallest
minColorInt = min(r,g,b);
if(minColorInt == r){
  // red
  if(minColorInt > 20){
    r = minColorInt - 20;  
  }
}
else if (minColorInt == g){
  //green
  if(minColorInt > 20){
    g = minColorInt - 20;  
  }
}
else {
   //blue
   if(minColorInt > 20){
    b = minColorInt - 20;  
  }  
}


port.write(0xff); //write marker (0xff) for synchronization
port.write((byte)(r)); //write red value
port.write((byte)(g)); //write green value
port.write((byte)(b)); //write blue value
delay(10); //delay for safety

background(r,g,b); //make window background average color
}