import java.nio.*;

color black=#000000, white=#FFFFFF, // set more colors using Menu >  Tools > Color Selector
   red=#FF0000, green=#00FF01, green_light = #9AFABF, blue=#0300FF, yellow=#FEFF00, cyan=#00FDFF, 
   magenta=#FF00FB, grey=#818181, orange=#FFA600, brown=#B46005, metal=#B5CCDE, dark_metal = #37576F, 
   dgreen=#157901, blue_light = #8AD2F5, blue_light2 = #8ABBF5, blue_dark = #1F93DE, grey_light = #E8EDF0, 
   red_light = #FF6464, red_light2 = #DB5254; 

boolean loopDirsAligned(Loop loop1, Loop loop2)
{
  vec normalVec1 = new vec(0, 0, 0);
  vec normalVec2 = new vec(0, 0, 0);
  for (int i = 0; i < loop1.G.size() - 1; i++)
  {
    pt p1 = loop1.G.get(i);
    pt p2 = loop1.G.get(i + 1);
    pt p3;
    if (i == loop1.G.size() - 2)
      p3 = loop1.G.get(0);
    else
      p3 = loop1.G.get(i + 2);
    vec v1 = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
    vec v2 = (new vec(p3.x, p3.y, p3.z)).sub(new vec(p2.x, p2.y, p2.z));
    normalVec1.add(N(v1, v2));
    
    p1 = loop2.G.get(i);
    p2 = loop2.G.get(i + 1);
    if (i == loop2.G.size() - 2)
      p3 = loop2.G.get(0);
    else
      p3 = loop2.G.get(i + 2);
    v1 = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
    v2 = (new vec(p3.x, p3.y, p3.z)).sub(new vec(p2.x, p2.y, p2.z));
    normalVec2.add(N(v1, v2));
  }
  int dirAlignment = int(dot(normalVec1, normalVec2) / abs(dot(normalVec1, normalVec2)));
  if (dirAlignment == 1)
    return true;
  return false;
}

vec getFaceNormal(pt p1, pt p2, pt p3, pt p4)
{
  //Applying Newell's formula to get face normal
  vec normal = new vec(0, 0, 0);
  vec v1 = (new vec(p2.x, p2.y, p2.z)).sub(new vec(p1.x, p1.y, p1.z));
  vec v2 = (new vec(p3.x, p3.y, p3.z)).sub(new vec(p2.x, p2.y, p2.z));
  vec v3 = (new vec(p4.x, p4.y, p4.z)).sub(new vec(p3.x, p3.y, p3.z));
  vec v4 = (new vec(p1.x, p1.y, p1.z)).sub(new vec(p4.x, p4.y, p4.z));
  normal.add(N(v1, v2));
  normal.add(N(v2, v3));
  normal.add(N(v3, v4));
  normal.add(N(v4, v1));
  normal.normalize();
  return normal;
}

pt getIntersection3D(pt p1, pt p2, pt p3, pt p4)
{
  //Returns intersection point for a line segment (defined by p1, p2, v1)
  //and a line (defined by p3, v2)
  
  
  float x = (p1.x * (p3.x - p4.x) - p3.x * (p1.x - p2.x)) / (p2.x - p1.x + p3.x - p4.x);
  float y = (p1.y * (p3.y - p4.y) - p3.y * (p1.y - p2.y)) / (p2.y - p1.y + p3.y - p4.y);
  float z = (p1.z * (p3.z - p4.z) - p3.z * (p1.z - p2.z)) / (p2.z - p1.z + p3.z - p4.z);
  
  stroke(red);
  show(p1, 2);
  show(p2, 2);
  
  stroke(green);
  show(p3, 2);
  show(p4, 2);
  
  pt intersection = new pt(x, y, z);
  
  /*
  if (intersection.x < min(p1.x, p2.x) || intersection.x > max(p1.x, p2.x) 
      || intersection.y < min(p1.y, p2.y) || intersection.y > max(p1.y, p2.y)
      || intersection.z < min(p1.z, p2.z) || intersection.z > max(p1.z, p2.z))
      intersection = new pt(-1, -1, -1);
  
  */
  line(p1.x, p1.y, p1.z, intersection.x, intersection.y, intersection.z);
  return intersection;
}
  
  
void drawCanvas2D(int size)
{
  fill(grey_light);
  noStroke();
  beginShape();
  vertex(-size / 2, -600, -size / 2);
  vertex(size / 2, -600, -size / 2);
  vertex(size / 2, -600, size / 2);
  vertex(-size / 2, -600, size / 2);
  endShape();
  
}



public pt pick3D(int mX, int mY)
{
  PGL pgl = beginPGL();
  FloatBuffer depthBuffer = ByteBuffer.allocateDirect(1 << 2).order(ByteOrder.nativeOrder()).asFloatBuffer();
  pgl.readPixels(mX, height - mY - 1, 1, 1, PGL.DEPTH_COMPONENT, PGL.FLOAT, depthBuffer);
  float depthValue = depthBuffer.get(0);
  depthBuffer.clear();
  endPGL();
    
  //get 3d matrices
  PGraphics3D p3d = (PGraphics3D)g;
  PMatrix3D proj = p3d.projection.get();
  PMatrix3D modelView = p3d.modelview.get();
    
  PMatrix3D modelViewProjInv = proj; 
  modelViewProjInv.apply( modelView ); 
  modelViewProjInv.invert();
  float[] viewport = {0, 0, p3d.width, p3d.height};
  float[] normalized = new float[4];
  normalized[0] = ((mX - viewport[0]) / viewport[2]) * 2.0f - 1.0f;
  normalized[1] = ((height - mY - viewport[1]) / viewport[3]) * 2.0f - 1.0f;
  normalized[2] = depthValue * 2.0f - 1.0f;
  normalized[3] = 1.0f;
    
  float[] unprojected = new float[4];
  modelViewProjInv.mult( normalized, unprojected );
  return P( unprojected[0]/unprojected[3], unprojected[1]/unprojected[3], unprojected[2]/unprojected[3]);
}

pt viewPoint()
{
  return pick(0, 0, (height / 2.0) / tan(PI / 6));
}

pt pick(float mX, float mY, float mZ)
{
  //get 3d matrices
  PGraphics3D p3d = (PGraphics3D)g;
  PMatrix3D proj = p3d.projection.get();
  PMatrix3D modelView = p3d.modelview.get();
  PMatrix3D modelViewProjInv = proj; modelViewProjInv.apply( modelView );  
  modelViewProjInv.invert();
  float[] viewport = {0, 0, p3d.width, p3d.height};
  float[] normalized = new float[4];
  normalized[0] = ((mX - viewport[0]) / viewport[2]) * 2.0f - 1.0f;
  normalized[1] = ((height - mY - viewport[1]) / viewport[3]) * 2.0f - 1.0f;
  normalized[2] = mZ * 2.0f - 1.0f;
  normalized[3] = 1.0f;
  float[] unprojected = new float[4];
  modelViewProjInv.mult( normalized, unprojected );
  return P( unprojected[0]/unprojected[3], unprojected[1]/unprojected[3],unprojected[2]/unprojected[3] );
}
  
  
