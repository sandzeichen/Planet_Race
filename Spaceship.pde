class Spaceship {
  float x, y, dx, dy; //position and change in position
  float e = 0.1; //easing towards mouse
  float a; //angle of rotation
 
  //initialize spaceship
  Spaceship(float x0, float y0, float a0) {
    x=x0;
    y=y0;
    a=a0;
  }
 
  //draw spaceship that eases toward and rotates depending on mouse position
  void draw() {
    dx = (mouseX-x)*e;
    dy = (mouseY-y)*e;
    x+=dx;
    y+=dy;
    
    //rotate coordinates about spaceship position depending on how far left or right of the mouse the spaceship is,
    //then return to normal coordinates
    pushMatrix();
    a = radians(mouseX-x);
    translate(x, y);
    rotate(a);
    fill(255);
    ellipse(0, 6, 10, 10);
    fill(5, 120, 255);
    ellipse(0, 0+1, 25, 15);
    fill(10,5, 70);
    arc(0, 0, 15, 15, -PI, 0);
    ellipse(0, 0, 15, 5);
    popMatrix();
  }
}

