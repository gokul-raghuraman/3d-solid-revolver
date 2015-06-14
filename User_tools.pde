boolean scribeText=true;
int pictureCounter=0;
PImage travis, gokul, adam, rohan; 
String title ="CS6491 | Fall 2014 | Final Project : \nSolid of Revolution", 
       name1 ="Travis Hint", name2 = "Gokul Raghuraman", name3 = "Rohan Somni", name4 = "Adam Yang",
       menu="?: (show/hide) help      ~: (start/stop) recording frames for movie",
       guide1 = "Controls:",
       guide2 = "'1': Toggle 2D/3D",
       guide3 = "\n2D Controls:",
       guide4 = "  'a' + click in left panel / 'b' + click in right panel to create shapes.",
       guide5 = "\n3D Controls:",   
       guide6 = "   click and drag on plane to bend/rotate the axis.",
       guide7 = "   's' + click/drag to zoom.",
       guide8 = "   'space' + drag to rotate camera.";
       //guide4 = "'D' : Delete mode: click on a uni- or bi-valent vertex to delete it.",
       //guide5 = "'F' : Display all the face outlines.",
       //guide6 = "'C' : Display all the corners.",
       //guide7 = "'H' : Display all the half-edges.",
       //guide8 = "'A' : Show face indices and areas.",
       //guide9 = "'V' : Show vertex indices.",
       //guide10 = "'P' : Print the internal data structure.",
       //guide = guide1 + '\n' + guide2 + '\n' + guide3 + '\n' + guide4 + '\n' + guide5 + '\n' + guide6 + '\n' + guide7 + '\n' + guide8 + '\n' + guide9 + '\n' + guide10;
       //guide = guide1 + '\n' + guide2 + '\n' + guide3 + '\n' + guide4 + '\n' + guide5 + '\n' + guide6 + '\n' + guide7 + '\n' + guide8;
//*****Capturing Frames for a Movie*****
boolean filming=false;  // when true frames are captured in FRAMES for a movie
int frameCounter=0;     // count of frames captured (used for naming the image files)

void checkIfFilming()
{
 if(filming)
  {
    saveFrame("FRAMES/"+nf(frameCounter++,4)+".png");
    fill(red);
    stroke(red);
    ellipse(width - 20, height - 20, 5, 5);
  }  
}

//********Display Header/Footer*********
void displayOverlay()
{
  if(scribeText)
   displayHeader();
 //if(scribeText && !filming) 
   //displayFooter();
}

void displayHeader()
{
  fill(0); 
  text(title, 10, 100); 
  text(name1, width - 25.0 * name1.length(), 40);
  text(name2, width - 14.5 * name2.length(), 120);
  text(name4, width - 8.5 * name2.length(), 40);
  text(name3, width - 5.0 * name2.length(), 120);
  noFill();
  image(travis, width - travis.width/3 - 220, 45, travis.width/3,travis.height/3);  
  image(gokul, width - travis.width/3 - 150, 45, travis.width/3,travis.height/3);
  image(adam, width - travis.width/3 - 80, 45, travis.width/3,travis.height/3);
  image(rohan, width - travis.width/3 - 10, 45, travis.width/3,travis.height/3);
}

void displayFooter()
{  
  //scribeFooter(guide, 8);
  scribeFooter(menu, 0);
}

void scribeFooter(String s, int i)  
{
  fill(0); 
  text(s, 10, height - 10 - i * 20); 
  noFill();
}
