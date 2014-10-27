String endPoint = "http://intotheokavango.org/api/timeline?date=20140817&types=TYPE&days=18&types=ambit_geo&types=image";

float lat;
float lon;
float alt;

int counter = 0;


PVector[] geo;
PImage webImg;
String[] urls;

void setup(){
 size(720, 480, P3D);
 smooth();
 frameRate(60);
 loadGeo();
}

void draw(){
  background(120);
  
  plotGeo(counter);
  
  if(counter<geo.length-1){
    counter++;
  }
  else {
  counter = 0;
  }
  
}

void loadGeo(){
 JSONObject j = loadJSONObject(endPoint);
 JSONArray features = j.getJSONArray("features");
 geo = new PVector[features.size()];
 urls = new String[features.size()];
 
 for(int i = 0; i < features.size(); i++){
  JSONObject f = features.getJSONObject(i);
  
  //Properties
  JSONObject prop = f.getJSONObject("properties");
  //URL
  String url = "http://intotheokavango.org" + prop.getString("url");
  //DateTime
  String date = prop.getString("DateTime");
  //ID
  int id = f.getInt("id");
  //Geometry
  JSONObject geom = f.getJSONObject("geometry");
  //GPS Coordinates
  JSONArray coords = geom.getJSONArray("coordinates");
  lat = coords.getFloat(0);
  lon = coords.getFloat(1);
  alt = coords.getFloat(2);
  
  //Populate Arrays
  geo[i] = new PVector(lat, lon, alt);
  urls[i] = url;
  
 }

}

void plotGeo(int i){
  float minLat = 22.37151;
  float maxLat = 23.514925;
  float minLon = 19.025002;
  float maxLon = 19.92904;
  
  float border = 50;
  
  webImg = loadImage(urls[i]);
  webImg.filter(GRAY);
  tint(250, 200, 0);
  
  //Draw Background (Pics)
  image(webImg, 0, 0, width, height);
  
 
  fill(255);
  stroke(255);
  strokeWeight(3);
  noFill();
  
  //Draw Path
  beginShape();
  for(int j = 0; j < geo.length; j++){
    
    curveVertex(
    map(geo[j].x, minLat, maxLat, border, width-border), 
    map((geo[j].y*-1), minLon, maxLon, border, height-border)
    );

  }
  endShape();
    
  noStroke();
  fill(255,0,0);
  
  //Moving Dot
  ellipse(
    map(geo[i].x, minLat, maxLat, border, width-border), 
    map((geo[i].y*-1), minLon, maxLon, border, height-border),
    10, 10);

  fill(255);  
  
  //Starting Point
  ellipse(
    map(geo[0].x, minLat, maxLat, border, width-border),
    map((geo[0].y*-1), minLon, maxLon, border, height-border),
    10, 10);
    
  
  //Ending Point
  ellipse(
    map(geo[764].x, minLat, maxLat, border, width-border),
    map((geo[764].y*-1), minLon, maxLon, border, height-border),
    10, 10);

}
