class GUIManager
{
  //Views
  int VIEW_2D = 0;
  int VIEW_3D = 1;
  int ANIM_2D = 2;
  int ANIM_3D = 3;
  
  int NORMAL_OFFSET = 0;
  int RADIAL_OFFSET = 1;
  int BALL_OFFSET = 2;
  
  int offsetType = NORMAL_OFFSET;
  
  //Render modes
  int FLAT_SHADE = 0;
  int SMOOTH_SHADE = 1;
  int WIREFRAME = 2;
  
  //The angle of revolution  __ \ | / __
  float alpha = PI;
  
  Spine spine;
  Revolver revolver;
  Animator animator;
  
  pt pickedPoint;
  
  Loop loopA, loopB;
  
  Ctrl_Pts PtsA, PtsB; //adam
  Ctrl_Pts A_Bspline, B_Bspline;//adam
  
  boolean showRevolved = false;
  
  //Current view
  int view = VIEW_2D;
  
  //For turning grid on/off
  boolean displayGrid = true;
  
  //Current render mode
  int renderMode = FLAT_SHADE;
  
  GUIManager()
  {
    spine = new Spine();
    pickedPoint = new pt(0, 0, 0); 
    
    loopA = new Loop();
    loopB = new Loop();
    revolver = new Revolver(loopA, loopB, spine);
    
    PtsA = new Ctrl_Pts(); //adam
    PtsB = new Ctrl_Pts(); //adam
    A_Bspline = new Ctrl_Pts(); //adam
    B_Bspline = new Ctrl_Pts(); //adam
    
  }
  
  void setOffsetType(int type)
  {
    if (type == NORMAL_OFFSET || type == RADIAL_OFFSET || type == BALL_OFFSET)
      offsetType = type; 
  }
  
  void registerSelection(pt selectedPoint)
  {
    pickedPoint = new pt(selectedPoint.x, selectedPoint.y, selectedPoint.z);
    pickedPoint.z = 0;
  }
  
  void registerSelection1(pt selectedPoint) //adam
  {
    pickedPoint = new pt(selectedPoint.x, selectedPoint.y, selectedPoint.z);
    pickedPoint.y = 0;
  }
  
  void addLoopPoint(int loopID, int x, int y, int z)
  {
    if (loopID == 1)
    {
      loopA.addPoint(x, y, z);
    }
    
    else if (loopID == 2)
    {
      loopB.addPoint(x, y, z);
    }
  }
  
  void addControlPoint(int loopID, int x, int y, int z) //adam
  {
    if (loopID == 1)
    {
      PtsA.addPoint(x, y, z);
      A_Bspline = quinticBspline(PtsA);//adam
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline.InitializeSplineRadius();
      setSplineRadii(PtsA,A_Bspline);
      //println(A_Bspline.R);
    }
    
    else if (loopID == 2)
    {
      PtsB.addPoint(x, y, z);
      B_Bspline = quinticBspline(PtsB);//adam
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline.InitializeSplineRadius();
      setSplineRadii(PtsB,B_Bspline);
    }
  }
  
  void updateSolidAlpha(float delta)
  {
    float a = 0.1;
    if (delta < 0)
      a = -0.1;
    
    if (alpha + a  > 0.1 && alpha + a < PI + 0.1)
      alpha += a;
    
    revolver.revolve(alpha); 
  }
  
  void toggleShadingMode()
  {
    if (renderMode == SMOOTH_SHADE)
      renderMode = FLAT_SHADE;
    else
      renderMode = SMOOTH_SHADE;
  }
  
  void toggleWireframeMode()
  {
    if (renderMode == WIREFRAME)
      renderMode = FLAT_SHADE;
    else
      renderMode = WIREFRAME;
  }
  
  void toggleDisplayRevolvedLoops()
  {
    showRevolved = !showRevolved;
  }
  
  void toggleDisplayGrid()
  {
    displayGrid = !displayGrid;
  }
  
  void revolveLoops()
  {
    if (loopA.G.size() == 0 || loopB.G.size() == 0)
      return;
    if (loopA.G.size() != loopB.G.size())
      return;
    revolver = new Revolver(loopA, loopB, spine);
    revolver.revolve(alpha);
    
    //Hook in the solid to the animator
    animator = new Animator(revolver.getSolid());
    
  }
  
  void renderLoops()
  {
    loopA.renderFace(red_light, 50, false);
    loopB.renderFace(green_light, 50, false);
  }
  
  void renderControlPoints() //adam
  {
      PtsA.render(3, false);
      PtsB.render(4, false);
      
      A_Bspline.render(1, true);//adam
      for(int i = 0; i < PtsA.G.size(); i++)
      {
        show(PtsA.G.get(i), findclosestpoint(PtsA.G.get(i),A_Bspline));
        stroke(black);
        drawCircle(PtsA.G.get(i), A_Bspline, PtsA.R.get(i));
      }
      
      B_Bspline.render(1, true);//adam
      for(int i = 0; i < PtsB.G.size(); i++)
      {
        show(PtsB.G.get(i), findclosestpoint(PtsB.G.get(i),B_Bspline));
        stroke(black);
        drawCircle(PtsB.G.get(i), B_Bspline, PtsB.R.get(i));
        //shownormal(B_Bspline);
      }
      if (offsetType == NORMAL_OFFSET)
      {
        loopA = orthogonaloffset(A_Bspline);
        loopB = orthogonaloffset(B_Bspline);
      }
      if (offsetType == RADIAL_OFFSET)
      {
        loopA = radialoffset(A_Bspline);
        loopB = radialoffset(B_Bspline);
      }
      
      if (offsetType == BALL_OFFSET)
      {
        halfSplineRadii(PtsA, A_Bspline, 0.5);
        halfSplineRadii(PtsB, B_Bspline, 0.5);
        loopA = balloffset(A_Bspline);
        loopB = balloffset(B_Bspline);
        halfSplineRadii(PtsA, A_Bspline, 1);
        halfSplineRadii(PtsB, B_Bspline, 1);
      }
      
      loopB.reversePoints();
      loopA.render(2, true);
      loopB.render(2, true);
  }
  
  void toggleView3D()
  {
    if (view == VIEW_2D || view == ANIM_3D)
    {
      view = VIEW_3D;
    }
    else if (view == VIEW_3D || view == ANIM_2D)
    {
      view = VIEW_2D;
    }
  }
  
  void toggleAnimModes()
  {
    if (view == ANIM_2D || view == VIEW_3D)
    {
      view = ANIM_3D;
    }
    else if (view == ANIM_3D || view == VIEW_2D)
    {
      view = ANIM_2D;
    }
  }
  
  void renderSolidOutline()
  {
    revolver.getSolid().renderOutlineSimple();
  }
  
  void animateLoop3D()
  {
    if (loopA.G.size() == 0 || loopB.G.size() == 0)
      return;
    revolver = new Revolver(loopA, loopB, spine);
    revolver.revolve(alpha);
    if (animator == null)
    {
      //Only create a new animator if it doesn't already exist. Else continue animation 
      //from existing animator
      animator = new Animator(revolver.getSolid());
    }
    
    else
    {
      //If animator exists, re-connect it with the updated solid with updated alpha
      animator.updateSolid(revolver.getSolid());
    }
    
    animator.animateLoop3D();
  }
  
  void showSelectedPoint()
  {
    show(pickedPoint, 3);
  }
  
  void bendSpine()
  {
    spine.setBend();
    spine.bend(pickedPoint);
  }
  
  void endBendSpine()
  {
    spine.unsetBend();
  }
  
  void renderSpine()
  {
    spine.render();
  }
  
  void movePoint() //adam
  {
    int clickThreshold = 12;
    PtsA.setMove();
    PtsB.setMove();
    int i = PtsA.pickClosest(P(MouseX, 0, MouseZ));
    int j = PtsB.pickClosest(P(MouseX, 0, MouseZ));
    if (i >= 0 && d(P(MouseX, 0, MouseZ), PtsA.G.get(i)) < clickThreshold) {
      PtsA.move(i);
      A_Bspline = quinticBspline(PtsA);//adam
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline = quinticBspline(A_Bspline);
      A_Bspline.InitializeSplineRadius();
      setSplineRadii(PtsA,A_Bspline);
      //println(A_Bspline.R);
    }
    if (j >= 0 && d(P(MouseX, 0, MouseZ), PtsB.G.get(j)) < clickThreshold) {
      PtsB.move(j);
      B_Bspline = quinticBspline(PtsB);//adam
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline = quinticBspline(B_Bspline);
      B_Bspline.InitializeSplineRadius();
      setSplineRadii(PtsB,B_Bspline);
    }
  }
  
  void endMovePoint() //adam
  {
    PtsA.unsetMove();
    PtsB.unsetMove();
  }
  
  int selectedpointindex;
  void setSelected() //adam
  {
    if(MouseX < 0){
    selectedpointindex = pickClosest(P(MouseX, 0, MouseZ),PtsA, A_Bspline);
    //println(selectedpointindex);
    }
    else if(MouseX > 0){
    selectedpointindex = pickClosest(P(MouseX, 0, MouseZ),PtsB, B_Bspline);
    //println(selectedpointindex);
    }
  }
  
  void ChangeRadius() //adam
  {
    PtsA.setChangeRadius();
    PtsB.setChangeRadius();
//    int i = pickClosest(P(MouseX, 0, MouseZ),PtsA, A_Bspline);
    //println(i);
//    int j = pickClosest(P(MouseX, 0, MouseZ),PtsB, B_Bspline);
    if (selectedpointindex >= 0 && MouseX < 0) {
      PtsA.ChangeRadius(selectedpointindex);
      A_Bspline.ResetSplineRadius();
      setSplineRadii(PtsA,A_Bspline);
    }
    if (selectedpointindex >= 0 && MouseX > 0) {
      PtsB.ChangeRadius(selectedpointindex);
      B_Bspline.ResetSplineRadius();
      setSplineRadii(PtsB,B_Bspline);
    }
    //println(A_Bspline.R);
  }
  
  void endChangeRadius() //adam
  {
    PtsA.unsetChangeRadius();
    PtsB.unsetChangeRadius();
  }
  
  void renderSolid()
  {
    if (renderMode == FLAT_SHADE)
    {
      boolean renderEdges = true;
      if (view == VIEW_3D)
        renderEdges = false;
      revolver.getSolid().renderSimple(renderEdges, blue_light, 255);
    }
    
    else if (renderMode == SMOOTH_SHADE)
    {
      revolver.getSolid().renderSmooth(blue_light);
    }
    
    else if (renderMode == WIREFRAME)
    {
      revolver.getSolid().renderSimple(false, grey, 100);
      renderSolidWireframe();
      
    }
  }
  
  void renderSolidWireframe()
  {
    revolver.getSolid().renderWireframe();
  }
  
  void animateLoop2D()
  {
    if (loopA.G.size() == 0 || loopB.G.size() == 0)
      return;
    if (loopA.G.size() != loopB.G.size())
    {
      renderLoops();
      return;
    }
    revolver = new Revolver(loopA, loopB, spine);
    revolver.revolve(alpha);
    
    if (animator == null)
    {
      //Only create a new animator if it doesn't already exist. Else continue animation 
      //from existing animator
      animator = new Animator(revolver.getSolid());
    }
    
    else
    {
      //If animator exists, re-connect it with the updated solid with updated alpha
      animator.updateSolid(revolver.getSolid());
    }
    
    animator.renderCrossSections2D();
    animator.animateLoop2D();
  }
  
  
  void displayGrid(int size, int z)
  {   
    float gridSpacing = 10;
    int numLines = int(size / gridSpacing);
    fill(white, 1);
    noStroke();
    beginShape();
    int offset = -1;
    if (!displayGrid)
      offset = -1000;
    vertex(-size / 2, -size / 2, offset);
    vertex(size / 2, -size / 2, offset);
    vertex(size / 2, size / 2, offset);
    vertex(-size / 2, size / 2, offset);
    endShape();
    
    if (!displayGrid)
      return;
    stroke(grey_light);
    noFill();
    strokeWeight(1);
    for (int i = 0; i <= numLines; i++)
    {
      line(-size / 2, -size / 2 + i * gridSpacing, z, size / 2, -size / 2 + i * gridSpacing, z);
      line(-size / 2 + i * gridSpacing, -size / 2, z, -size / 2 + i * gridSpacing, size / 2, z);
    }
  }
  
  void displayAxes(int size)
  {
    strokeWeight(2);
    stroke(red);
    line(0, 0, 0, size, 0, 0);
    stroke(green);
    line(0, 0, 0, 0, size, 0);
    stroke(blue);
    line(0, 0, 0, 0, 0, size);
  }
  
  void displayOverlay()
  {
    stroke(blue_dark);
    strokeWeight(3);
    noFill();
    rect(10, 10, 180, 65);
    String mode = "2D VIEW";
    if (view == VIEW_3D)
      mode = "3D VIEW";
    if (view == ANIM_2D)
      mode = "2D ANIM";
    if (view == ANIM_3D)
      mode = "3D ANIM";
    String txt1 = "Mode              : " + mode;
    String txt2 = "Offset Type     : ";
    String txt3 = "Shading Mode  : ";
    String txt4 = "Solid Volume    : ";
    
    if (offsetType == NORMAL_OFFSET)
      txt2 += "NORMAL";
    if (offsetType == RADIAL_OFFSET)
      txt2 += "RADIAL";
    if (offsetType == BALL_OFFSET)
      txt2 += "BALL";
    
    if (view == VIEW_3D)
    {
    if (renderMode == FLAT_SHADE)
      txt3 += "FLAT";
    if (renderMode == SMOOTH_SHADE)
      txt3 += "SMOOTH";
      if (renderMode == WIREFRAME)
      txt3 += "WIREFRAME";
    }
    else
    {
      txt3 += "-";
    }
    float vol = revolver.getSolid().volume;
    if (vol > 1000000)
    {
      vol /= 1000000;
      vol = round(vol*100.0)/100.0;;
      txt4 += vol + "M";
    }
    else if (vol > 1000)
    {
      vol /= 1000;
      vol = round(vol*100.0)/100.0;;
      txt4 += vol + "K";
    }
    else
    {
      txt4 += revolver.getSolid().volume; 
    }
    
    fill(black);
    text(txt1, 12, 25);
    text(txt2, 12, 40);
    text(txt3, 12, 55);
    text(txt4, 12, 70);  
  }
}
