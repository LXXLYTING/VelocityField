class Slider{
  
  PVector pos, nameTagPos, valueTagPos;
  float w, h, innerW, value, valueMin, valueMax;
  boolean active;
  String nameTag, valueTag;
  
  Slider(float x, float y, float w, float h){
    pos = new PVector(x, y);
    nameTagPos = new PVector(x-10, y);
    valueTagPos = new PVector(x+w*.5, y);
    this.w = w;
    this.h = h;
  }
  
  void setTag(String nameTag){
    this.nameTag = nameTag;
  }
  
  void setValue(float value, float valueMin, float valueMax){
    this.value = value;
    this.valueMin = valueMin;
    this.valueMax = valueMax;
    
    valueTag = str(round(value*100.0)/100.0);
    
    innerW = map(value, valueMin, valueMax, 0, w);
  }
  
  void update(){
    innerW = constrain(mouseX-pos.x, 0, w);
    value = map(innerW, 0, w, valueMin, valueMax);
    valueTag = str(round(value*100.0)/100.0);
  }
  
  void display(){
    noStroke();
    fill(0);
    rect(pos.x, pos.y, w, h);
    fill(100);
    rect(pos.x, pos.y, innerW, h);
    
    fill(255);
    rect(pos.x-10-textWidth(nameTag), pos.y, 10+textWidth(nameTag), h);
    
    fill(0);
    textAlign(RIGHT, TOP);
    text(nameTag, nameTagPos.x, nameTagPos.y);
    
    fill(255);
    textAlign(CENTER, TOP);
    text(valueTag, valueTagPos.x, valueTagPos.y);
  }
}