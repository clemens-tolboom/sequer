import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

String [] audio;

Maxim maxim;
AudioPlayer[] noteSounds;

Physics physics;

CollisionDetector detector; 

// DEBUG:
// 0 : Custom handler only
// 1 : Both renderers
// 2 : Default renderer
final int DEBUG = 0;

String [] noteKeys;

int noteSize = 80;
int ballSize = 60;
int width = 800;
int height = 800;

PImage noteImage;
PImage ballImage;
PImage background;

int score = 0;

boolean dragging = false;

BeatBox [] bb;

void setup() {
  audio = new String[9];
  audio[0] = "bassdrum-open.wav";
  audio[1] = "bassdrum-stump.wav";
  audio[2] = "clap.wav";
  audio[3] = "hihat-closed.wav";
  audio[4] = "hihat-open.wav";
  audio[5] = "kick.wav";
  audio[6] = "snare-chain.wav";
  audio[7] = "snare-stump.wav";
  audio[8] = "snare.wav";

  maxim = new Maxim(this);

  size(width, height);
  frameRate(60);

  // http://pixabay.com/static/uploads/photo/2011/05/25/14/46/piano-keys-7624_640.jpg
  background = loadImage("background.jpg");

  imageMode(CENTER);

  physics = new Physics(this, width, height, 0, 0, width*2, height*2, width, height, 25);

  if (DEBUG == 0) {
    physics.setCustomRenderingMethod(this, "myCustomRenderer");
  }

  // No friction
  physics.setFriction(0.01);
  // Elastic collisions (keep going)
  physics.setRestitution(1.0);

  physics.setDensity(6.0);

  bb = new BeatBox[audio.length];
  for ( int i=0; i<audio.length; i++) {
    bb[i] = new BeatBox(width / 3 * (i % 3) + width / 6, height / 3 * ((i - i % 3) / 3) + height / 6, width / 4 , height / 4);
    bb[i].setAudio(loadSound(audio[i]));
  }

  // sets up the collision callbacks
  detector = new CollisionDetector (physics, this);
}

AudioPlayer loadSound(String filename) {
  AudioPlayer sound = maxim.loadFile(filename);
  sound.setLooping(false);
  sound.volume(1);
  return sound;
}

void debug(Object x) {
  debug(x, "debug");
}

void debug(Object x, String message) {
  if (DEBUG > 0) {
    println(message, ":", x);
  }
}

void draw() {
  image(background, width/2, height/2, width, height);

  for (int i= 0; i< bb.length; i++) {
    bb[i].draw(DEBUG);
  }
  if (DEBUG == 1) {
    myCustomRenderer(physics.getWorld());
  }
}

void mouseClicked()
{
  for (int i= 0; i< bb.length; i++) {
    bb[i].mouseClicked();
  }
}

void mouseDragged()
{
  for (int i= 0; i< bb.length; i++) {
    bb[i].mouseDragged();
  }
}

void collision(Body b1, Body b2, float impulse)
{
  debug(b1.getLinearVelocity().length(), "velocity");

  AudioPlayer player;

  for (int i = 0; i < bb.length; i++) {
    bb[i].hitTest(b1);
    bb[i].hitTest(b2);
  }

}

void myCustomRenderer(World world) {
  // Noting to do yet.
}

