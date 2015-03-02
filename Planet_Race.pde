import ciid2015.exquisitdatacorpse.*;
import oscP5.*;
import netP5.*;

//Hello!
//hello, hello
NetworkClient mClient;
ArrayList planetsList;
StringList people;
HashMap<String, Integer> peopleActivity;

// Stars and spaceship
int n = 400; //store number of stars
float t, dt; //angle for oscillation of sun brightness
Star[] stars = new Star[n]; //create array with n=200 stars
Spaceship spaceship = new Spaceship(mouseX, mouseY, 0); //create UFO

// Presets for the planets and orbits
int[] planetOffset = {300,135,45,225,300,300,300};
int[] planetRadius = {20,15,30,40,20,30,10};
color[] planetColor = {#99FFEE,#3399FF,#EE9922,#55EE33,#FF005A,#9120F1,#1665F6};
float[] orbitRadiusX = {80,160,220,320,420,520,620};
float[] orbitRadiusY = {85,166,232,335,422,535,622};
float[] initialOrbitSpeed = {2.4,1.7,2,2.75,1.75,2.75,1.75};
float[] newOrbitSpeed = new float[7];
boolean[] orbitPathVisible = {true,true,true,true,true,true,true};
int[] stroke = {2,2,3,3,4,4,5};
float[] activityLevelPlanets = {10,10,10,10,10,10,10};
boolean[] activePlanet = {true,true,true,true,true,true,true};

float[] prevActivityLevel = {0,0,0,0,0,0,0};
float[] currActivityLevel = {0,0,0,0,0,0,0};

// Counter for number of planets and max number allowed
int maxNumber = 7;
int counter = 0;

// Timer
int savedTime;
int timer = 1000;

void setup() {
  size(800, 800, P2D);
  people = new StringList();
  peopleActivity = new HashMap<String, Integer>();
  planetsList = new ArrayList();

  //make loop up to length of stars array to create multiple stars
  for (int k = 0; k < stars.length; k++) {
    stars[k] = new Star();
  }
  
  mClient = new NetworkClient(this, "192.168.1.227", "planets");
  savedTime = millis();   
}

void draw() {
  background(0);
  saveFrame("frames/####.png");
  
    //draw and update each star
  for (int n=0; n<stars.length; n++) {
    stars[n].update();
    stars[n].draw();
  }
  
  //draw spaceship from spaceship class
  spaceship.draw();
  
  translate(width/2, height/3);
  //rotateX(radians(55));
   
  //draw sun's glow, oscillating brightness of area outside sun and use loop to create gradient for transparency
  for (float s=75; s<100; s++) {
    fill(sin(t)*255, 250*((90-s)/25));
    ellipse(0, 0, s, s);
    dt=radians(0.03);
    t += dt;
  }
  
  // Drawing the Sun
  noStroke();
  fill(255,255,0);
  ellipse(0,0,60,60);  
  
  int passedTime = millis() - savedTime;
  if (passedTime > timer) {
    println("1 seconds passed!");
    savedTime = millis();
    
    for (int i = 0; i < planetsList.size(); i++) {
      Planet planet = (Planet) planetsList.get(i);
      prevActivityLevel[i] = planet.activityLevel;
    }
  }
  
  // Set velocity based on network activity
    for (int i=0; i< planetsList.size (); i++) {
      Planet planet = (Planet) planetsList.get(i);
      
      if(prevActivityLevel[i] == planet.activityLevel ||  prevActivityLevel[i] > planet.activityLevel) {
        if(planet.activityLevel != 0 || planet.activityLevel > 0) planet.activityLevel -= 1;
      }
      
      /*
      if(planet.activityLevel > 200) {
        planet.activityLevel = 1;
      } */
      
      float m = map(planet.activityLevel, 10, 500, 1, 50);
      newOrbitSpeed[i] = m;      
      
      println("previous:" + prevActivityLevel[i] + "current: " + currActivityLevel[i] + "actual: " + planet.activityLevel);
      println(m);
    }

  // Drawing the planets 
  
  for (int i=0; i < planetsList.size(); i++) {
    Planet planet = (Planet) planetsList.get(i);
    if(planet.activityLevel == 0) {
      planet.orbit(orbitRadiusX[i],orbitRadiusY[i],initialOrbitSpeed[i],orbitPathVisible[i],stroke[i]);
    } else if(activePlanet[i] == false) {
      // Remove planet
      people.remove(i);
      planetsList.remove(i);
    } else {
      planet.orbit(orbitRadiusX[i],orbitRadiusY[i],newOrbitSpeed[i],orbitPathVisible[i],stroke[i]);
    }
  }    
    saveFrame("frames/####.png");
}

// This can be removed later on
void keyPressed() {
  if(key == 'a' && counter < maxNumber) {
    String name = "test"+counter;
    createPlanet(name);
    counter++;
  } 
}

// Creates a planet
void createPlanet(String name) {
  if(people.hasValue(name) == true) {
    println("Allready created!");
  } else {
    println("Will add a planet");
    int planetNr = planetsList.size();
    Planet planet = new Planet(planetOffset[planetNr], planetRadius[planetNr], planetColor[planetNr], name);
    planetsList.add(planet);
    people.append(name);
  }  
}

// Gets a mouse click from the network, calls createPlanet
void receive(String name, String tag, float x) {
  //println(name);
  if(tag.equals("random") || tag.equals("mouseClick")) {
    if(counter < maxNumber) {
      createPlanet(name);
      counter++;
    } 
  }
}

// Method to recieve network activity 
void receive(String name, String tag, float x, float y, float z) {
  // Accept any activity from any user, except time 
  if(name.equals("time") == false) {
    if(people.hasValue(name) == true) {
      int c = peopleActivity.get(name); 
      peopleActivity.put(name,c+1);
      getPlanet(name).activityLevel += 1;
    } else {
      peopleActivity.put(name,1);
      getPlanet(name).activityLevel = 1;
    }
  }
  
  //println("max: " + getMaxValue(), "lowest: " + getLowestValue());
}

// Setters and getters for a planet object
Planet getPlanet(String name) {
  Planet temp = null;
  for (int i=0; i<planetsList.size (); i++) {
    Planet planet = (Planet) planetsList.get(i);
    if(planet.name.equals(name)) {
      temp = planet;
    }
  }    
  return temp;
}

int getMaxValue() {
  int max = 0;
  for (int i=0; i<planetsList.size (); i++) {
    Planet planet = (Planet) planetsList.get(i);
    if(planet.activityLevel > max) {
      max = planet.activityLevel;
    }
  }     
  return max;
}

int getLowestValue() {
  int low = 1000000;
  for (int i=0; i<planetsList.size (); i++) {
    Planet planet = (Planet) planetsList.get(i);
    if(planet.activityLevel < low) {
      low = planet.activityLevel;
    }
    
  }     
  return low;
  
}
