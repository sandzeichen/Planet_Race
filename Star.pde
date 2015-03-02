class Star {
  float x, y; //position
  float r; //radius
  float t, dt; //oscillation
 
  //initialize star at random coordinates, with these radii and frequencies of oscillating brightness
  Star() {
    x=random(width);
    y=random(height);
    r=random(2, 4);
    t=random(2*PI);
    dt=radians(random(0.1, 2));
  }
 
  //update the value inside sin() to change brightness between 0 and 255
  //(pt. 2 of assignment)
  void update () {
    t += dt;
  }
 
  //draw star
  void draw() {
    fill(255*sin(t));
    ellipse(x, y, r, r);
  }
}
