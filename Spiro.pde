import com.hamoid.*;

VideoExport videoExport;
PrintWriter output;

int radius = 150;
float rotatexrnd = random(-0.01, 0.1);
float rotateyrnd = random(-0.01, 1);
float anglernd = (int)random(90, 360); 
float srnd = random(5, 5);
float trnd = random(0.1, 15);
int colornd = (int)random(0, 255);
int colornd2 = (int)random(0, 255);
float e, zoom;
boolean record=false;

int mls = millis();
int mnt = minute();
int hr = hour();
int day = day();
int mnth = month();
int year = year();

int rotation = 1;
int x, y;
boolean followCursor=false;

void setup() {
  fullScreen(P3D);
  background(0);
  stroke(colornd, colornd2, 255);
  zoom=1.0;
  noCursor();
  x=width/2;
  y=height/2;
} 

void mouseWheel(MouseEvent event) {
  e = event.getCount();
  if (e==0) {
    zoom=1.0;
  } else if (e>0) {
    zoom-=0.1;
  } else if (e<0) {
    zoom+=0.1;
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    record = !record;
    videoExport = new VideoExport(this, "spir_" + day + "." + mnth + "." + year + "." + "_" + hr + mnt + mls + ".mp4");
    videoExport.startMovie();
    if (key == ESC) {
      videoExport.endMovie();  
      exit();
    }
  }
}

void draw() {
  background(0);
  if (followCursor==true) {
    x=mouseX;
    y=mouseY;
  }
  translate(x, y);
  if (colornd>127) {
    rotateY(frameCount * rotatexrnd);
    rotateX(frameCount * rotateyrnd);
    rotation = 2;
  } else {
    rotateY(frameCount * rotateyrnd);
    rotateX(frameCount * rotatexrnd);
  }
  scale(zoom);

  float s = 0;
  float t = 0;
  float lastx = 0; 
  float lasty = 0;
  float lastz = 0;

  float randradians; 
  float randradiant; 

  if (colornd>127) {
    randradians = 1;
  } else {
    randradians = 0;
  }

  if (rotatexrnd>0.25) {
    randradiant = 1;
  } else {
    randradiant = 0;
  }

  while (t < anglernd) {
    s += srnd;  
    t += trnd;  
    if (randradians==1) {
      randradians=radians(s);
    } else {
      randradians=radians(t);
    }
    if (randradiant==1) {
      randradiant=radians(s);
    } else {
      randradiant=radians(t);
    }

    float thisx = 0 + (radius * cos(radians(s)) * cos(randradians));
    float thisy = 0 + (radius * sin(radians(s)) * sin(randradiant));
    float thisz = 0 + (radius * cos(radians(t)));

    if (lastx != 0) {
      if (colornd>0&&colornd<40) {
        line(thisx, thisy, thisz, lastx, lasty, lastz);
        noFill();
        ellipse(2, 2, 55, 55);
      } else if (colornd>=40&&colornd<120) {
        line(thisx, thisy, thisz, lastx+50, -lasty, lastz+100);
      } else {
        line(thisx, thisy, thisz, lastx, lasty, lastz);
        line(thisx, thisy, thisz, lastx+50, -lasty, lastz+100);
        if (colornd<200) {
          line(s, t, 200, 50, 290, 220);
        } else {
          line(s, t, s, t, s, t);
        }
      }
    }
    lastx = thisx; 
    lasty = thisy; 
    lastz = thisz;
  }

  if (record==true) {
    output = createWriter("params_" + day + "." + mnth + "." + year + "." + "_" + hr + mnt + mls + ".txt");
    output.println("*****************************");
    output.println("color:" + "\t\t" + "("+colornd+","+colornd2+",255"+")");
    output.println("rotatexrnd:" + "\t" + rotatexrnd);
    output.println("rotateyrnd:" + "\t" + rotateyrnd);
    output.println("rotation:" + "\t" + rotation);
    output.println("anglernd:" + "\t" + anglernd);
    output.println("srnd:" + "\t\t" + srnd);
    output.println("trnd:" + "\t\t" + trnd);
    output.println("randradians:" + "\t" + randradians);
    output.println("randradiant:" + "\t" + randradiant);
    output.println("*****************************");
    output.flush();
    output.close();

    videoExport.saveFrame();
  }
}

void mouseClicked() {
  followCursor=!followCursor;
}
