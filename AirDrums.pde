// Jake Leland
// AirDrums (main method)

// NOTE: This processing sketch requires the use of
// the Xbox Kinect sensor

import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

Minim m;

SimpleOpenNI kinect;

float s = 1;

PVector currPoint;

Map<String,Drum> kit;

void setup()
{
    size(1024,768,OPENGL);
    kinect = new SimpleOpenNI(this);
    kinect.enableDepth();
    
    m = new Minim(this);
    kit = new TreeMap<String,Drum>();
    // Create all of the drums in the drumkit,
    // putting them into a map based on their name.
    // (filename,x,y,z,size,rotatex,rotatey,r,g,b)
    kit.put("kick",new Drum      ("k4.wav",0,-600,1300,300,0,0,0,0,255));
    kit.put("snare",new Drum     ("s12.wav",-200,-200,1200,150,0,radians(15),255,0,0));
    kit.put("tom_1",new Drum     ("tf1.wav",-200,0,1100,150,radians(15),radians(7.5),255,150,0));
    kit.put("tom_2",new Drum     ("tf2.wav",0,0,1100,150,radians(15),0,255,125,0));
    kit.put("tom_3",new Drum     ("tf3.wav",200,0,1100,150,radians(15),radians(-7.5),255,100,0));
    kit.put("tom_floor",new Drum ("tf4.wav",200,-200,1200,150,0,radians(-7.5),255,75,0));
    kit.put("crash",new Drum     ("cr12.wav",400,200,1150,175,radians(30),radians(-15),255,255,0));
    kit.put("ride",new Drum      ("r1.wav",-400,200,1150,175,radians(30),radians(15),255,255,0));
    kit.put("hihat",new Drum     ("hh1.wav",-425,-200,1400,150,0,radians(60),255,255,0));
    kit.put("cowbell",new Drum   ("cowbell.wav",-355,-50,1250,100,0,radians(45),255,0,255));
    kit.put("tambourine",new Drum("tam1.wav",425,-200,1400,150,0,radians(-60),0,255,0));
    kit.put("belltree",new Drum  ("belltree1.wav",355,-50,1250,100,0,radians(-45),0,255,255));
}

void draw()
{
    background(0);
    stroke(255);
    kinect.update();
    
    // Ajust 3d space so that the default orientation is
    // as if the camera is behind the user.
    translate(width/2,height/2,-1000);
    rotateZ(PI);

    translate(0,0,-500);
    
    // The mouse can be used to change the camera direction
    float mouseRotationX = map(mouseX,0,width,-PI,PI);
    rotateY(mouseRotationX);
    
    float mouseRotationY = map(mouseY,0,height,PI/4,-PI/4);
    rotateX(mouseRotationY);
    
    translate(0,0,s*-1000);    
    scale(s);
    
    PVector[] depthPoints = kinect.depthMapRealWorld();

    // draw the user (if within a certain range)
    for(int i = 0; i<depthPoints.length; i+=10)
    {
        currPoint = depthPoints[i];
        if(currPoint.z < 1400 && currPoint.z > 900)
          stroke(255);
        else if(currPoint.z < 1800 && currPoint.z > 1400)
          stroke(200);
        else
          stroke(100);
        point(currPoint.x,currPoint.y,currPoint.z);
        // check to see if the point is within a drum
        for(String key : kit.keySet())
          kit.get(key).checkPoint(currPoint);
    }
    
    // display the kit
    for(String key : kit.keySet())
      kit.get(key).d();
}

void keyPressed()
{
  // adjust the scale based on the arrow keys
  if(keyCode == UP)
    s+=0.01;
  if(keyCode == DOWN)
    s-=0.01;
}

void stop()
{
  for(String key : kit.keySet())
    kit.get(key).close();
  
  m.stop();
  super.stop();
}
