/****************************************************************************************** //<>// //<>//
 Title         : 3d Equalizer
 Created By    : Chris Boomhower, Alex Frye
 Create Date   : 8/13/2017
 Assignment    : MSDS6390 - HW 10
 Description   : This visualization is a 3D music equilizer. It is by no coincidence that the
                 visual system resembles a galaxy filled with planets, orbital rings, and colorful
                 light sources. Three small "suns", each red, green, and blue in color, render at
                 random locations with each new project code run and illuminate the darkness,
                 shedding light on the rhythmic, sychronized beat of the cosmos.
                 
                 The visualization includes various venues of interactivity. Firstly, moving the
                 mouse cursor across the window causes the various equalizer rings to rotate to the
                 user's liking. Secondly, holding down the left mouse button while moving the
                 cursor moves the camera about the center planet and ring. Thirdly, clicking the
                 right mouse button toggles the current song's title, author, and album details,
                 which also pulsate to the beat of the music. If a different song is desired, its
                 mp3 may be added to the project's data folder and the sound file name updated in
                 the project's setup() method.
                 
 Resources     : https://processing.org/tutorials/p3d/
                 https://github.com/ddf/Minim
 ******************************************************************************************/

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer soundFile;
AudioMetaData meta;
FFT fft;
Equalizer eqMain;
Equalizer[] eqBackground;


int numEqBackground = 100;
int fc = 0;

float[] randomWPoint = new float[3];
float[] randomHPoint = new float[3];
float[] randomZPoint = new float[3];

boolean metaDetails = true;

void setup()
{
  size(500, 500, P3D);
  noStroke();
  
  minim = new Minim(this);
  soundFile = minim.loadFile("Ratatat - Wildcat.mp3", 1024);
  meta = soundFile.getMetaData();

  // loop the file
  soundFile.loop();
  //soundFile.mute();

  fft = new FFT( soundFile.bufferSize(), soundFile.sampleRate());
  fft.logAverages(60, 5);

  eqMain = new Equalizer(width/2);
  eqBackground = new Equalizer[numEqBackground];

  for (int i=0; i<numEqBackground; i++) {
    eqBackground[i] = new Equalizer(random(width/50, width/5), i%2, eqMain.diameter);
  }

  for (int i = 0; i<randomWPoint.length; i++) {
    randomWPoint[i] = random(0, width);
    randomHPoint[i] = random(0, height);
    randomZPoint[i] = random(-400, 400);
  }
}

void draw() {
  background(35);

  if (mousePressed & mouseButton == LEFT) camera(mouseX, mouseY, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  else if (mousePressed & mouseButton == RIGHT & metaDetails == false & fc > 30){
    metaDetails = true;
    fc = 0;
  }
  else if (mousePressed & mouseButton == RIGHT & metaDetails == true & fc > 30){
    metaDetails = false;
    fc = 0;
  }
  
  if (metaDetails) {
    pushMatrix();
    translate(0, 0, fft.getAvg(1)/2);
    text("Title: " + meta.title(), width/2, 0.25*height);
    text("Author: " + meta.author(), width/2, 0.25*height + 25); 
    text("Album: " + meta.album(), width/2, 0.25*height + 50);
    popMatrix();
  }

  for (int i = 0; i<randomWPoint.length; i++) {
    pushMatrix();
    stroke(0);
    translate(randomWPoint[i], randomHPoint[i], randomZPoint[i]);
    noStroke();
        
    switch(i) {
    case 0:
      fill(0,0,255);
      sphere(25);
        break;
    case 1:
      fill(0,255,0);
      sphere(25);
        break;
    case 2:
      fill(255,0,0);
      sphere(25);
        break;
    }
    
    translate(0,0,30);
    fill(0);
    textAlign(CENTER);
    switch(i) {
    case 0:
      text("Blue",0,0);
        break;
    case 1:
      text("Green",0,0);
        break;
    case 2:
      text("Red",0,0);
        break;
    }
    fill(255);
    popMatrix();
  }

  pointLight(0, 0, 255, randomWPoint[0], randomHPoint[0], randomZPoint[0]);
  pointLight(0, 255, 0, randomWPoint[1], randomHPoint[1], randomZPoint[1]);
  pointLight(255, 0, 0, randomWPoint[2], randomHPoint[2], randomZPoint[2]);


  fill(255);

  fft.forward(soundFile.mix);

  pushMatrix();
  translate(width/2, height*0.68, 0);
  sphere(eqMain.diameter/3.5714);
  eqMain.Construct();
  popMatrix();

  for (int i=0; i<numEqBackground; i++) {
    pushMatrix();
    translate(eqBackground[i].randTranslateX, eqBackground[i].randTranslateY, eqBackground[i].randTranslateZ);
    if(i%10 == 0) sphere(eqBackground[i].diameter/3.5714);
    eqBackground[i].Construct();
    popMatrix();
  }
 
 fc++;
}