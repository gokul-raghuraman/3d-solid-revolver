class Loop
{
  
  ArrayList<pt> G;
  HashMap<Integer, vec> vertexNormalMap;
  HashMap<Integer, vec> capVertexNormalMap;
  
  Loop()
  {
    G = new ArrayList<pt>();
    vertexNormalMap = new HashMap<Integer, vec>();
    capVertexNormalMap = new HashMap<Integer, vec>();
  }
  
  Loop(Loop loop)
  {
    G = new ArrayList<pt>();
    vertexNormalMap = new HashMap<Integer, vec>();
    capVertexNormalMap = new HashMap<Integer, vec>();
    for (int i = 0; i < loop.G.size(); i++)
    {
      G.add(loop.G.get(i));
    }
  }
  
  int addPoint(int x, int y, int z)
  {
    G.add(new pt(x, y, z));
    return G.size() - 1;
  }
  
  int addPoint(pt p)
  {
    G.add(new pt(p.x, p.y, p.z));
    return G.size() - 1;
  }
  
  vec getNormal()
  {
    vec normalVec = new vec(0, 0, 0);
    for (int i = 0; i < G.size() - 1; i++)
    {
      pt p1 = G.get(i);
      pt p2 = G.get(i + 1);
      pt p3;
      if (i == G.size() - 2)
      p3 = G.get(0);
      else
      p3 = G.get(i + 2);
      vec v1 = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
      vec v2 = (new vec(p3.x, p3.y, p3.z)).sub(new vec(p2.x, p2.y, p2.z));
      normalVec.add(N(v1, v2));
    }
    normalVec.normalize();
    return normalVec;
  }
  
  vec[] getLocalAxes()
  {
    //Returns unit I, J, K local to the plane of the loop
    //Warning: only use when loop has atleast 3 points
    //Create a vector from points 1 and 3 of loop
    vec initVec = (new vec(G.get(2).x, G.get(2).y, G.get(2).z)).sub(new vec(G.get(0).x, G.get(0).y, G.get(0).z));
    vec KLocal = getNormal();  
    vec ILocal = (new vec(G.get(1).x, G.get(1).y, G.get(1).z)).sub(new vec(G.get(0).x, G.get(0).y, G.get(0).z));
    vec JLocal = N(ILocal, KLocal);
    ILocal.normalize();
    JLocal.normalize();
    return new vec[]{ILocal, JLocal, KLocal};
  }
  
  void render(int colorMode, boolean hideVertices)
  {
    if (G.size() == 0)
      return;
    
    strokeWeight(3);
    noFill();
    if (colorMode == 1)
      stroke(blue_dark);
    if (colorMode == 2)
      stroke(dark_metal);
    if (colorMode == 3)
      stroke(blue);
    if (colorMode == 4)
      stroke(blue_light);
    if (colorMode == 5)
      stroke(red_light2);
    for (int i = 0; i < G.size() - 1; i++)
    {
      pt p1 = G.get(i);
      pt p2 = G.get(i + 1);
      show(p1, p2);
    }
    show(G.get(G.size() - 1), G.get(0));
    
    //Optionally render vertices
    if (!hideVertices)
    {
      if (colorMode == 1)
        stroke(blue);
      if (colorMode == 2)
        stroke(metal);
      if (colorMode == 3)
        stroke(blue_light2);
      if (colorMode == 4)
        stroke(blue_light);
      if (colorMode == 5)
      stroke(red_light2);
      for (int i = 0; i < G.size(); i++)
      {
        show(G.get(i), 3);
      }
    }
  }
  
  void renderFace(color col, int transparency, boolean textured)
  {
    noStroke(); 
    if (textured)
    {
      beginShape();
      texture(hatchImage);
      textureMode(NORMAL);
      pt origin = G.get(0);
      float u, v;
      for (int i = 0; i < G.size(); i++)
      {
        pt p = G.get(i);
        vec posVec = (new vec(p.x, p.y, p.z)).sub(new vec(origin.x, origin.y, origin.z));
        vec[] localAxes = getLocalAxes();
        float x = dot(localAxes[0], posVec);
        float y = dot(localAxes[1], posVec);
        u = 0.05 * x;
        v = 0.05 * y;
        vertex(p.x, p.y, p.z, u, v);
      }
      endShape();
      render(5, true);
    }
    
    else
    {
      fill(col, transparency);
      beginShape();
      for (int i = 0; i < G.size(); i++)
      {
        pt p = G.get(i);
        vertex(p.x, p.y, p.z);
      }
      endShape();
    }
  }
  
  void reversePoints()
  {
    //If points are ordered like this           : 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7
    //Order them now like this for best results : 2 -> 1 -> 7 -> 6 -> 5 -> 4 -> 3
    
    //Swap G0 and G1
//    pt p = G.get(0);
//    G.set(0, G.get(1));
//    G.set(1, p);
    //Do a regular reverse from G2
    for(int i = 0, j = G.size() - 1; i <= j; i++) 
    {
        G.add(i, G.remove(j));
    }
  }
  
  float getArea()
  {
    vec areaVec = new vec(0, 0, 0);
    float area = 0.0;
    pt first = G.get(0);
    pt last = G.get(G.size() - 1);
    vec N = getNormal();
    pt p1, p2;
    vec v1, v2;
    for (int i = 0; i < G.size() - 1; i++)
    {
      p1 = G.get(i);
      p2 = G.get(i + 1);
      v1 = new vec(p1.x, p1.y, p1.z);
      v2 = new vec(p2.x, p2.y, p2.z);
      areaVec = areaVec.add(N(v1, v2));
    }
    v1 = new vec(last.x, last.y, last.z);
    v2 = new vec(first.x, first.y, first.z);
    areaVec = areaVec.add(N(v1, v2));
    area = 0.5 * dot(N, areaVec);
    
    return abs(area);  
  }
  
}
