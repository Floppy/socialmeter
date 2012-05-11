FloatTable data;
float dataMin, dataMax;

int rowCount;
int columnCount;
int currentColumn = 1;

int peopleMin, peopleMax;
int[] people;

int myEnergy;
color columnColor;

float barWidth;

float plotX1, plotY1;
float plotX2, plotY2;

Integrator[] interpolators;

PImage[] oImages;

String apiUrl = "http://socialmeter.floppy.org.uk/users/3.csv";
//String apiUrl = "energydata.tsv";

int startTime;

void setup()
{
  size(800, 480);
  //size(screen.width, screen.height);
  //data = new FloatTable("energydata.tsv");
  data = new FloatTable(apiUrl);
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
  people = int(data.getRowNames());
  peopleMin = 0;
  peopleMax = people.length - 1;
  
  dataMin = 0;
  dataMax = data.getTableMax();
  
  oImages = new PImage[rowCount];
  
  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++)
  {
    float initialValue = data.getFloat(row, currentColumn);
    interpolators[row] = new Integrator(initialValue);
    interpolators[row].attraction = 0.1;  // Set lower than the default
    oImages[row] = loadImage(data.getRowImage(row));
    if(data.getRowOwner(row).equals("true") == true)
    {
      myEnergy = row;
    }
  }

  plotX1 = 20;
  plotX2 = width-20;
  plotY1 = 120;
  plotY2 = height;

  
  barWidth = ((plotX2-plotX1) / rowCount) - 10;
  
  startTime = millis();
}

void draw()
{
  background(0);
  
  for(int row = 0; row < rowCount; row++)
  {
    interpolators[row].update();
  }

  noStroke();
  fill(#5679C1);

  drawDataArea(currentColumn);
  drawOwnerImages(6);
  
  // Every 60 seconds, make a new request
  int now = millis();
  if (now - startTime > 5000)
  {
    getNewData();
    //println("Making request!");
    startTime = now;
  }
  noCursor();
}

void drawDataArea(int col)
{
  noStroke();
  rectMode(CORNERS);
  for(int row = 0; row < rowCount; row++)
  {
    if(data.isValid(row, col))
    {
      float value = interpolators[row].value;
      float x = map(row, peopleMin, peopleMax, plotX1+barWidth/2, plotX2-barWidth/2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      columnColor = (row == myEnergy) ? #FFFFFF : #5679C1;
      fill(columnColor);
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
}

void drawOwnerImages(int col)
{
  rectMode(CENTER);
  imageMode(CENTER);
  for(int row = 0; row < rowCount; row++)
  {
      String url = data.getRowImage(row);
      float x = map(row, peopleMin, peopleMax, plotX1+barWidth/2, plotX2-barWidth/2);
      columnColor = (row == myEnergy) ? #FFFFFF : #5679C1;
      fill(columnColor);
      rect(x, 60, 86.00, 86.00);
      image(oImages[row], x, 60, 80.00, 80.00);
  }
}

void getNewData()
{
  data = new FloatTable(apiUrl);
  rowCount = data.getRowCount();
  dataMax = 0.0f;
  for(int row = 0; row < rowCount; row++)
  {
    float value = data.getFloat(row, currentColumn);
    interpolators[row].target(value);
    if (dataMax < value) dataMax = value;
  }
}

void mousePressed()
{
  if(mouseY > height - 30)
  {
    exit();
  }
}
