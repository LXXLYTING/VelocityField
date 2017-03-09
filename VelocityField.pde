PImage img;
ArrayList<PVector> List = new ArrayList<PVector>();
ArrayList<PVector> Copy = new ArrayList<PVector>();

ArrayList<PVector> PosA = new ArrayList<PVector>();
ArrayList<PVector> PosV = new ArrayList<PVector>();
ArrayList<PVector> VelA = new ArrayList<PVector>();
ArrayList<PVector> PosC = new ArrayList<PVector>();
ArrayList<PVector> PosC_Col = new ArrayList<PVector>();


ArrayList <Slider> slidersList;
Slider sliderArea1, sliderArea2, sliderArea3, spdForce;
boolean onPressed;
boolean drawV;

PVector v;
PVector mask;
PVector vell;
PVector _area = new PVector(0, 0, 0);


int flag = 1;


float _spd = 100.0f;
float _acc = 40.0f;
float _spd2 = 100.0f;

float area1;
float area2;
float area3;


int rect_wid = 130;

void setup() {
  size(600, 600);
  img=loadImage("VelField.jpg");

  img.resize(600, 600);
  tint(255, 200);
  image(img, 0, 0);


  float wd = width;
  float ht = height;
  for (int i=0; i<wd; i++)
  {
    for (int j=0; j<ht; j++)
    {

      int imgColor = get(i, j);  
      int R = (imgColor >> 16) & 0xFF;  
      int G = (imgColor >> 8) & 0xFF; 
      int B = imgColor & 0xFF; 
      v = new PVector(R, G, B);

      List.add(v);
      Copy.add(v);
    }
  }

  initSliders();

  area1 = sliderArea1.value;
  area2 = sliderArea2.value;
  area3 = sliderArea3.value;

  //color c = get(25, 25);
  drawV = true;

  //int imgColor = get(25, 25);  
  //int R = (imgColor >> 16) & 0xFF;  
  //int G = (imgColor >> 8) & 0xFF; 
  //int B = imgColor & 0xFF; 
  //println(B);
}



void draw() {

   
  updateSliders();
  area1 = sliderArea1.value;
  area2 = sliderArea2.value;
  area3 = sliderArea3.value;

  _spd = spdForce.value;
  _spd2 = spdForce.value;

  int wd, ht;
  wd = width;
  ht = height;

  ////////////////////////////////////////Change Color///////////////////////////////////////////////////



  for (int i=0; i<wd; i++)
  {
    for (int j=0; j<ht/3; j++)
    {
      setTheColor(i, j, area1);
    }
  }


  for (int i=0; i<wd; i++)
  {
    for (int j=ht/3; j<2*ht/3; j++)
    {
      setTheColor(i, j, area2);
    }
  }

  for (int i=0; i<wd; i++)
  {
    for (int j=2*ht/3; j<ht; j++)
    {
      setTheColor(i, j, area3);
    }
  }

  ////////////////////////Move two circle///////////////////////////////////////////////////////////////
  for (int i=0; i<PosV.size(); i++) {
    PVector vel = getVec2fInterpolateAt(PosV.get(i));
    vel.limit(300.0f);
    PVector movement = PVector.mult(vel, _spd*0.05);
    PVector pos2 = PVector.add(PosV.get(i), movement);

    if (pos2.x<=0) {
      pos2.x =width;
    }
    if (pos2.x>width) {
      pos2.x =0;
    }
    if (pos2.y<=0) {
      pos2.x =height;
    }
    if (pos2.y>height) {
      pos2.x =0;
    }

    (PosV.get(i)).x = pos2.x;
    (PosV.get(i)).y = pos2.y;
  }

  for (int i=0; i<PosA.size(); i++) {
    PVector acc = getVec2fInterpolateAt(PosA.get(i));
    acc.limit(300.0f);
    PVector deltaVel = PVector.mult(acc, _acc*0.05);
    PVector vel2 = PVector.add(VelA.get(i), deltaVel);
    PVector pos2 = PVector.add(PosA.get(i), vel2.mult(_spd2*0.05));
    vel2.limit(3.0f);
    if (pos2.x<=0) {
      pos2.x =width;
    }
    if (pos2.x>width) {
      pos2.x =0;
    }
    if (pos2.y<=0) {
      pos2.x =height;
    }
    if (pos2.y>height) {
      pos2.x =0;
    }
    (VelA.get(i)).x = vel2.x;
    (VelA.get(i)).y = vel2.y;
    (PosA.get(i)).x = pos2.x;
    (PosA.get(i)).y = pos2.y;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (PosC.size() > 0) {
    for (int i=0; i<wd; i++)
    {
      for (int j=0; j<ht; j++)
      {
        for (int k=0; k<PosC.size(); k++) {

          if ( i>(PosC.get(k)).x && i<((PosC.get(k)).x +rect_wid) && j>(PosC.get(k)).y && j<((PosC.get(k)).y +rect_wid)) {
            (List.get(height*i+j)).x =(PosC_Col.get(height*i+j)).x;
            (List.get(height*i+j)).y =(PosC_Col.get(height*i+j)).y;
            (List.get(height*i+j)).z =(PosC_Col.get(height*i+j)).z;

            color cr = color((PosC_Col.get(height*i+j)).x, (PosC_Col.get(height*i+j)).y, (PosC_Col.get(height*i+j)).z);
            set(i, j, cr);
          }
        }
      }
    }
  }


  ////////////////////////Draw two circle/////////////////////////////////  
  for (int i=0; i<PosV.size(); i++) {
    drawCircleFillColor(PosV.get(i), 30.0, color(135, 206, 250, 160));
  }

  for (int i=0; i<PosA.size(); i++) {
    drawCircleFillColor(PosA.get(i), 20.0, color(255, 127, 80, 160));
  }

  ////////////////////////Draw Vector/////////////////////////////////
  if (drawV) {
    for (int i=15; i<=wd; i+=20) {
      for (int j=15; j<=ht; j+=20) {
        pushMatrix();
        PVector pos =new PVector (i, j);
        PVector vel = getVec2fInterpolateAt(pos);

        PVector vel_l = PVector.mult(vel, 12.0f);
        PVector v1 = PVector.sub(pos, vel_l);
        PVector v2 = PVector.add(pos, vel_l);

        float d = dist(v1.x, v1.y, v2.x, v2.y)*0.7;
        PVector drawV = new PVector(v2.x-v1.x, v2.y-v1.y);
        translate(pos.x, pos.y);
        drawVector(drawV, d);
        popMatrix();
      }
    }
  }

  ////////////////////////Draw the Rect///////////////////////////////// 
  for (int i=0; i<PosC.size(); i++) {
    pushMatrix();
    noFill();
    stroke(153);
    strokeWeight(3);
    rect((PosC.get(i)).x, (PosC.get(i)).y, rect_wid, rect_wid); 
    popMatrix();
  }

  fill(255);
  rect(470, 25, 125, 110);
  drawSliders();
}


void mousePressed() {  

  if (mouseButton==LEFT) {
    mask = new PVector(mouseX, mouseY);
    vell =  new PVector(0, 0);


    if (!((mouseX < 595)&& (mouseX > 470) && (mouseY >25) && (mouseY <135))) {
      if (random(0.0f, 1.0f)<0.5f) {
        PosV.add(mask);
      } else {
        PosA.add(mask);
        VelA.add(vell);
      }
    }

    for (int i=0; i<slidersList.size(); i++) {
      Slider slider = slidersList.get(i);
      if (mouseX>slider.pos.x && mouseX<slider.pos.x+slider.w && mouseY>slider.pos.y && mouseY<slider.pos.y+slider.h) {
        slider.active = true;
        return;
      }
    }

    onPressed = true;
  }  
  if (mouseButton==RIGHT)
  {
    mask = new PVector(mouseX, mouseY);
    PosC.add(mask);
    PosC_Col.clear();
    for (int i=0; i<width; i++)
    {
      for (int j=0; j<height; j++)
      {

        float R = (List.get(height*i+j)).x;
        float G = (List.get(height*i+j)).y;
        float B = (List.get(height*i+j)).z;
        v = new PVector(R, G, B);

        PosC_Col.add(v);
      }
    }
  }
}

void mouseReleased() {

  for (int i=0; i<slidersList.size(); i++) {
    Slider slider = slidersList.get(i);
    slider.active = false;
  }

  onPressed = false;
}

void keyPressed() {

  if (key=='z'||key=='Z') {       
    drawV = false;
  }
  if (key=='x'||key=='X') {       
    drawV = true;
  }
  if (key=='c'||key=='C') {


    if (flag == 1) {
      _area.x = sliderArea1.value;
      _area.y = sliderArea2.value;
      _area.z = sliderArea3.value;

      sliderArea1.setValue(0.0, 0.0, 1.0);
      sliderArea2.setValue(0.0, 0.0, 1.0);
      sliderArea3.setValue(0.0, 0.0, 1.0);
      updateSliders();
      drawSliders();
      flag = 0;
    }
  }
  if (key=='v'||key=='V') {  

    flag =1;

    sliderArea1.setValue(_area.x, 0.0, 1.0);
    sliderArea2.setValue(_area.y, 0.0, 1.0);
    sliderArea3.setValue(_area.z, 0.0, 1.0);

    updateSliders();
    drawSliders();
  }
}

/////////////////////////drawVector/////////////////////////
void drawVector(PVector vecotr, float len) {
  pushMatrix();
  float arrowsize = 4;
  //stroke(0);
  stroke(0, 135);
  rotate(vecotr.heading());

  strokeWeight(1.5);
  //fill(255);
  line(0, 0, -len, 0);
  line(0, 0, len, 0);
  line(len, 0, len-arrowsize, +arrowsize/2);
  line(len, 0, len-arrowsize, -arrowsize/2);
  popMatrix();
}
///////////////////////////////////////getVec2fInterpolateAt/////////////////////////////////////////////////
PVector getVec2fInterpolateAt(PVector pos) {
  PVector pos_lu = new PVector(floor(pos.x), floor(pos.y));
  PVector pos_ru= new PVector(ceil(pos.x), floor(pos.y));
  PVector pos_ld= new PVector(floor(pos.x), ceil(pos.y));
  PVector pos_rd= new PVector(ceil(pos.x), ceil(pos.y));

  PVector vlu = new PVector(norm(getRGB(pos_lu).x, 0, 255)-0.5, norm(getRGB(pos_lu).y, 0, 255)-0.5);
  PVector vru = new PVector(norm(getRGB(pos_ru).x, 0, 255)-0.5, norm(getRGB(pos_ru).y, 0, 255)-0.5);
  PVector vld = new PVector(norm(getRGB(pos_ld).x, 0, 255)-0.5, norm(getRGB(pos_ld).y, 0, 255)-0.5);
  PVector vrd = new PVector(norm(getRGB(pos_rd).x, 0, 255)-0.5, norm(getRGB(pos_rd).y, 0, 255)-0.5);

  float a = pos.x - floor(pos.x);
  float b = pos.y - floor(pos.y);

  PVector vl1 = PVector.mult(vld, b);
  PVector vl2 = PVector.mult(vld, (1.0f-b));
  PVector vl = PVector.add(vl1, vl2);

  PVector vr1 = PVector.mult(vrd, b);
  PVector vr2 = PVector.mult(vrd, (1.0f-b));
  PVector vr = PVector.add(vr1, vr2);

  PVector v1 = PVector.mult(vr, a);
  PVector v2 = PVector.mult(vl, (1.0f-a));
  PVector v = PVector.add(v1, v2);

  return v;
}
////////////////////// get PVector's RGB////////////////////////
PVector getRGB(PVector pos) {

  int imgColor = get((int)pos.x, (int)pos.y);  
  int R = (imgColor >> 16) & 0xFF;  
  int G = (imgColor >> 8) & 0xFF;  
  int B = imgColor & 0xFF; 

  PVector getRedGreen = new PVector(R, G, B);
  return getRedGreen;
}
//////////////////////////Draw PosA&PosV///////////////////////
void drawCircleFillColor(PVector pos, float Radius, color cr)
{
  pushStyle();
  fill(cr);
  //stroke(1);
  noStroke();
  ellipse(pos.x, pos.y, Radius, Radius);     
  popStyle();
}
////////////////////////////////////////////////////////////////
void setTheColor(int i, int j, float area_num)
{
  (Copy.get(height*i+j)).x= norm((List.get(height*i+j)).x, 0, 255)-0.5;
  (Copy.get(height*i+j)).y= norm((List.get(height*i+j)).y, 0, 255)-0.5;
  (Copy.get(height*i+j)).z= norm((List.get(height*i+j)).z, 0, 255)-0.5;
  (Copy.get(height*i+j)).rotate(1.0/frameRate*area_num);

  (List.get(height*i+j)).x =((Copy.get(height*i+j)).x+0.5)*255;
  (List.get(height*i+j)).y =((Copy.get(height*i+j)).y+0.5)*255;

  color cr = color((List.get(height*i+j)).x, (List.get(height*i+j)).y, (List.get(height*i+j)).z);
  set(i, j, cr);
}
//////////////////////Slider////////////////////////////////////
void initSliders() {

  slidersList = new ArrayList<Slider>();
  sliderArea1 = new Slider(530, 30, 60, 20);
  sliderArea1.setTag("Area 1:");
  sliderArea1.setValue(0.3, 0.0, 1.0);
  sliderArea2 = new Slider(530, 55, 60, 20);
  sliderArea2.setTag("Area 2:");
  sliderArea2.setValue(0.6, 0.0, 1.0);
  sliderArea3 = new Slider(530, 80, 60, 20);
  sliderArea3.setTag("Area 3:");
  sliderArea3.setValue(0.9, 0.0, 1.0);
  spdForce = new Slider(530, 105, 60, 20);
  spdForce.setTag("Force3:");
  spdForce.setValue(100, 50, 200);

  slidersList.add(sliderArea1);
  slidersList.add(sliderArea2);
  slidersList.add(sliderArea3);
  slidersList.add(spdForce);
}

void updateSliders() {
  for (int i=0; i<slidersList.size(); i++) {
    Slider slider = slidersList.get(i);
    if (slider.active) {
      slider.update();
      break;
    }
  }
}

void drawSliders() {
  for (int i=0; i<slidersList.size(); i++) {
    Slider slider = slidersList.get(i);
    slider.display();
  }
}