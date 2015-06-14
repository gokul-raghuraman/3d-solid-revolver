class Ctrl_Pts
{
  ArrayList<pt> G;
  ArrayList<Float> R;
  boolean moving = false;
  boolean changeRadius = false; 
  Ctrl_Pts()
  {
    G = new ArrayList<pt>();
    R = new ArrayList<Float>();
  }
  
  int addPoint(int x, int y, int z)
  {
    G.add(new pt(x, y, z));
    R.add(25.0);
    return G.size() - 1;
  }
  
  int addPoint(pt p)
  {
    G.add(new pt(p.x, p.y, p.z));
    R.add(25.0);
    return G.size() - 1;
  }
  
  void render(int colorMode, boolean hideVertices)
  {
    if (G.size() == 0)
      return;
    
    strokeWeight(1);
    if (colorMode == 1)
      stroke(blue_dark);
    if (colorMode == 2)
      stroke(dark_metal);
    if (colorMode == 3)
      stroke(blue);
    if (colorMode == 4)
      stroke(blue_light);
    for (int i = 0; i < G.size() - 1; i++)
    {
      pt p1 = G.get(i);
      pt p2 = G.get(i + 1);
      show(p1, p2);
    }
    
    //Optionally render vertices
    if (!hideVertices)
    {
      if (colorMode == 1)
        stroke(blue);
      if (colorMode == 2)
        stroke(metal);
      if (colorMode == 3)
        stroke(red);
      if (colorMode == 4)
        stroke(green);
      for (int i = 0; i < G.size(); i++)
      {
        show(G.get(i), 3); //draw circle for control points
      }
    }
  }
  
  int pickClosest(pt M) { //adam
    int bestIndex=-1; 
    float dist = MAX_FLOAT;
    for (int i=0; i<G.size(); i++) {
      if (dist == MAX_FLOAT)
      {
        bestIndex = i;
        dist = d(M,G.get(bestIndex));
      }
      if (d(M,G.get(i))<d(M,G.get(bestIndex)))
      {
        bestIndex=i;
        dist = d(M,G.get(bestIndex));
      }
    }
    return bestIndex;
  } 
  
  void setMove() //adam
  {
    moving = true;
  }
  
  void unsetMove()//adam
  {
    moving = false;
  }
  
  void move(int bestIndex) //adam
  {
    if(moving){
      G.get(bestIndex).x+=mouseX-pmouseX;
      G.get(bestIndex).z-=mouseY-pmouseY;
    }
  }
  
  void setChangeRadius() //adam
  {
    changeRadius = true;
  }
  
  void unsetChangeRadius() //adam
  {
    changeRadius = false;
  }
  
  void ChangeRadius(int bestIndex) //adam
  {
    if(changeRadius)
    {
      R.set(bestIndex, R.get(bestIndex)+d(P(mouseX,mouseY),G.get(bestIndex))-d(P(pmouseX,pmouseY),G.get(bestIndex)));
    }
  }
  
  void InitializeSplineRadius() {
    for(int i = 0; i < G.size(); i++)
    {
      R.add(0.0);
    }
  }
  
  void ResetSplineRadius() {
    for(int i = 0; i < G.size(); i++)
    {
      R.set(i, 0.0);
    }
  }
}
