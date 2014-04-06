PImage mapImage;
Table locationTable;
int rowCount;

Table dataTable;
Table nameTable;
float dataMin = -10;
float dataMax = 10;

float closestDist;
String closestText;
float closestTextX;
float closestTextY;

Integrator[] interpolatiors;

void setup() {
  size(640, 400);
  mapImage = loadImage("map.png");
  
  locationTable = new Table("locations.tsv");
  //行数はグローバルに保存しておく
  rowCount = locationTable.getRowCount();
  
  dataTable = new Table("random.tsv");
  
  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = dataTable.getFloat(row, 1);
    interpolators[row] = new Integrator(initialValue);
  }
  
  nameTable = new Table("names.tsv");
  
  PFont font = loadFont("Verdana-12.vlw");
  textFont(font);
  
  smooth();
  noStroke();

}

void draw() {
  background(0);
  image(mapImage, 0, 0);
  
  closestDist = MAX_FLOAT;
  
  //位置ファイルの行をループして取得
  for (int row = 0; row < rowCount; row++) {
    String abbrev = dataTable.getRowName(row);
    float x = locationTable.getFloat(abbrev, 1);
    float y = locationTable.getFloat(abbrev, 2);
    drawData(x, y, abbrev);
  }
  
  if (closestDist != MAX_FLOAT) {
    fill(0);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
  }
}

void keyPressed() {
  if (key == ' ') {
    updateTable();
  }
}

void updateTable() {
  dataTable = new Table("http://benfry.com/writing/map/random.cgi");
}

void drawData(float x,float y, String abbrev) {
  float value = dataTable.getFloat(abbrev, 1);
  float radius = 0;
  
  if (value >= 0) {
    float a = map(value, 0, dataMax, 0, 255);
    radius = map(value, 0, dataMax, 1.5, 15);
    fill(#333366, a);
  } else {
    float a = map(value, 0, dataMax, 0, 255);
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(#EC5166, a);
  }
  ellipseMode(RADIUS);
  ellipse(x, y, radius, radius);
  
  float d = dist(x, y, mouseX, mouseY);
  if (d < radius+2 && d < closestDist) {
    closestDist = d;
    String name = nameTable.getString(abbrev, 1);
    closestText = name + " " + nf(value,0,2);
    closestTextX = x;
    closestTextY = y - radius - 4;
  }
}

