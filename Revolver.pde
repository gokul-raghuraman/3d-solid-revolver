class Revolver
{
  Loop loopA, loopB;
  
  Spine spine;
  
  int totalNumSections;
  
  Solid solid;
  
  boolean revolved;
  
  Revolver(Loop A, Loop B, Spine s)
  {
    loopA = A;
    loopB = B;
    spine = s;
    solid = new Solid();
    totalNumSections = 25;
    revolved = false;
    
    //Reverse loopB if required
    //if (loopDirsAligned(loopA, loopB))
    //  loopB.reversePoints();
    
  }
  
  Solid getSolid()
  {
    return solid;
  }
  
  void revolve(float alpha)
  {
    if (loopA.G.size() == 0 || loopB.G.size() == 0)
      return;
    if (loopA.G.size() != loopB.G.size())
      return;
    
    int div = totalNumSections + 1;
    float dTheta = PI / div;
    float theta = 0;
    ArrayList<Loop> loops = new ArrayList<Loop>();
    
    int numSections = int((alpha / PI) * totalNumSections);
    for (int i = 0; i <= numSections + 1; i++)
    {
      Loop loop = new Loop();
      for (int j = 0; j < loopA.G.size(); j++)
      {
        pt pA = loopA.G.get(j);
        pt pB = loopB.G.get(j);
        
        //Mirror image of loop B point
        pt pRot = new pt(-pB.x, pB.y, pB.z);
        //Lerp from A to mirror image of B
        pt pC = new pt(pA.x + (i + 1) * (pRot.x - pA.x) / div, pA.y + (i + 1) * (pRot.y - pA.y) / div, pA.z + (i + 1) * (pRot.z - pA.z) / div);

        //Lerp from A to rotate about z axis
        float x = cos(theta) * (pC.x) - sin(theta) * pC.y;
        float y = sin(theta) * (pC.x) + cos(theta) * pC.y;
        pC.x = x;
        pC.y = y;
        loop.addPoint(pC);
      }
      loops.add(loop);
      theta += dTheta;
    }
    solid = new Solid(loops, alpha, totalNumSections);
    revolved = true;
  }
  
}
