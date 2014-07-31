class BeatBox {

  final float tolerance = 10;

  float width;
  float height;
  float cx;
  float cy;
  PApplet container;
  Body [] rect;
  AudioPlayer player;
  Body note;

  BeatBox(float cx, float cy, float width, float height) {
    this.cx = cx;
    this.cy = cy;
    this.width = width;
    this.height = height;
    this.createBeatBox();
    this.createNote();
  }

  void createNote() {
    this.note = physics.createCircle(this.cx, this.cy, 8);
  }

  public void setAudio(AudioPlayer player) {
    this.player = player;
  }

  public float getX() {
    return this.cx;
  }

  public float getY() {
    return this.cy;
  }

  public boolean hitTest(Body b) {
    for (int i=0; i < rect.length; i++) {
      if (b == rect[i]) {
        //println("Hit", this, b);
        this.play();
        println(b);
        return true;
      }
    }
    return false;
  }

  void play() {
    this.player.cue(0);
    this.player.play();
  }

  boolean inBox() {
    // In box interior?
    if (Math.abs(mouseX - this.cx) > this.width/2 - this.tolerance) return false;
    if (Math.abs(mouseY - this.cy) > this.height/2 - this.tolerance) return false;
    return true;
  }

  boolean inWarp() {
    if (!this.inBox()) return false;

    return (Math.abs(mouseX - this.cx) < 4 * this.tolerance) && (Math.abs(mouseY - this.cy) < 4 * this.tolerance);
  }

  boolean inCenter() {
    return (Math.abs(mouseX - this.cx) < 2 * tolerance) && (Math.abs(mouseY - this.cy) < 2 * tolerance);
  }

  void draw() {
    this.draw(0);
  }

  void draw(int mode) {
    if (mode == 2) return;
    fill(255, 200, 0);
    rect(cx - width /2, cy - height /2, width, height, 16);
    fill(0);
    rect(cx - width /2 + 4, cy - height /2 + 4, width -8, height-8, 16);
    fill(255, 200, 0);
    rect(cx - width /2 + 8, cy - height /2 + 8, width - 16, height - 16, 16);

    if (this.inBox()) {
      noStroke();
      if (this.inCenter()) {
        fill( 0xFF, 0xFF, 0xFF, 85);
        //rect(cx - 2 * tolerance, cy - 2 * tolerance, 4 * tolerance, 4 * tolerance);
        ellipse(cx, cy, 4 * tolerance, 4 * tolerance);
      } else if (this.inWarp()) {
        fill(0xAA, 0xAA, 0xAA, 75);
        ellipse(cx, cy, 8 * tolerance, 8 * tolerance);
      } else if (this.inBox()) {
        fill(0x88, 0x88, 0x88, 65);
        rect(cx - width /2 + tolerance, cy - height /2 + tolerance, width - 2 * tolerance, height - 2 * tolerance);
      }
      noFill();
    }
    
    Vec2 note = physics.worldToScreen(this.note.getWorldCenter());
    fill(255,0,0);
    ellipse(note.x, note.y, 10,10);

  }

  void mouseClicked() {
    if (!this.inBox()) return;

    if (this.inCenter()) {
      this.note.setLinearVelocity(new Vec2(0, 0));
      this.note.setPosition(physics.screenToWorld(new Vec2(this.cx, this.cy)));
    } else if (this.inWarp()) {
      this.note.setPosition(physics.screenToWorld(new Vec2(this.cx, this.cy)));
    } else {
      Vec2 mouse = physics.screenToWorld( new Vec2(mouseX, mouseY));
      Vec2 pmouse = physics.screenToWorld( new Vec2(this.cx, this.cy));
      Vec2 impulse = mouse.sub(pmouse);
      impulse = impulse.mul(10);
      this.note.applyImpulse(impulse, this.note.getWorldCenter());
    }
  }

  void mouseDragged() {

    float minimum = 40;

    // In box corner?
    if (Math.abs(Math.abs(mouseX - this.cx) - this.width/2) > tolerance) return;
    if (Math.abs(Math.abs(mouseY - this.cy) - this.height/2) > tolerance) return;

    this.width = Math.max(minimum, 2 * Math.abs(mouseX - this.cx));
    this.height = Math.max(minimum, 2 * Math.abs(mouseY - this.cy));
    this.createBeatBox();
  }


  public void createBeatBox()
  {
    println(physics);

    if (rect != null) {
      // Destroy old
      physics.removeBody(rect[0]);
      physics.removeBody(rect[1]);
      physics.removeBody(rect[2]);
      physics.removeBody(rect[3]);
    }
    float cx = this.cx;
    float cy = this.cy;
    float width = this.width;
    float height = this.height;

    float density = physics.getDensity();

    physics.setDensity(0.0f);

    rect = new Body[4];
    float w2 = width / 2;
    float h2 = height /2;

    // Horizontal
    rect[0] = physics.createRect( cx - w2, cy - h2 - 5, cx + w2, cy - h2 + 5);
    rect[1] = physics.createRect( cx - w2, cy + h2 - 5, cx + w2, cy + h2 + 5);

    rect[2] = physics.createRect( cx - w2 - 5, cy - h2, cx - w2 + 5, cy + h2);
    rect[3] = physics.createRect( cx + w2 - 5, cy - h2, cx + w2 + 5, cy + h2);

    physics.setDensity(density);
  }
}

