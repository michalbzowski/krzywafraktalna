import controlP5.*;
import papaya.*;

private int iterations = 5;
private Controls controls;
private ControlPoint cp1, cp2, cp3;
//private float[] p1, p2, p3;
private ArrayList<float[]> points = new ArrayList<float[]>();
private float u = 0.25,v = 0.25, a = 0.5, b = 0.5, c = 0.25, d = 0.5;
 
private int fontSize = 16; 
private int program = 1;

private ControlP5 cp5;
private RadioButton r;

void setup() {
  background(0);
  size(600, 400);
  textFont(createFont("Georgia", fontSize));
  colorMode(HSB);
   
  setupStartPoints();
//  p1 = new float[]{100, 300, 1};
//  p2 = new float[]{200, 100, 1};
//  p3 = new float[]{300, 300, 1};
  setupControlPoints();
//  cp1 = new ControlPoint(p1[0], p1[1], this);
//  cp2 = new ControlPoint(p2[0], p2[1], this);
//  cp3 = new ControlPoint(p3[0], p3[1], this);
  
  
  createGui();

  
  
}

private void setupStartPoints(){
  points = new ArrayList<float[]>();
  points.add( new float[]{100, 300, 1} );
  points.add( new float[]{200, 100, 1} );
  points.add( new float[]{300, 300, 1} );
}

private void setupControlPoints(){
  controls = new Controls(this);
  if(this.points != null){
    for(float[] f : points){
      controls.addControlPoint(f[0], f[1]);
    }
  } 
}

void draw(){
  background(0);
  updatePoints();
  drawBackgroundFigure();
  try{
    switch(program){
      case 1: uvprogram(); 
        break;
      case 2: abcdprogram();
        break;
    }
 }catch(Exception e){
  println(e.getMessage());
  println("Uwaga! Punkty nie mogą być współliniowe"); 
 }
 //drawInfoOnScreen();
 drawMenuOnScreen();
}

private void uvprogram(){
  subdivison(this.u, this.v,iterations);
}

private void abcdprogram(){
 subdivison(this.a, this.b, this.c, this.d, iterations); 
}

private void updatePoints(){
  controls.drawControlPoints();
  for(int i = 0; i < points.size(); i++){
    points.get(i)[0] = controls.getPoint(i).x;
    points.get(i)[1] = controls.getPoint(i).y ;
  } 
}

private void drawBackgroundFigure(){
  pushStyle();
  noStroke();
  fill(123,2,210,50);
  if(points.size() >=3){
    beginShape(TRIANGLE_STRIP);
    for(float[] f : points){
      vertex(f[0],f[1]);
    }
    endShape();
  }
  popStyle();
}

private void subdivison(float a, float b, float c, float d, int n){
 float[][] B1 = new float[][]{
  { 1, 0, 0},
  { a, 1 - a, 0},
  { c, d, 1 - ( c + d )}
 };
 
 float[][] B2 = new float[][]{
  { c, d, 1 - (c + d)},
  { 0, b, 1 - b },
  { 0, 0, 1 } 
 };

 subdivisioncont(n, B1, B2);
}

private void subdivison(float u, float v, int n) {
  float[][] B1 = new float[][] { 
    { 1-u, u, 0.0}, 
    { v, 1-v, 0.0}, 
    { 0.0, 1-u, u}
  };


  float[][] B2 = new float[][] {
    {v, 1-v, 0.0 }, 
    {0.0, 1-u, u}, 
    {0.0, v, 1-v}
  };

  subdivisioncont(n, B1, B2);
}

private void subdivisioncont(int n, float[][] B1, float[][] B2){
  float[][] P = new float[ points.size() ][];
  for(int i = 0; i < points.size(); i++){
    P[i] = points.get(i);
  }  
                                                       // println("P"); printArray(P);
  float[][] inverseP =  Mat.inverse( P );              // println("INVERSEP"); printArray(inverseP);
 
  float[][] tempF1 = Mat.multiply( inverseP , B1 ); // println("tempF1"); printArray(tempF1);
  float[][] F1 = Mat.multiply( tempF1, P);          // println("ARRAY F1"); printArray(F1);
  
  
  float[][] tempF2 = Mat.multiply( inverseP, B2 );
  float[][] F2 = Mat.multiply( tempF2 , P);

  float[] f1 = new float[] { 
    F1[0][0], F1[1][0], F1[0][1], F1[1][1], F1[2][0], F1[2][1]
  };
  float[] f2 = new float[] { 
    F2[0][0], F2[1][0], F2[0][1], F2[1][1], F2[2][0], F2[2][1]
  };

  float[][] f = new float[][] {
    f1, f2
  };
  IFS(n, f, convertToList( P ));
}

private ArrayList<float[]> convertToList(float[][] P){
  ArrayList<float[]> list = new ArrayList<float[]>(); 
  for(int i = 0; i < P.length; i++){
   list.add( new float[]{P[i][0], P[i][1]});
 } 
 return list;
}

private void IFS(int n, float[][] ListTrans, ArrayList<float[]> polygon) {
  //printPolygon(polygon);
  ArrayList<ArrayList<float[]>> seqpoly = new ArrayList<ArrayList<float[]>>();
  seqpoly.add(polygon);
  for (int j = 0; j < n; j++) {
    ArrayList<ArrayList<float[]>> s = new ArrayList<ArrayList<float[]>>(); //float[seqpoly.size()][2];
    for (int i = 0; i < ListTrans.length; i++) {
      for (int k = 0; k < seqpoly.size(); k++) {
        //println("seqpoly: "+ seqpoly.get(k));
        s.add( TransPolygon(ListTrans[i], seqpoly.get(k)) );
      }
    }
    seqpoly =  s;
  }
  plot(seqpoly);
}

private ArrayList<float[]> polygonListToPolygon(ArrayList<ArrayList<float[]>> s){
  ArrayList<float[]> list = new ArrayList<float[]>();
  for(ArrayList<float[]> l : s){
    for(float[] f : l){
    list.add(f);
    }
 } 
 return list;
}

private ArrayList<float[][]> convertArrayToList(float[][] polygon){
 ArrayList<float[][]> newList = new ArrayList<float[][]>();
  for(int i = 0; i < polygon.length; i++){
  newList.add(new float[][]{{polygon[i][0]}, {polygon[i][1]}});
 } 
 return newList;
}

private ArrayList<float[]> TransPolygon(float t[], ArrayList<float[]> polygon) {
  ArrayList<float[]> newPolygon = new ArrayList<float[]>();
  for (int i = 0; i < polygon.size(); i++) {
    float[] newPoint = TransPoint( t, polygon.get(i) );
    newPolygon.add( newPoint );
  }
  return newPolygon;
}

private float[] TransPoint(float t[], float[] p) {
  return new float[] {
    t[0] * p[0] + t[1] * p[1] + t[4], 
    t[2] * p[0] + t[3] * p[1] + t[5]
  };
}

private void plot(ArrayList<ArrayList<float[]>> seqpolygon){
 color(12,23,34);
 stroke(255,255,255);
 for(ArrayList<float[]> polygon : seqpolygon){
  // for(float[] f : polygon){
    for(int i = 0; i < polygon.size() - 1; i++){
      float[] p1 = polygon.get(i);
      float[] p2 = polygon.get(i+1);
      line(p1[0], p1[1], p2[0], p2[1]);
   }
 } 
}

void keyPressed(){
 switch(key){
  case 'i': iterationsUp();
    break;
  case 'k': iterationsDown();
    break;
  case 'u': uUp();
    break;
  case 'j': uDown();
    break;
  case 'f': vUp();
    break;
  case 'v': vDown();
    break;
  case '1': program = 1;
    break;
  case '2': program = 2;
    break;
 }
}
 
 
 private void iterationsUp(){
  iterations++; 
 }
 
 private void iterationsDown(){
  if(iterations > 0){
    iterations--;   
  } 
 }
 
 private void uUp(){
   u+= 1/100.0f;
 }
 
 private void uDown(){
   u-=0.01f;
 }
 
 private void vUp(){
   v+=0.01f;
 }
 
 private void vDown(){
   v-=0.01f;
 }
 
 private void drawInfoOnScreen(){
   text("Iterations: " + iterations, 10, level(0));
   text("Parameter U: " + u, 10, level(1));
   text("Parameter V: " + v, 10, level(2));
   text("Program: " + program, 10, level(3));
 }
 
 private int level(int n){
  return n*fontSize + fontSize; 
 }
 
 private void createGui(){
    cp5 = new ControlP5(this);
   // add a vertical slider
  cp5.addSlider("u")
     .setPosition(460,40)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(u); 
     
     cp5.addSlider("v")
     .setPosition(510,40)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(v);
     
      cp5.addSlider("a")
     .setPosition(460,160)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(a); 
     
     cp5.addSlider("b")
     .setPosition(510,160)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(b);
     
      cp5.addSlider("c")
     .setPosition(460,280)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(c); 
     
     cp5.addSlider("d")
     .setPosition(510,280)
     .setSize(20,100)
     .setRange(0,1)
     .setValue(d);
     
     cp5.addSlider("iterations")
     .setPosition(16,16)
     .setSize(100,20)
     .setRange(0,10)
     .setValue(iterations)
     .setNumberOfTickMarks(11);
 }
 

 
 private void drawMenuOnScreen(){
   line(450, 0, 450, height); 
   if(program == 1){
     pushStyle();
     fill(222,222,34);
     rect(450,0,width-450,155);
     noFill();
     popStyle();
   }
   if(program ==2){
     pushStyle();
     fill(222,222,34);
     rect(450,156,width-450,height- 155);
     noFill();
     popStyle();
   }
 }

