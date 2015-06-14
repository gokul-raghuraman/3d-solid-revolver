//**************************** global variables ****************************
float dz = 0; 
float rx = -0.06 * TWO_PI;
float ry = -0.04 * TWO_PI;
Boolean center = true;
pt F = P(0, 0, 0);  
pt O = P(100, 100, 0);
pt selectedPoint = P(0, 0, 0);
pt pickedPoint = P(0, 0, 0);

pt viewer = P(0, 0, 0);
PImage hatchImage;

int MouseX;
int MouseZ;

int fps = 30;

GUIManager guiManager;
//**************************** initialization ****************************
void setup()
{
  size(600, 600, P3D);
  noSmooth();
  frameRate(fps);
  guiManager = new GUIManager(); 
//  A.declare();
//  B.declare();

  hatchImage = loadImage("hatch_small.png");
  ((PGraphics3D)g).textureWrap(Texture.REPEAT);
  
  travis = loadImage("pics/travis.png");
  adam = loadImage("pics/adam.jpg");
  gokul = loadImage("pics/gokul.jpg");
  rohan = loadImage("pics/rohan.JPG");
  
}
//**************************** display current frame ****************************
void draw()
{
  float fov = PI / 3.0;
  float cameraZ = (height / 2.0) / tan(fov / 2.0);
  background(white);
  if (guiManager.view == guiManager.VIEW_3D)
  {
    pushMatrix();
    camera(0, 0, cameraZ, 0, 0, 0, 0, 1, 0);
    lights();
    translate(0, 0, dz);
    rotateX(rx); 
    rotateY(ry);
    rotateX(PI / 2);
    if(center)
      translate(-F.x,-F.y,-F.z);
    
    viewer = viewPoint();
    guiManager.displayGrid(10000, 0);
    guiManager.displayAxes(50);
    guiManager.renderSpine();
    if (guiManager.renderMode == guiManager.WIREFRAME)
    {
      guiManager.renderSolidWireframe();
    }
    selectedPoint = pick3D(mouseX, mouseY);
    
    if (mousePressed)
      guiManager.showSelectedPoint();
    
    guiManager.renderSolid();
    popMatrix();
  }
  
  else if (guiManager.view == guiManager.VIEW_2D)
  {
    pushMatrix();
    translate(width / 2, height);
    rotateX(PI / 2);
    strokeWeight(10);
    selectedPoint = pick3D(mouseX, mouseY);
    MouseX = int(mouseX - width / 2);
    MouseZ = int(height - mouseY);
    strokeWeight(10);
    stroke(black);
    guiManager.displayAxes(50);
    guiManager.renderSpine();
    guiManager.renderLoops();
    guiManager.renderControlPoints(); //adam
    popMatrix();
  }
  
  else if (guiManager.view == guiManager.ANIM_2D)
  {
    pushMatrix();
    translate(width / 2, height);
    rotateX(PI / 2);
    guiManager.displayAxes(50);
    guiManager.animateLoop2D();
    guiManager.renderSpine();
    popMatrix();
  }
  
  else if (guiManager.view == guiManager.ANIM_3D)
  {
    pushMatrix();
    camera(0, 0, cameraZ, 0, 0, 0, 0, 1, 0);
    translate(0, 0, dz);
    lights();
    rotateX(rx); 
    rotateY(ry);
    rotateX(PI / 2);
    if(center)
      translate(-F.x,-F.y,-F.z);
  
    guiManager.displayGrid(10000, 0);
    guiManager.displayAxes(50);
    selectedPoint = pick3D(mouseX, mouseY);
    guiManager.renderSolidOutline();
    guiManager.animateLoop3D();
    
    if (mousePressed)
      guiManager.showSelectedPoint();
    guiManager.renderSpine();
    popMatrix();
  }
  
  guiManager.displayOverlay(); 
  displayOverlay();
}
