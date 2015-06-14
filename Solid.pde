//Class for solid of revolution
class Solid
{
  ArrayList<Loop> loops; 

  //Total number of sections of the half-donut version of the solid. 
  //Stored here to transfer orig solid parameter to Animator
  int totalNumSections;

  //max angle of revolution. Stored here for easy access from within Animator
  float alpha;
  
  float volume;

  //Indices of top and bottom cap vertices. They are the same across loops. 
  int maxIndex1 = -1;
  int maxIndex2 = -1;
  int minIndex1 = -1;
  int minIndex2 = -1;

  Solid()
  {
    loops = new ArrayList<Loop>();
  }

  Solid(ArrayList<Loop> l, float a, int tNum)
  {
    alpha = a;
    totalNumSections = tNum;
    loops = new ArrayList<Loop>();
    for (int i = 0; i < l.size (); i++)
    {
      loops.add(l.get(i));
    }

    getVertexNormals();
    volume = getVolume();
    
  }

  void renderOutlineSimple()
  {
    if (loops.size() == 0)
      return;

    stroke(blue_light);
    for (int i = 0; i < loops.size () - 1; i++)
    {
      Loop loop1 = loops.get(i);
      Loop loop2 = loops.get(i + 1);
      pt p1, p2, p3, p4;
      for (int j = 0; j < loop1.G.size (); j++)
      {
        p1 = loop1.G.get(j);
        p2 = loop2.G.get(j);
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      }
    }
    loops.get(0).render(4, true);
    loops.get(loops.size() - 1).render(4, true);
  }

  void getVertexNormals()
  {
    getCapIndices();
    int numPoints = loops.get(0).G.size();
    pt p, p1, p2, p3, p4, p5, p6, p7, p8; 
    p1 = new pt(0, 0, 0);
    p2 = new pt(0, 0, 0);
    p3 = new pt(0, 0, 0);
    p4 = new pt(0, 0, 0);
    p5 = new pt(0, 0, 0);
    p6 = new pt(0, 0, 0);
    p7 = new pt(0, 0, 0);
    p8 = new pt(0, 0, 0);

    int curPoint, prevPoint, nextPoint;
    for (int i = 0; i < loops.size (); i++)
    {
      for (int j = 0; j < numPoints; j++)
      {
        curPoint = j;
        if (j > 0)
          prevPoint = j - 1;
        else
          prevPoint = numPoints - 1;
        if (j < numPoints - 1)
          nextPoint = j + 1;
        else
          nextPoint = 0;

        vec normal = new vec(0, 0, 0);
        vec normal1 = new vec(0, 0, 0);
        vec normal2 = new vec(0, 0, 0);
        vec normal3 = new vec(0, 0, 0);
        vec normal4 = new vec(0, 0, 0);
        p = loops.get(i).G.get(curPoint);

        //Top left face -> p1, p2, p3, p
        //Top right face -> p3, p4, p5, p
        //Bottom right face -> p5, p6, p7, p
        //Bottom left face ->p7, p8, p1, p

        if (i < loops.size() - 1)
        {
          p1 = loops.get(i+1).G.get(curPoint);
          p2 = loops.get(i+1).G.get(nextPoint);
          p8 = loops.get(i+1).G.get(prevPoint);
        }
        p3 = loops.get(i).G.get(nextPoint);

        if (i > 0)
        {
          p4 = loops.get(i-1).G.get(nextPoint);
          p5 = loops.get(i-1).G.get(j);
          p6 = loops.get(i-1).G.get(prevPoint);
        }

        p7 = loops.get(i).G.get(prevPoint);

        if (i < loops.size() - 1)
        {
          normal1 = getFaceNormal(p1, p2, p3, p);
          normal4 = getFaceNormal(p7, p8, p1, p);
        }
        if (i > 0)
        {
          normal2 = getFaceNormal(p3, p4, p5, p);
          normal3 = getFaceNormal(p5, p6, p7, p);
        }

        if (!((curPoint == maxIndex1 || curPoint == maxIndex2) && (nextPoint == maxIndex1 || nextPoint == maxIndex2)) &&
          !((curPoint == minIndex1 || curPoint == minIndex2) && (nextPoint == minIndex1 || nextPoint == minIndex2)))
        {
          if (i < loops.size() - 1)
            normal.add(normal1);
          if (i > 0)
            normal.add(normal2);
        }

        if (!((curPoint == maxIndex1 || curPoint == maxIndex2) && (prevPoint == maxIndex1 || prevPoint == maxIndex2)) &&
          !((curPoint == minIndex1 || curPoint == minIndex2) && (prevPoint == minIndex1 || prevPoint == minIndex2)))
        {
          if (i > 0)
            normal.add(normal3); 
          if (i < loops.size() - 1)
            normal.add(normal4);
        }

        loops.get(i).vertexNormalMap.put(j, normal);
      }
    } 
    getCapVertexNormals();
  }

  void getCapVertexNormals()
  {
    //Get the flat-normals for the cap and puts them in a hash map capVertexNormals
    boolean clockWise = true;
    if (loops.get(0).G.get(maxIndex1).x < loops.get(0).G.get(maxIndex2).x)
      clockWise = false;
    Loop curLoop, prevLoop, nextLoop;
    pt p1, p2, p3, p4, p5, p6;
    vec N, N1, N2;
    for (int i = 0; i < loops.size (); i++)
    {
      N = new vec(0, 0, 0);
      curLoop = loops.get(i);

      p1 = curLoop.G.get(maxIndex1);
      p4 = curLoop.G.get(maxIndex2);
      if (i < loops.size() - 1)
      {
        nextLoop = loops.get(i + 1);
        p2 = nextLoop.G.get(maxIndex1);
        p3 = nextLoop.G.get(maxIndex2);        
        N1 = getFaceNormal(p3, p2, p1, p4);
        N.add(N1);
      }

      if (i > 0)
      {
        prevLoop = loops.get(i - 1);
        p5 = prevLoop.G.get(maxIndex2);
        p6 = prevLoop.G.get(maxIndex1);
        N2 = getFaceNormal(p4, p1, p6, p5);
        N.add(N2);
      }
      N.normalize();
      if (!clockWise)
        N = N.mul(-1);
      curLoop.capVertexNormalMap.put(maxIndex1, N);
      curLoop.capVertexNormalMap.put(maxIndex2, N);
    }

    //Only process the bottom cap if there is one
    if (minIndex1 == -1 || minIndex2 == -1)
      return;

    clockWise = true;
    if (loops.get(0).G.get(minIndex1).x < loops.get(0).G.get(minIndex2).x)
      clockWise = false;
    for (int i = 0; i < loops.size (); i++)
    {
      N = new vec(0, 0, 0);
      curLoop = loops.get(i);
      p1 = curLoop.G.get(minIndex1);
      p4 = curLoop.G.get(minIndex2);
      if (i < loops.size() - 1)
      {
        nextLoop = loops.get(i + 1);
        p2 = nextLoop.G.get(minIndex1);
        p3 = nextLoop.G.get(minIndex2);
        N1 = getFaceNormal(p3, p2, p1, p4);
        N.add(N1);
      }

      if (i > 0)
      {
        prevLoop = loops.get(i - 1);
        p5 = prevLoop.G.get(minIndex2);
        p6 = prevLoop.G.get(minIndex1);
        N2 = getFaceNormal(p4, p1, p6, p5);
        N.add(N2);
      }

      N.normalize();
      if (clockWise)
        N = N.mul(-1);
      curLoop.capVertexNormalMap.put(minIndex1, N);
      curLoop.capVertexNormalMap.put(minIndex2, N);
    }
  }

  void getCapIndices()
  { 
    maxIndex1 = 0;
    //Loop loop1 = loops.get(0);
    //maxIndex2 = 0;
    maxIndex2 = loops.get(0).G.size() - 1;
      
    minIndex1 = loops.get(0).G.size() / 2 - 1;
    minIndex2 = loops.get(0).G.size() / 2;
  }

  void renderWireframe()
  {
    if (loops.size() == 0)
      return;
    strokeWeight(2);
    stroke(red);
    for (int i = 0; i < loops.size () - 1; i++)
    {
      Loop loop1 = loops.get(i);
      Loop loop2 = loops.get(i + 1);
      pt p1, p2, p3, p4;
      for (int j = 0; j < loop1.G.size (); j++)
      {
        p1 = loop1.G.get(j);
        p2 = loop2.G.get(j);
        line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
      }
    }
    
    //Render silhouette edges
    renderSilhouetteEdgesSafe();
  }

  void renderSmooth(color col)
  {
    if (loops.size() == 0)
      return;

    //Render loop A & B faces if revolved
    loops.get(0).renderFace(col, 255, true);
    loops.get(loops.size() - 1).renderFace(col, 255, true);

    //Render lateral faces
    fill(col);
    noStroke();
    Loop loop1 = new Loop();
    Loop loop2 = new Loop();
    vec normal1 = new vec(0, 0, 0);
    vec normal2 = new vec(0, 0, 0);
    vec normal3 = new vec(0, 0, 0);
    vec normal4 = new vec(0, 0, 0);
    for (int i = 0; i < loops.size (); i++)
    {

      loop1 = loops.get(i); 
      if (i < loops.size() - 1)
        loop2 = loops.get(i + 1);

      pt p1 = new pt(0, 0, 0);
      pt p2 = new pt(0, 0, 0);
      pt p3 = new pt(0, 0, 0);
      pt p4 = new pt(0, 0, 0); 
      for (int j = 0; j < loop1.G.size (); j++)
      {
        
        int curIndex = j;
        int nextIndex = j + 1;
        if (j == loop1.G.size() - 1)
          nextIndex = 0;
          
        //Skip rendering the caps
        if ((curIndex == maxIndex1 || curIndex == maxIndex2) && (nextIndex == maxIndex1 || nextIndex == maxIndex2))
        {
          continue;
        } 
        
        if (minIndex1 != -1 && minIndex2 != -1)
        {
          if ((curIndex == minIndex1 || curIndex == minIndex2) && (nextIndex == minIndex1 || nextIndex == minIndex2))
          {
            continue;
          }  
        }
        
        
        beginShape();
        p1 = loop1.G.get(j);

        if (i < loops.size() - 1)
        {
          p2 = loop2.G.get(j);
          p3 = loop2.G.get(nextIndex);
        }
        p4 = loop1.G.get(nextIndex);

        normal1 = loop1.vertexNormalMap.get(j);
        if (i < loops.size() - 1)
          normal2 = loop2.vertexNormalMap.get(j);

        if (i < loops.size() - 1)
            normal3 = loop2.vertexNormalMap.get(nextIndex);
        
        normal4 = loop1.vertexNormalMap.get(nextIndex);
        
        normal(normal1.x, normal1.y, normal1.z);
        vertex(p1.x, p1.y, p1.z);

        if (i < loops.size() - 1)
        {
          normal(normal2.x, normal2.y, normal2.z);
          vertex(p2.x, p2.y, p2.z);
          normal(normal3.x, normal3.y, normal3.z);
          vertex(p3.x, p3.y, p3.z);
        }
        normal(normal4.x, normal4.y, normal4.z);
        vertex(p4.x, p4.y, p4.z);
        endShape();
      }
    }
    pt p1, p2, p3, p4;
    Loop curLoop, nextLoop;

    //Texture the caps

    //Get local I, J
    curLoop = loops.get(0);
    pt origin = curLoop.G.get(maxIndex1);
    //pt origin = new pt(0, 0, 0);
    normal1 = curLoop.capVertexNormalMap.get(maxIndex1);
    p1 = curLoop.G.get(maxIndex1);
    p2 = curLoop.G.get(maxIndex2);
    vec ILoc = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
    ILoc.normalize();
    vec JLoc = N(normal1, ILoc);
    JLoc.normalize();
    
    //Now texturing -> top cap
    float x, y, u, v;
    noStroke();
    beginShape();
    texture(hatchImage);
    textureMode(NORMAL);
    curLoop = loops.get(0);
    origin = curLoop.G.get(maxIndex1);
    normal1 = curLoop.capVertexNormalMap.get(maxIndex1);
    p1 = curLoop.G.get(maxIndex1);
    p2 = curLoop.G.get(maxIndex2);
    ILoc = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
    ILoc.normalize();
    JLoc = N(normal1, ILoc);
    JLoc.normalize();
    stroke(red_light);
    vec temp;
    for (int i = 0; i < loops.size (); i++)
    {
      curLoop = loops.get(i);
      p1 = curLoop.G.get(maxIndex1);
      vec posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
      normal1 = curLoop.capVertexNormalMap.get(maxIndex1);
      x = dot(ILoc, posVec);
      y = dot(JLoc, posVec);
      u = 0.05 * x;
      v = 0.05 * y;

      temp = new vec(normal1.x, normal1.y, normal1.z).mul(20);
      normal(normal1.x, normal1.y, normal1.z);
      vertex(p1.x, p1.y, p1.z, u, v);
    } 

    for (int i = loops.size () - 1; i >= 0; i--)
    {
      curLoop = loops.get(i);
      p1 = curLoop.G.get(maxIndex2);
      vec posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
      normal1 = curLoop.capVertexNormalMap.get(maxIndex2);

      temp = new vec(normal1.x, normal1.y, normal1.z).mul(20);
      x = dot(ILoc, posVec);
      y = dot(JLoc, posVec);
      u = 0.05 * x;
      v = 0.05 * y;
      normal(normal1.x, normal1.y, normal1.z);
      vertex(p1.x, p1.y, p1.z, u, v);
    }
    p1 = loops.get(0).G.get(maxIndex1);
    vec posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
    normal1 = loops.get(0).capVertexNormalMap.get(maxIndex1);
    endShape();
    noFill();
  
    if (minIndex1 == -1 || minIndex2 == -1)
      return;
    
    //bottom cap
    noStroke();
    beginShape();
    texture(hatchImage);
    textureMode(NORMAL);
    curLoop = loops.get(0);
    origin = curLoop.G.get(minIndex1);
    normal1 = curLoop.capVertexNormalMap.get(minIndex1);
    p1 = curLoop.G.get(minIndex1);
    p2 = curLoop.G.get(minIndex2);
    ILoc = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
    ILoc.normalize();
    JLoc = N(normal1, ILoc);
    JLoc.normalize();
    stroke(red_light);
  
    for (int i = 0; i < loops.size (); i++)
    {
      curLoop = loops.get(i);
      p1 = curLoop.G.get(minIndex1);
      posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
      normal1 = curLoop.capVertexNormalMap.get(minIndex1);
      x = dot(ILoc, posVec);
      y = dot(JLoc, posVec);
      u = 0.05 * x;
      v = 0.05 * y;

      temp = new vec(normal1.x, normal1.y, normal1.z).mul(20);
      normal(normal1.x, normal1.y, normal1.z);
      vertex(p1.x, p1.y, p1.z, u, v);
    }
  
    for (int i = loops.size () - 1; i >= 0; i--)
    {
      curLoop = loops.get(i);
      p1 = curLoop.G.get(minIndex2);
      posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
      normal1 = curLoop.capVertexNormalMap.get(minIndex2);
      temp = new vec(normal1.x, normal1.y, normal1.z).mul(20);
      x = dot(ILoc, posVec);
      y = dot(JLoc, posVec);
      u = 0.05 * x;
      v = 0.05 * y;
      normal(normal1.x, normal1.y, normal1.z);
      vertex(p1.x, p1.y, p1.z, u, v);
    }  
    p1 = loops.get(0).G.get(minIndex1);
    posVec = (new vec(p1.x, p1.y, p1.z)).sub(new vec(origin.x, origin.y, origin.z));
    normal1 = loops.get(0).capVertexNormalMap.get(minIndex1);
    endShape();
    noFill();
  }
  
  void renderSilhouetteEdgesSafe()
  {
    try
    {
      renderSilhouetteEdges();
    }
    catch (IndexOutOfBoundsException e)
    {
      //Do nothing
    }
  }

  void renderSilhouetteEdges()
  {
    //Check first loop 
    Loop firstLoop = loops.get(0);
    Loop nextLoop = loops.get(1);
    pt A, B, C, D;
    vec N1 = firstLoop.getNormal();

    for (int i = 0; i < firstLoop.G.size (); i++)
    {
      A = firstLoop.G.get(i);
      if (i < firstLoop.G.size() - 1)
        B = firstLoop.G.get(i + 1);
      else
        B = firstLoop.G.get(0);

      C = nextLoop.G.get(i);
      if (i < firstLoop.G.size() - 1)
        D = nextLoop.G.get(i + 1);
      else
        D = nextLoop.G.get(0);
      vec N2 = getFaceNormal(C, D, B, A);
      vec BV = (new vec(viewer.x, viewer.y, viewer.z)).sub(new vec(B.x, B.y, B.z));
      float val1 = dot(BV, N1);
      float val2 = dot(BV, N2);
      if (val1 * val2 < 0)
      {
        stroke(red_light);
        strokeWeight(3);
      }
      else
      {
        stroke(blue_light);
        strokeWeight(2);
      }
      show(A, B);
    }

    //Check first loop
    Loop lastLoop = loops.get(loops.size() - 1);
    Loop prevLoop = loops.get(loops.size() - 2);
    N1 = lastLoop.getNormal();
    for (int i = 0; i < lastLoop.G.size (); i++)
    {
      A = lastLoop.G.get(i);
      if (i < lastLoop.G.size() - 1)
        B = lastLoop.G.get(i + 1);
      else
        B = lastLoop.G.get(0);
      C = prevLoop.G.get(i);
      if (i < lastLoop.G.size() - 1)
        D = prevLoop.G.get(i + 1);
      else
        D = prevLoop.G.get(0);
      vec N2 = getFaceNormal(C, D, B, A);
      vec BV = (new vec(viewer.x, viewer.y, viewer.z)).sub(new vec(B.x, B.y, B.z));
      float val1 = dot(BV, N1);
      float val2 = dot(BV, N2);
      if (val1 * val2 < 0)
      {
        stroke(red_light);
        strokeWeight(3);
      }
      else
      {
        stroke(blue_light);
        strokeWeight(2);
      }
      show(A, B);
    }

    //Check along the body
    Loop curLoop;
    pt E, F;
    for (int i = 0; i < loops.size () - 1; i++)
    {
      curLoop = loops.get(i);
      nextLoop = loops.get(i + 1);
      for (int j = 0; j < curLoop.G.size (); j++)
      {
        A = curLoop.G.get(j);
        B = nextLoop.G.get(j);
        if (j < curLoop.G.size() - 1)
        {
          C = curLoop.G.get(j + 1);
          D = nextLoop.G.get(j + 1);
        } else
        {
          C = curLoop.G.get(0);
          D = nextLoop.G.get(0);
        }
        if (j > 0)
        {
          E = curLoop.G.get(j - 1);
          F = nextLoop.G.get(j - 1);
        } else
        {
          E = curLoop.G.get(curLoop.G.size() - 1);
          F = nextLoop.G.get(curLoop.G.size() - 1);
        }

        N1 = getFaceNormal(C, D, B, A);
        vec N2 = getFaceNormal(A, B, F, E);
        vec BV = (new vec(viewer.x, viewer.y, viewer.z)).sub(new vec(B.x, B.y, B.z));
        float val1 = dot(BV, N1);
        float val2 = dot(BV, N2);
        if (val1 * val2 < 0)
        {
          stroke(red_light);
          strokeWeight(3);
        }
        else
        {
          stroke(blue_light);
          strokeWeight(2);
        }
        show(A, B);
      }
    }
    //Now check cross-sections
    for (int i = 1; i < loops.size () - 1; i++)
    {
      curLoop = loops.get(i);
      prevLoop = loops.get(i - 1);
      nextLoop = loops.get(i + 1); 
      for (int j = 0; j < curLoop.G.size (); j++)
      {
        A = curLoop.G.get(j);
        if (j < curLoop.G.size() - 1)
          B = curLoop.G.get(j + 1);
        else
          B = curLoop.G.get(0);
        C = prevLoop.G.get(j);
        if (j < curLoop.G.size() - 1)
          D = prevLoop.G.get(j + 1);
        else
          D = prevLoop.G.get(0);
        E = nextLoop.G.get(j);
        if (j < curLoop.G.size() - 1)
          F = nextLoop.G.get(j + 1);
        else
          F = nextLoop.G.get(0);

        N1 = getFaceNormal(A, B, F, E);
        vec N2 = getFaceNormal(B, A, C, D);
        vec BV = (new vec(viewer.x, viewer.y, viewer.z)).sub(new vec(B.x, B.y, B.z));
        float val1 = dot(BV, N1);
        float val2 = dot(BV, N2);
        if (val1 * val2 < 0)
        {
          stroke(red_light);
          strokeWeight(3);
        }
        else
        {
          stroke(blue_light);
          strokeWeight(2);
        }
        show(A, B);
      }
    }
    strokeWeight(2);
  }

  void renderSimple(boolean renderEdges, color col, int transparency)
  {
    if (loops.size() == 0)
      return;
   
    //Render loop A & B faces if revolved
    loops.get(0).renderFace(col, transparency, false);
    loops.get(loops.size() - 1).renderFace(col, transparency, false);

    //Render lateral faces
    fill(col, transparency);
    noStroke();
    for (int i = 0; i < loops.size () - 1; i++)
    {
      Loop loop1 = loops.get(i);
      Loop loop2 = loops.get(i + 1);
      pt p;
      for (int j = 0; j < loop1.G.size (); j++)
      {
        beginShape();
        p = loop1.G.get(j);
        vertex(p.x, p.y, p.z);
        p = loop2.G.get(j);
        vertex(p.x, p.y, p.z);
        if (j < loop1.G.size() - 1)
          p = loop2.G.get(j + 1);
        else
          p = loop2.G.get(0);
        vertex(p.x, p.y, p.z);
        if (j < loop1.G.size() - 1)
          p = loop1.G.get(j + 1);
        else
          p = loop1.G.get(0);
        vertex(p.x, p.y, p.z);
        endShape();
      }
    }

    //Render loop outlines if specified. Note: having lots of vertices kills memory. 
    //So they'll be hidden if loops are revolved.
    /*
    if (renderEdges)
    {
      for (int i = 0; i < loops.size (); i++)
      {
        Loop loop = loops.get(i);
        loop.render(col, true);
      }
    }
    */
  }
  
  float getVolume()
  {
    float volume = 0;
    float loopArea, loopArea1, loopArea2;
    Loop loop;
    float dTheta = PI / totalNumSections;
    for (int i = 0; i < loops.size() - 1; i++)
    {
      loop = loops.get(i);
      pt p = loop.G.get(0);
      float R = pow(p.x, 2) + pow(p.y, 2);
      float r = pow(p.x, 2) + pow(p.y, 2);
      
      loopArea1 = loops.get(i).getArea();
      loopArea2 = loops.get(i).getArea();
      loopArea = (loopArea1 + loopArea2) / 2;
      
      //Get the average loop
      for (int j = 0; j < loops.get(i).G.size(); j++)
      {
        
        p = loop.G.get(j);
        float rad = pow(p.x, 2) + pow(p.y, 2);
        
        if (rad < r)
          r = rad;
        if (rad > R)
          R = rad;
      }
      R = sqrt(R);
      r = sqrt(r); 
      volume += loopArea * ((R + r) / 2) * dTheta; 
    }
    return volume;   
  }
}

