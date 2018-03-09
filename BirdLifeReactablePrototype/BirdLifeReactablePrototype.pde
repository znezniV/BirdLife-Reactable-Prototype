// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

// import sound library
import processing.sound.*;
SoundFile file0;
SoundFile file1;
SoundFile file2;
SoundFile file3;
SoundFile file4;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

void setup() {
	// GUI setup
	noCursor();
	size(displayWidth,displayHeight);
	noStroke();
	fill(0);
	
	// periodic updates
	if (!callback) {
		frameRate(60);
		loop();
	} else {
		noLoop(); // or callback updates 
	}
	
	font = createFont("Arial", 18);
	scale_factor = height/table_size;
	
	// Load a soundfile from the /data/sounds folder of the sketch and play it back
	file0 = new SoundFile(this, "sounds/Hi-1.aif");
	file1 = new SoundFile(this, "sounds/Hi-2.aif");
	file2 = new SoundFile(this, "sounds/Mid-1.aif");
	file3 = new SoundFile(this, "sounds/Mid-2.aif");
	file4 = new SoundFile(this, "sounds/Low-1.aif");
	
	// finally we create an instance of the TuioProcessing client
	// since we add "this" class as an argument the TuioProcessing class expects
	// an implementation of the TUIO callback methods in this class (see below)
	tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw() {
	background(255);
	textFont(font,18 * scale_factor);
	float obj_size = object_size * scale_factor; 
	float cur_size = cursor_size * scale_factor; 
	 
	ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
	for (int i = 0; i < tuioObjectList.size(); i++) {
		TuioObject tobj = tuioObjectList.get(i);
		stroke(0);
		fill(0, 0, 0);
		pushMatrix();
		translate(tobj.getScreenX(width),tobj.getScreenY(height));
		rotate(tobj.getAngle());
		rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
		popMatrix();
		fill(255);
		text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
	}
}

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj " + tobj.getSymbolID() + " (" + tobj.getSessionID() + ") " + tobj.getX() + " " + tobj.getY() + " " + tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj " + tobj.getSymbolID() + " (" + tobj.getSessionID() + ") " + tobj.getX() + " " + tobj.getY() + " " + tobj.getAngle()
          + " " + tobj.getMotionSpeed() + " " + tobj.getRotationSpeed() + " " + tobj.getMotionAccel() + " " + tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  switch (tobj.getSymbolID()) {
        case 0:
            file.play();
            break;
        case 1:
            file.play();
            break;
        case 2:
            file.play();
            break;
        case 3:
            file.play();
            break;
        case 4:
            file.play();
            break;
    }

    println("removed: " + tobj.getSymbolID());
  println("removed");
  if (verbose) println("del obj " + tobj.getSymbolID() + " (" + tobj.getSessionID() + ")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ") " + tcur.getX() + " " + tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ") " + tcur.getX() + " " + tcur.getY()
          + " " + tcur.getMotionSpeed() + " " + tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb " + tblb.getBlobID() + " (" + tblb.getSessionID() + ") " + tblb.getX() + " " + tblb.getY() + " " + tblb.getAngle() + " " + tblb.getWidth() + " " + tblb.getHeight() + " " + tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb " + tblb.getBlobID() + " (" + tblb.getSessionID() + ") " + tblb.getX() + " " + tblb.getY() + " " + tblb.getAngle() + " " + tblb.getWidth() + " " + tblb.getHeight() + " " + tblb.getArea()
          + " " + tblb.getMotionSpeed() + " " + tblb.getRotationSpeed() + " " + tblb.getMotionAccel() + " " + tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb " + tblb.getBlobID() + " (" + tblb.getSessionID() + ")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #" + frameTime.getFrameID() + " (" + frameTime.getTotalMilliseconds() + ")");
  if (callback) redraw();
}