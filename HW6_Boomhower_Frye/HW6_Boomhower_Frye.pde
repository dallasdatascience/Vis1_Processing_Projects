/****************************************************************************************** //<>//
 Title         : EarthQuakes
 Created By    : Chris Boomhower, Alex Frye
 Create Date   : 6/24/2017
 Assignment    : MSDS6390 - HW 6
 Instructions  : N/A
 Resources     : https://stackoverflow.com/questions/14329691/covert-latitude-longitude-point-to-a-pixels-x-y-on-mercator-projection
 https://www.openstreetmap.org/export#map=3/55.18/-108.02
 
 ******************************************************************************************/


float mapWidth    = 1162; // don't mess with me!
float mapHeight   = 976; // don't mess with me!
PVector tlCornerRaw, brCornerRaw;   // Map corners raw in WebMercator coordinates.
PVector tlCorner, brCorner;         // Map corners converted in WebMercator coordinates.

Table table;
float[] mag = {};
float[] depth = {};
float[] latitude = {};
float[] longitude = {};
float[] time = {};
String[] place = {};
int[] sig = {};
int readRows = 0;

void setup() {
  PImage backgroundMap = loadImage("data/USA.jpg");

  size(1162, 976);
  backgroundMap.resize(1162, 976);
  background(backgroundMap);

  frameRate(10);

  //define zoom lat/long

  tlCornerRaw = new PVector(-168.4, 71.75); // don't mess with me!
  brCornerRaw = new PVector(-66.27, 18.48); // don't mess with me!

  tlCorner = getxy(tlCornerRaw.x, tlCornerRaw.y); 
  brCorner = getxy(brCornerRaw.x, brCornerRaw.y);
}

void draw() {
  int rows = checkTable();

  if (rows - readRows > 0) earthquakes();

  //float latitude    = random(brCornerRaw.y, tlCornerRaw.y);    //19.8968;   //41.145556; // (φ) // y
  //float longitude   = random(tlCornerRaw.x, brCornerRaw.x);    //-155.5828; //-73.995;   // (λ) // x

  for (int i = 0; i < mag.length; i++) { //<>//
    float delta = 0;
    if (i > 0) {
      delta = time[i] - time[i-1];
    }
    println(delta);
    
    //WOULD LIKE TO USE DELTA IN COUNTER ARRAY TO CONTROL RATE OF INCOMING CIRCLES
    pingQuake(longitude[i], latitude[i], mag[i], sig[i]);
  }
}