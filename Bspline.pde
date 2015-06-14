Ctrl_Pts refine(Ctrl_Pts A) { //introduces new vertex in the middle of each edge
  Ctrl_Pts New;
  New = new Ctrl_Pts();
  New.G.add(A.G.get(0));
  New.G.add(A.G.get(0));
  New.G.add(A.G.get(0));
  New.G.add(A.G.get(0));
  New.G.add(A.G.get(0));
  if(A.G.size() > 1){
    for(int i = 1; i < A.G.size()-1; i++){
      New.G.add(A.G.get(i));
      New.G.add(P(A.G.get(i), A.G.get(i+1)));
    }
    New.G.add(A.G.get(A.G.size()-1));
    New.G.add(A.G.get(A.G.size()-1));
    New.G.add(A.G.get(A.G.size()-1));
    New.G.add(A.G.get(A.G.size()-1));
    New.G.add(A.G.get(A.G.size()-1));
  }
  
  return New;
}

Ctrl_Pts dual(Ctrl_Pts A) { //refine and then kill
  Ctrl_Pts New;
  New = new Ctrl_Pts();
  if(A.G.size() > 1) {
    for(int i = 0; i< A.G.size()-1; i++){
      New.G.add(P(A.G.get(i), A.G.get(i+1)));
    }
  }
  
  return New;
}

Ctrl_Pts quinticBspline(Ctrl_Pts A){
  Ctrl_Pts New;
  New = new Ctrl_Pts();
  New = refine(A);//adam
  New = dual(New);
  New = dual(New);
  New = dual(New);
  New = dual(New);
  return New;
}

pt findclosestpoint(pt A, Ctrl_Pts Spline)
{
  float dist = MAX_FLOAT;
  int bestIndex = -1;
  for(int i = 0; i < Spline.G.size(); i++)
  {
    if(dist == MAX_FLOAT)
    {
      bestIndex = i;
      dist = d(A,Spline.G.get(i));
    }
    if(d(A, Spline.G.get(i)) < d(A, Spline.G.get(bestIndex)))
    {
      bestIndex = i;
      dist = d(A, Spline.G.get(bestIndex));
    }
  }
  return Spline.G.get(bestIndex);
}

int findclosestpoint_index(pt A, Ctrl_Pts Spline)
{
  float dist = MAX_FLOAT;
  int bestIndex = -1;
  for(int i = 0; i < Spline.G.size(); i++)
  {
    if(dist == MAX_FLOAT)
    {
      bestIndex = i;
      dist = d(A,Spline.G.get(i));
    }
    if(d(A, Spline.G.get(i)) < d(A, Spline.G.get(bestIndex)))
    {
      bestIndex = i;
      dist = d(A, Spline.G.get(bestIndex));
    }
  }
  return bestIndex;
}

int pickClosest(pt M, Ctrl_Pts A, Ctrl_Pts Spline) { //adam
    int bestIndex=-1; 
    float dist = MAX_FLOAT;
    int value = -1;
    pt Center;
    for (int i=0; i<A.G.size(); i++) {
      if (dist == MAX_FLOAT)
      {
        bestIndex = findclosestpoint_index(A.G.get(i), Spline);
        value = i;
        dist = d(M,Spline.G.get(bestIndex));
      }
      if (d(M,findclosestpoint(A.G.get(i),Spline))<d(M,Spline.G.get(bestIndex)))
      {
        bestIndex=findclosestpoint_index(A.G.get(i), Spline);
        value = i;
        dist = d(M,Spline.G.get(bestIndex));
      }
    }
    return value;
  } 

void drawCircle(pt A, Ctrl_Pts Spline, float radius)
{
  pt Center;
  pushMatrix();
  rotateX(PI/2);
  translate(0,0,0);
  noFill();
  strokeWeight(1);
//  for(int i = 0; i<A.G.size(); i++)
//  {
    Center = findclosestpoint(A, Spline);
    ellipse(Center.x, Center.z, 2*radius, 2*radius);
//  }
  popMatrix();
}

void setSplineRadii(Ctrl_Pts A, Ctrl_Pts Spline){ //help!
  int index;
  int prev_index =0;
  float num_points; //number of points between index and previous index
  float dist; //total distance between R1 and R2
  float r1;
  float r2;
  
  if(A.G.size() > 1)
  {
    for(int i =0; i < A.G.size(); i++)
    {
      index = findclosestpoint_index(A.G.get(i), Spline);
      Spline.R.set(index, A.R.get(i));
    }
    for(int i =1; i < A.G.size(); i++)
    {
//      if(i == 0)
//      {
//        Spline.R.set(0, A.R.get(i));
//        Spline.R.set(1, A.R.get(i));
//        Spline.R.set(2, A.R.get(i));
//        Spline.R.set(3, A.R.get(i));
//        Spline.R.set(4, A.R.get(i));
//        prev_index = 4;
//      }
//      else if(i == A.G.size()-1)
//      {
//        Spline.R.set(Spline.G.size()-1, A.R.get(i));
//        Spline.R.set(Spline.G.size()-2, A.R.get(i));
//        Spline.R.set(Spline.G.size()-3, A.R.get(i));
//        Spline.R.set(Spline.G.size()-4, A.R.get(i));
//        Spline.R.set(Spline.G.size()-5, A.R.get(i));
//        index = Spline.G.size()-5;
//        num_points = index - prev_index +1;
//        r1 = Spline.R.get(prev_index);
//        r2 = Spline.R.get(index);
//        for(int j = prev_index; j < index+1; j++)
//        {
//          Spline.R.set(j, r1-(r1-r2)*(j/num_points));
//        }
//      }
//      else
//      {
        index = findclosestpoint_index(A.G.get(i), Spline);
        num_points = index - prev_index +1;
        dist = d(Spline.G.get(prev_index),Spline.G.get(index));
        r1 = Spline.R.get(prev_index);
        r2 = Spline.R.get(index);
        int k = 0;
        for(int j = prev_index; j < index+1; j++)
        {
          //Spline.R.set(j, r1-(r1-r2)*k/num_points);
          Spline.R.set(j, r1-(r1-r2)*d(Spline.G.get(prev_index), Spline.G.get(j))/dist);
          k++;
        }
        //println(index +"," + prev_index);
        prev_index = index;
//      }
    }
  }
}

void halfSplineRadii(Ctrl_Pts A, Ctrl_Pts Spline, float multiplier){ //help!
  int index;
  int prev_index =0;
  float num_points; //number of points between index and previous index
  float dist; //total distance between R1 and R2
  float r1;
  float r2;
  if(A.G.size() > 1)
  {
    for(int i =0; i < A.G.size(); i++)
    {
      index = findclosestpoint_index(A.G.get(i), Spline);
      Spline.R.set(index, A.R.get(i) * multiplier);
    }
    for(int i =1; i < A.G.size(); i++)
    {
        index = findclosestpoint_index(A.G.get(i), Spline);
        num_points = index - prev_index +1;
        dist = d(Spline.G.get(prev_index),Spline.G.get(index));
        r1 = Spline.R.get(prev_index);
        r2 = Spline.R.get(index);
        int k = 0;
        for(int j = prev_index; j < index+1; j++)
        {
          //Spline.R.set(j, r1-(r1-r2)*k/num_points);
          Spline.R.set(j, r1-(r1-r2)*d(Spline.G.get(prev_index), Spline.G.get(j))/dist);
          k++;
        }
        //println(index +"," + prev_index);
        prev_index = index;
    }
  }
}
