void showtangent (Ctrl_Pts A)
{
  vec tangent;
  pt P;
  if(A.G.size() >1)
  {
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    show(A.G.get(0), 60, tangent);
    for(int i = 1; i<A.G.size()-1; i++)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      show(A.G.get(i), 60, tangent);
    }
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    show(A.G.get(A.G.size()-1), 60, tangent);
  }
}

void shownormal (Ctrl_Pts A) //help!
{
  vec tangent;
  pt P;
  vec normal;
  vec I = U(1, 0, 0);
  vec K = U(0, 0, 1);
  float a = -PI/2; //angle
  
  if(A.G.size() >1)
  {
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    normal = R(tangent, a, I, K);
    show(A.G.get(0), A.R.get(0), normal);
    for(int i = 1; i<A.G.size()-1; i++)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      normal = R(tangent, a, I, K);
      show(A.G.get(i), A.R.get(i), normal);
    }
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    normal = R(tangent, a, I, K);
    show(A.G.get(A.G.size()-1), A.R.get(A.G.size()-1), normal);
  }
}


Loop orthogonaloffset (Ctrl_Pts A)
{
  Loop offset;
  offset = new Loop();
  vec tangent;
  pt P;
  pt Pd;
  vec normal;
  vec I = U(1, 0, 0);
  vec K = U(0, 0, 1);
  float a = -PI/2; //angle
  
  if(A.G.size() >1)
  {
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(0), A.R.get(0), normal);
    offset.addPoint(Pd);
    for(int i = 1; i<A.G.size()-1; i++)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      normal = R(tangent, a, I, K);
      Pd = P(A.G.get(i), A.R.get(i), normal);
      offset.addPoint(Pd);
    }
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(A.G.size()-1), A.R.get(A.G.size()-1), normal);
    offset.addPoint(Pd);
    
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(A.G.size()-1), -A.R.get(A.G.size()-1), normal);
    offset.addPoint(Pd);
    for(int i = A.G.size()-2; i>0; i--)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      normal = R(tangent, a, I, K);
      Pd = P(A.G.get(i), -A.R.get(i), normal);
      offset.addPoint(Pd);
    }
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(0), -A.R.get(0), normal);
    offset.addPoint(Pd);
  }
  
  return offset;
}



Loop orthogonaloffset (Ctrl_Pts A, Loop offset)
{
  vec tangent;
  pt P;
  pt Pd;
  vec normal;
  vec I = U(1, 0, 0);
  vec K = U(0, 0, 1);
  float a = -PI/2; //angle
  
  if(A.G.size() >1)
  {
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(0), A.R.get(0), normal);
    offset.G.set(0, Pd);
    for(int i = 1; i<A.G.size()-1; i++)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      normal = R(tangent, a, I, K);
      Pd = P(A.G.get(i), A.R.get(i), normal);
      offset.G.set(i, Pd);
    }
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(A.G.size()-1), A.R.get(A.G.size()-1), normal);
    offset.G.set(A.G.size()-1, Pd);
    
    tangent = U(A.G.get(A.G.size()-2), A.G.get(A.G.size()-1));
    P = P(A.G.get(A.G.size()-1), tangent);
    tangent = U(A.G.get(A.G.size()-1), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(A.G.size()-1), -A.R.get(A.G.size()-1), normal);
    offset.G.set(A.G.size(), Pd);
    for(int i = A.G.size()-2; i>0; i--)
    {
      tangent = U(A.G.get(i-1), A.G.get(i+1));
      P = P(A.G.get(i), tangent);
      tangent = U(A.G.get(i), P);
      normal = R(tangent, a, I, K);
      Pd = P(A.G.get(i), -A.R.get(i), normal);
      offset.G.set(A.G.size()+A.G.size()-1-i, Pd);
    }
    tangent = U(A.G.get(0), A.G.get(1));
    P = P(A.G.get(0), tangent);
    tangent = U(A.G.get(0), P);
    normal = R(tangent, a, I, K);
    Pd = P(A.G.get(0), -A.R.get(0), normal);
    offset.G.set(A.G.size()+A.G.size()-1, Pd);
  }
  
  return offset;
}

Loop radialoffset(Ctrl_Pts Spline )
{
  float dist; //total distance between R1 and R2
  float r1;
  float r2;
  float d_prime;
  vec tangent;
  pt P;
  vec normal;
  vec I = U(1, 0, 0);
  vec K = U(0, 0, 1);
  float a = -PI/2; //angle
  vec nd;
  pt Pd;
  Loop offset;
  offset = new Loop();
  
  if(Spline.G.size() > 1)
  {
    dist = d(Spline.G.get(0),Spline.G.get(1));
    r1 = Spline.R.get(0);
    r2 = Spline.R.get(1);
    d_prime = -(r1 -r2)/(dist); //need to multiply by d(Spline.G.get(prev_index), Spline.G.get(j))?
    tangent = U(Spline.G.get(0), Spline.G.get(1));
    P = P(Spline.G.get(0), tangent);
    tangent = U(Spline.G.get(0), P); //first point's tangent
    normal = R(tangent, a, I, K); //first point's normal
    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0))))); //for very first point
    Pd = P(Spline.G.get(0), Spline.R.get(0), nd);
    offset.addPoint(Pd);
    for(int i = 1; i<Spline.G.size()-1; i++)
    {
      dist = d(Spline.G.get(i),Spline.G.get(i+1));
      r1 = Spline.R.get(i);
      r2 = Spline.R.get(i+1);
      d_prime = -(r1 -r2)/(dist);
      tangent = U(Spline.G.get(i), Spline.G.get(i+1));
      P = P(Spline.G.get(i), tangent);
      tangent = U(Spline.G.get(i), P);
      normal = R(tangent, a, I, K);
      nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0)))));
      Pd = P(Spline.G.get(i), Spline.R.get(i), nd);
      offset.addPoint(Pd);
    }
    dist = d(Spline.G.get(Spline.G.size()-2),Spline.G.get(Spline.G.size()-1));
    r1 = Spline.R.get(Spline.G.size()-2);
    r2 = Spline.R.get(Spline.G.size()-1);
    d_prime = -(r1 -r2)/(dist);
    tangent = U(Spline.G.get(Spline.G.size()-2), Spline.G.get(Spline.G.size()-1));
    P = P(Spline.G.get(Spline.G.size()-1), tangent);
    tangent = U(Spline.G.get(Spline.G.size()-1), P);
    normal = R(tangent, a, I, K);
    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0)))));
    Pd = P(Spline.G.get(Spline.G.size()-1), Spline.R.get(Spline.G.size()-1), nd);
    offset.addPoint(Pd);
    
    dist = d(Spline.G.get(Spline.G.size()-2),Spline.G.get(Spline.G.size()-1));
    r1 = Spline.R.get(Spline.G.size()-2);
    r2 = Spline.R.get(Spline.G.size()-1);
    d_prime = -(r1 -r2)/(dist);
    tangent = U(Spline.G.get(Spline.G.size()-2), Spline.G.get(Spline.G.size()-1));
    P = P(Spline.G.get(Spline.G.size()-1), tangent);
    tangent = U(Spline.G.get(Spline.G.size()-1), P);
    normal = R(tangent, PI/2 , I, K);
    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0)))));
    Pd = P(Spline.G.get(Spline.G.size()-1), Spline.R.get(Spline.G.size()-1), nd);
    offset.addPoint(Pd);
    for(int i = Spline.G.size()-2; i>0; i--)
    {
      dist = d(Spline.G.get(i),Spline.G.get(i+1));
      r1 = Spline.R.get(i);
      r2 = Spline.R.get(i+1);
      d_prime = -(r1 -r2)/(dist);
      tangent = U(Spline.G.get(i), Spline.G.get(i+1));
      P = P(Spline.G.get(i), tangent);
      tangent = U(Spline.G.get(i), P);
      normal = R(tangent, PI/2, I, K);
      nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0)))));
      Pd = P(Spline.G.get(i), Spline.R.get(i), nd);
      offset.addPoint(Pd);
    }
    dist = d(Spline.G.get(0),Spline.G.get(1));
    r1 = Spline.R.get(0);
    r2 = Spline.R.get(1);
    d_prime = -(r1 -r2)/(dist); //need to multiply by d(Spline.G.get(prev_index), Spline.G.get(j))?
    tangent = U(Spline.G.get(0), Spline.G.get(1));
    P = P(Spline.G.get(0), tangent);
    tangent = U(Spline.G.get(0), P); //first point's tangent
    normal = R(tangent, PI/2, I, K); //first point's normal
    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0))))); //for very first point
    Pd = P(Spline.G.get(0), Spline.R.get(0), nd);
    offset.addPoint(Pd);
  }
  return offset;
}

Loop balloffset(Ctrl_Pts Spline )
{
  Loop offset1;
  offset1 = new Loop();
  Loop offset2;
  offset2 = new Loop();
 
  offset1 = orthogonaloffset(Spline);
  float dist; //total distance between R1 and R2
  float r1;
  float r2;
  float d_prime;
  vec tangent1;
  vec normal1;
  float dist1;
  float d_prime1;
  vec tangent;
  pt P;
  vec normal;
  vec I = U(1, 0, 0);
  vec K = U(0, 0, 1);
  float a = -PI/2; //angle
  vec nd;
  pt Pd;
  
  if(offset1.G.size() > 1)
  {
    tangent1 = U(Spline.G.get(0), Spline.G.get(1));
    normal1 = R(tangent1, a, I, K);
    dist1 = d(Spline.G.get(0), Spline.G.get(1));
    r1 = Spline.R.get(0);
    r2 = Spline.R.get(1);
    d_prime1 = -(r1 -r2)/(dist1);
    normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
    tangent = R(normal, PI/2, I, K);
    dist = d(offset1.G.get(0),offset1.G.get(1));
    d_prime = -(r1 -r2)/(dist); //need to multiply by d(Spline.G.get(prev_index), Spline.G.get(j))?
    nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal)); //for very first point
    Pd = P(offset1.G.get(0), Spline.R.get(0), nd);
    offset2.addPoint(Pd);

    for(int i = 5; i<(offset1.G.size()/2)-6; i++)
    {
      tangent1 = U(Spline.G.get(i-1), Spline.G.get(i+1));
      normal1 = R(tangent1, a, I, K);
      dist1 = d(Spline.G.get(i), Spline.G.get(i+1));
      r1 = Spline.R.get(i);
      r2 = Spline.R.get(i+1);
      d_prime1 = -(r1 -r2)/(dist1);
      normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
      tangent = R(normal, PI/2, I, K);
      dist = d(offset1.G.get(i),offset1.G.get(i+1));
      d_prime = -(r1 -r2)/(dist);
      nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal));
      Pd = P(offset1.G.get(i), Spline.R.get(i), nd);
      offset2.addPoint(Pd);
    }
//    dist = d(offset1.G.get((offset1.G.size()/2)-2),offset1.G.get((offset1.G.size()/2)-1));
//    r1 = Spline.R.get((offset1.G.size()/2)-2);
//    r2 = Spline.R.get((offset1.G.size()/2)-1);
//    d_prime = -(r1 -r2)/(dist);
//    tangent = U(offset1.G.get((offset1.G.size()/2)-2), offset1.G.get((offset1.G.size()/2)-1));
////    P = P(offset1.G.get((offset1.G.size()/2)-1), tangent);
////    tangent = U(offset1.G.get((offset1.G.size()/2)-1), P);
//    normal = R(tangent, a, I, K);
//    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0)))));
//    Pd = P(offset1.G.get((offset1.G.size()/2)-1), Spline.R.get((offset1.G.size()/2)-1), nd);
//    offset2.addPoint(Pd);
    tangent1 = U(Spline.G.get(Spline.G.size()-2), Spline.G.get(Spline.G.size()-1));
    normal1 = R(tangent1, a, I, K);
    dist1 = d(Spline.G.get(Spline.G.size()-2), Spline.G.get(Spline.G.size()-1));
    r1 = Spline.R.get(offset1.G.size()/2-2);
    r2 = Spline.R.get(offset1.G.size()/2-1);
    d_prime1 = -(r1 -r2)/(dist1);
    normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
    tangent = R(normal, PI/2, I, K);
    dist = d(offset1.G.get((offset1.G.size()/2)-2),offset1.G.get((offset1.G.size()/2)-1));
    d_prime = -(r1 -r2)/(dist);
    nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal));
    Pd = P(offset1.G.get((offset1.G.size()/2)-1), Spline.R.get((offset1.G.size()/2)-1), nd);
    offset2.addPoint(Pd);

    
    tangent1 = U(Spline.G.get(Spline.G.size()-1), Spline.G.get(Spline.G.size()-2));
    normal1 = R(tangent1, a, I, K);
    dist1 = d(Spline.G.get(Spline.G.size()-1), Spline.G.get(Spline.G.size()-2));
    r1 = Spline.R.get(Spline.G.size()-1);
    r2 = Spline.R.get(Spline.G.size()-2);
    d_prime1 = -(r1 -r2)/(dist1);
    normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
    tangent = R(normal, PI/2, I, K);
    dist = d(offset1.G.get((offset1.G.size()/2)),offset1.G.get((offset1.G.size()/2)+1));
    d_prime = -(r1 -r2)/(dist);
    nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal));
    Pd = P(offset1.G.get((offset1.G.size()/2)), Spline.R.get(Spline.G.size()-1), nd);
    offset2.addPoint(Pd);
//    dist = d(offset1.G.get((offset1.G.size()/2)),offset1.G.get((offset1.G.size()/2)+1));
//    r1 = Spline.R.get(Spline.G.size()-2); //0?
//    r2 = Spline.R.get(Spline.G.size()-1);
//    d_prime = -(r1 -r2)/(dist); //need to multiply by d(Spline.G.get(prev_index), Spline.G.get(j))?
//    tangent = U(offset1.G.get((offset1.G.size()/2)), offset1.G.get((offset1.G.size()/2)+1));
//    P = P(offset1.G.get((offset1.G.size()/2)), tangent);
//    tangent = U(offset1.G.get((offset1.G.size()/2)), P); //first point's tangent
//    normal = R(tangent, PI/2, I, K); //first point's normal
//    nd = (tangent.mul(-d_prime).add(normal.mul(sqrt(1-pow(d_prime,2.0))))); //for very first point
//    Pd = P(offset1.G.get((offset1.G.size()/2)), -Spline.R.get(Spline.G.size()-1), nd);
//    offset2.addPoint(Pd);
    for(int i = (offset1.G.size()/2)+5, j = Spline.G.size()-6; i<offset1.G.size()-6; i++, j--)
    {
      tangent1 = U(Spline.G.get(j+1), Spline.G.get(j-1));
      normal1 = R(tangent1, a, I, K);
      dist1 = d(Spline.G.get(j), Spline.G.get(j-1));
      r1 = Spline.R.get(j);
      r2 = Spline.R.get(j-1);
      d_prime1 = -(r1 -r2)/(dist1);
      normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
      tangent = R(normal, PI/2, I, K);
      dist = d(offset1.G.get(i),offset1.G.get(i+1));
      d_prime = -(r1 -r2)/(dist);
      nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal));
      Pd = P(offset1.G.get(i), Spline.R.get(j), nd);
      offset2.addPoint(Pd);
    }
    
    
    tangent1 = U(Spline.G.get(1), Spline.G.get(0));
    normal1 = R(tangent1, a, I, K);
    dist1 = d(Spline.G.get(1), Spline.G.get(0));
    r1 = Spline.R.get(1);
    r2 = Spline.R.get(0);
    d_prime1 = -(r1 -r2)/(dist1);
    normal = V(sqrt(pow(d_prime1,2.0)+1), A(V(-d_prime1, tangent1), normal1));
    tangent = R(normal, PI/2, I, K);
    dist = d(offset1.G.get(offset1.G.size()-2),offset1.G.get(offset1.G.size()-1));
    d_prime = -(r1 -r2)/(dist); //need to multiply by d(Spline.G.get(prev_index), Spline.G.get(j))?
    nd = A(V(-d_prime,tangent),V(sqrt(1-pow(d_prime,2.0)),normal)); //for very first point
    Pd = P(offset1.G.get(offset1.G.size()-1), Spline.R.get(0), nd);
    offset2.addPoint(Pd);
  }
  //println("size =" + offset2.G.size());
  return offset2;
}
