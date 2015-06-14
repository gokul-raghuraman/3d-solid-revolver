class Spine
{
  float maxRadius;
  float minRadius;
  float radius;
  float height;
  float resolution;
  int numSegs;
  boolean curved = false;
  boolean bending = false;
  pt loc;
  pt center;
  vec originUp;
  
  //Rotation vector on X-Y plane
  vec IRot;
  
  Spine()
  {
    //Dimensions
    radius = 10000;
    height = 400;
    maxRadius = 10000;
    minRadius = 2 * height / PI;
    
    //Length of each segment
    resolution = 1;
    numSegs = int(height / resolution);
    
    
    //loc -> location of point of intersection of spine with X-Y plane
    loc = new pt(0, 0, 0);
    
    // the up axis of the plane the circle is in w.r.t. +Z
    originUp = new vec(0,0,1);
    
    //IRot -> 'I' unit vector rotated on X-Y plane 
    IRot = new vec(I.x, I.y, I.z); //1,0,0
    
    //center -> center of associated circle 
    center = new pt(loc.x + radius * IRot.x, loc.y + radius * IRot.y, 0);
  }
  
  void setBend()
  {
    bending = true;
  }
  
  void unsetBend()
  {
    bending = false;
  }
  
  void bend(pt selectedPoint)
  {
    
    if (sqrt(pow(selectedPoint.x - loc.x, 2) + pow(selectedPoint.y - loc.y, 2) + pow(selectedPoint.z - loc.z, 2)) < 30) {
      curved = false;
    }
    else
    {
      curved = true;
      vec rotVec = new vec(selectedPoint.x, selectedPoint.y, selectedPoint.z);
      rotVec.normalize();
      IRot = new vec(rotVec.x, rotVec.y, rotVec.z);
      center = new pt(loc.x + radius * IRot.x, loc.y + radius * IRot.y, 0);
      float dist = sqrt(pow(selectedPoint.x - loc.x, 2) + pow(selectedPoint.y - loc.y, 2) + pow(selectedPoint.z - loc.z, 2));
      
      radius = minRadius + maxRadius - 1800 * log(dist);
      //radius = minRadius + maxRadius - 100 * dist;
      if (radius < minRadius)
        radius = minRadius;
    }
  }
  
  void render()
  {
    stroke(dark_metal);
    noFill();
    strokeWeight(2);
    if (!curved)
    {
      line(loc.x, loc.y, loc.z, loc.x, loc.z, loc.z + height);
    }
    else
    {
      //int numSegs = int(height / resolution);
      float dTheta = (height / radius) / float(numSegs);
      vec radVec = (new vec(loc.x, loc.y, loc.z)).sub(new vec(center.x, center.y, center.z));
      pt p = new pt(loc.x, loc.y, loc.z);
      float theta = 0;
      vec segVec = (new vec(loc.x, loc.y, loc.z + resolution)).sub(new vec(loc.x, loc.y, loc.z));
      show(p, segVec);
      for (int i = 0; i < numSegs; i++)
      {
        p = P(p, segVec);
        segVec = R(segVec, -dTheta, IRot, K);
        show(p, segVec);
      }
      if (bending)
      {
        line(loc.x, loc.y, loc.z, selectedPoint.x, selectedPoint.y, selectedPoint.z);
      }
    }
  }
}
