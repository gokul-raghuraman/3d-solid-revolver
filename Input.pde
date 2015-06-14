void keyPressed()
{
  if (key == 'c' || key == 'C')
    center = true;
  
  if (key == '1' || key == '!')
  {
    guiManager.revolveLoops();
    guiManager.toggleView3D();
  }
  
  if (key == '3' || key == '#')
  {
    guiManager.revolveLoops();
    guiManager.toggleAnimModes();
  }
  
  if (key == 't' || key == 'T')
  {
    guiManager.toggleShadingMode();
  }
  
  if (key == 'w' || key == 'W')
  {
    guiManager.toggleWireframeMode();
  }
    
  if (key == 'g' || key == 'G')
  {
    guiManager.toggleDisplayGrid();
  }
  
  if (key == '7')
  {
    guiManager.setOffsetType(guiManager.NORMAL_OFFSET);
  }
  
  if (key == '8')
  {
    guiManager.setOffsetType(guiManager.RADIAL_OFFSET);
  }
  
  if (key == '9')
  {
    guiManager.setOffsetType(guiManager.BALL_OFFSET);
  }
  
  if(key=='?') 
    scribeText=!scribeText; 
  
  
}

void mouseMoved() 
{
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='s') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
}
  
void mouseWheel(MouseEvent event)
{
  dz -= event.getAmount();
}

void mouseDragged()
{
  
  if (guiManager.view == guiManager.VIEW_3D || guiManager.view == guiManager.ANIM_3D)
  {
    if (keyPressed && key=='f')
    {
      F.sub(ToIJ(V((float)(mouseX - pmouseX), (float)(mouseY - pmouseY), 0)));
    }
    
    if (keyPressed && (key == 'a' || key == 'A'))
    {
      guiManager.updateSolidAlpha(mouseX - pmouseX + pmouseY - mouseY);
    }
    
    if (!keyPressed)
    {
      guiManager.registerSelection(selectedPoint);
      guiManager.bendSpine();
      
      O.add(ToIJ(V((float)(mouseX - pmouseX),(float)(mouseY - pmouseY), 0))); 
    }
  }
  
  if (guiManager.view == guiManager.VIEW_2D)
  {
    if(keyPressed && (key == 'r' || key == 'R')) //adam
    {
      guiManager.ChangeRadius();
    }
    if (!keyPressed) //adam
    {
      guiManager.movePoint();
    }
  }
  
  if (guiManager.view == guiManager.ANIM_2D)
  {
    if (keyPressed && (key == 'a' || key == 'A'))
    {
      guiManager.updateSolidAlpha(mouseX - pmouseX + pmouseY - mouseY);
    }
  }
}

void mousePressed()
{
  if (guiManager.view == guiManager.VIEW_3D)
  {
    guiManager.registerSelection(selectedPoint);
  }
  
  if (guiManager.view == guiManager.VIEW_2D)
  {
    if(keyPressed && key=='r') //adam
    {
      guiManager.setSelected();
    }
  }
}

void mouseReleased()
{
  if (guiManager.view == guiManager.VIEW_3D)
  {
    guiManager.endBendSpine();
  }
  
  if (guiManager.view == guiManager.VIEW_2D) //adam
  {
    guiManager.endMovePoint();
    guiManager.endChangeRadius();
  }
}

void mouseClicked()
{
    if (guiManager.view == guiManager.VIEW_2D)//adam
  {
    if (key == 'a' || key == 'A')
    {
      //guiManager.addLoopPoint(1, MouseX, 0, MouseZ);
      guiManager.addControlPoint(1, MouseX, 0, MouseZ); //adam
    }
      
    if (key == 'b' || key == 'B')
      //guiManager.addLoopPoint(2, MouseX, 0, MouseZ);
      guiManager.addControlPoint(2, MouseX, 0, MouseZ); //adam
  }
  
}
