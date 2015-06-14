class Animator
{
  Solid solid;

  Loop animLoop3D = new Loop();
  Loop animLoop2D = new Loop();

  boolean animating3D = false;
  boolean animating2D = false;
  int curLoopIndex3D = 0;
  int curLoopIndex2D = 0;
  
  int loopDir = 1;
  
  ArrayList<Loop> planarLoops;

  Animator()
  {
    solid = new Solid();
  }

  Animator(Solid s)
  {
    solid = s;
    planarLoops = get2DLoops();
  }
  
  void updateSolid(Solid s)
  {
    solid = s;
    planarLoops = get2DLoops();
  }
  
  //Since 2D loops are only needed to show the animation and 
  //not anywhere else, generate them here.
  //These loops will all be planar (on the x-z plane, because they're 2D)
  ArrayList<Loop> get2DLoops()
  {
    ArrayList<Loop> planarLoops = new ArrayList<Loop>();
    
    //Push the first loop in, we know it's already planar
    Loop firstLoop = new Loop(solid.loops.get(0));
    planarLoops.add(firstLoop);
    
    //Get rotate angle for last loop (because alpha may not always be PI!)
    float rotAngle = PI - solid.alpha;
    Loop lastLoop = new Loop(solid.loops.get(solid.loops.size() - 1));
    
    //Reverse last loop if the directions are misaligned
    if (!loopDirsAligned(firstLoop, lastLoop))
      lastLoop.reversePoints();
    
    //Rotate the last loop of the solid back onto the x-z plane (because alpha may not always be PI!)
    for (int i = 0; i < lastLoop.G.size(); i++)
    {
      pt p = lastLoop.G.get(i);
      float x = cos(rotAngle) * (p.x) - sin(rotAngle) * p.y;
      float y = sin(rotAngle) * (p.x) + cos(rotAngle) * p.y;
      float z = p.z;
      lastLoop.G.set(i, new pt(x, y, z));
    }
    
    //Now interpolate between the first loop and the 'rotated' last loop
    //(Query the solid for the original number of interpolating sections.)
    int numSections = solid.totalNumSections;
    int div = numSections + 1;
    
    for (int i = 0; i < numSections; i++)
    {
      Loop loop = new Loop();
      for (int j = 0; j < firstLoop.G.size(); j++)
      {
        pt pFirst = firstLoop.G.get(j);
        pt pLast = lastLoop.G.get(j);
        pt pInterp = new pt(pFirst.x + (i + 1) * (pLast.x - pFirst.x) / div, 0, pFirst.z + (i + 1) * (pLast.z - pFirst.z) / div);
        loop.addPoint(pInterp);
      }
      planarLoops.add(loop);
    }
    //Now add last loop to planarLoops
    planarLoops.add(lastLoop);
    return planarLoops;
  }
  
  void animateLoop2D()
  {
    if (solid.loops.size() == 0)
      return;
      
    if (animating2D)
    {
      curLoopIndex2D += 1;
      
      if (curLoopIndex2D == planarLoops.size())
        curLoopIndex3D = 0;
        
      try
      {
        animLoop2D = planarLoops.get(curLoopIndex2D);
      }
      
      catch (IndexOutOfBoundsException e)
      {
        animLoop2D = planarLoops.get(0);
        curLoopIndex2D = 0;
      }
      animLoop2D.render(3, true); 
    }
    
    else
    {
     animLoop2D = planarLoops.get(0);
     animLoop2D.render(3, true);
     animating2D = true;
    }
  }
  
  void renderCrossSections2D()
  {
    Loop firstLoop = planarLoops.get(0);
    Loop lastLoop = planarLoops.get(planarLoops.size() - 1);
    
    firstLoop.renderFace(red_light, 50, false);
    lastLoop.renderFace(green_light, 50, false);
    firstLoop.render(1, true);
    lastLoop.render(1, true);
  }
  
  void animateLoop3D()
  {
    if (solid.loops.size() == 0)
      return;
    
    if (animating3D)
    {
      curLoopIndex3D += 1;
      if (curLoopIndex3D == solid.loops.size())
        curLoopIndex3D = 0;
       
      try 
      {
        animLoop3D = solid.loops.get(curLoopIndex3D);
      } 
      
      //If alpha closes in and extent collides with animating loop
      catch (IndexOutOfBoundsException e) 
      {
        animLoop3D = solid.loops.get(0);
        curLoopIndex3D = 0;
      }

      animLoop3D.render(3, true);
    } 
    else
    {
      animLoop3D = solid.loops.get(0);
      animLoop3D.render(3, true);
      animating3D = true;
    }
  }
}

