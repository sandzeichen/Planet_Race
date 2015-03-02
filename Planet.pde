class Planet {
  float planetOffset;
  float planetRadius;
  color surface;
  float angle;
  boolean isPathVisible;
  String name;
  int activityLevel = 0;

  Planet(float planetOffset, float planetRadius, color surface, String name) {
    angle = planetOffset;
    this.planetRadius = planetRadius;
    this.surface = surface;
    this.name = name;
  }

  void orbit(float ellipticalRadiusX, float ellipticalRadiusY, float orbitSpeed, boolean isPathVisible, int stroke) {
    // draw ellipse first, so it's under the planet
    if (isPathVisible) {
      drawOrbit(ellipticalRadiusX, ellipticalRadiusY, stroke);
    }

    float px = cos(radians(angle))*ellipticalRadiusX;
    float py = sin(radians(angle))*ellipticalRadiusY;
    fill(surface);
    noStroke();
    ellipse(px, py, planetRadius*2, planetRadius*2);
          
    angle += orbitSpeed;
  }

  void drawOrbit(float ellipticalRadiusX, float ellipticalRadiusY, int stroke) {
    stroke(255, 50);
    strokeWeight(stroke); 
    float angle=0;
    for (int i=0; i<360; i++) {
      point(cos(radians(angle))*ellipticalRadiusX, 
      sin(radians(angle++))*ellipticalRadiusY);
    }
  }
}

