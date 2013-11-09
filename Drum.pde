// Jake Leland
// Drum (class)

class Drum
{
  AudioSnippet drum;
  
  int boxSize;
  PVector boxCenter;
  int pointsInBox;
  boolean wasJustInBox;
  boolean isInBox;
  float rx;
  float ry;
  int r;
  int g;
  int b;
  
  Drum(String filename, int x, int y, int z, int s, float rx, float ry, int r, int g, int b)
  {
    drum = m.loadSnippet(filename);
    boxSize = s;
    boxCenter = new PVector(-x,y,z);
    this.rx = rx;
    this.ry = -ry;
    this.r = r;
    this.g = g;
    this.b = b;
    pointsInBox = 0;
    wasJustInBox = false;
  }
  
  // check to see if a point is within the drum
  void checkPoint(PVector point)
  {
    if(point.x > boxCenter.x - boxSize/2 && point.x < boxCenter.x + boxSize/2
    && point.y > boxCenter.y - boxSize/2 && point.y < boxCenter.y + boxSize/2
    && point.z > boxCenter.z - boxSize/2 && point.z < boxCenter.z + boxSize/2)
      pointsInBox++;
  }
  
  // display the drum
  void d()
  {
    println(pointsInBox);
    
    pushMatrix();
    translate(boxCenter.x,boxCenter.y,boxCenter.z);
    rotateX(rx);
    rotateY(ry);
    stroke(r,g,b);
    float boxAlpha = map(pointsInBox,0,1000,0,255);
    fill(r,g,b,boxAlpha);
    box(boxSize);
    popMatrix();
    
    isInBox = (pointsInBox>0);
    
    if(!wasJustInBox && isInBox)
    {
      drum.rewind();
      drum.play();
    }
    
    if(!drum.isPlaying())
    {
      drum.pause();
      drum.rewind();
    }
    
    wasJustInBox = isInBox;
    
    pointsInBox = 0;
  }
  
  void close()
  {
    drum.close();
  }
}
