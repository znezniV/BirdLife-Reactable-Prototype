// import the TUIO library
import TUIO.*;
import processing.sound.*;

import ddf.minim.*;
Minim minim;

// declare a TuioProcessing client
TuioProcessing tuioClient;

int numberOfFields = 7;

Field fields [] = new Field [numberOfFields];
AudioPlayer sounds [] = new AudioPlayer [6];

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

boolean projector = false;

// tuio object list
ArrayList<TuioObject> tuioObjectList;

void setup() {
	// GUI setup
	// fullScreen();

	size(960, 540);

	noCursor();
	noStroke();
	fill(0);

	// Configure fields
	fields[0] = new Field(new PVector(1296, 918), new int[] {0, 2}, "alpha");
	fields[1] = new Field(new PVector(1296, 786), new int[] {1}, "beta");
	fields[2] = new Field(new PVector(1296, 655), new int[] {2}, "gamma");
	fields[3] = new Field(new PVector(1425, 525), new int[] {3}, "omega");
	fields[4] = new Field(new PVector(1553, 393), new int[] {3}, "omega");
	fields[5] = new Field(new PVector(1553, 261), new int[] {3}, "omega");
	fields[6] = new Field(new PVector(1682, 130), new int[] {3}, "omega");

	minim = new Minim (this);

	sounds[0] = minim.loadFile("sounds/Alpha01.wav");
	sounds[1] = minim.loadFile("sounds/Alpha02.wav");
	sounds[2] = minim.loadFile("sounds/Beta01.wav");
	sounds[3] = minim.loadFile("sounds/Gamma01.wav");
	sounds[4] = minim.loadFile("sounds/Gamma02.wav");
	sounds[5] = minim.loadFile("sounds/Omega01.wav");
	
	// periodic updates
	if (!callback) {
		frameRate(60);
		loop();
	} else {
		noLoop(); // or callback updates 
	}
	
	font = createFont("HelveticaNeue", 20);
	scale_factor = height/table_size;
	
	// finally we create an instance of the TuioProcessing client
	// since we add "this" class as an argument the TuioProcessing class expects
	// an implementation of the TUIO callback methods in this class (see below)
	tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw() {
	if (!projector) {
		scale(0.5);	
	}
	background(0);
	textFont(font,18 * scale_factor);
	float obj_size = object_size * scale_factor; 
	float cur_size = cursor_size * scale_factor;

	// draw tuio objects
	tuioObjectList = tuioClient.getTuioObjectList();
	for (int i = 0; i < tuioObjectList.size(); i++) {
		TuioObject tobj = tuioObjectList.get(i);
		stroke(0);
		fill(0, 0, 0);
		pushMatrix();
		translate(tobj.getScreenX(width),tobj.getScreenY(height));
		rotate(tobj.getAngle());
		rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
		fill(0,255,0);
		rect(-6/2, -6/2, 6,6);
		popMatrix();
		fill(255);
		text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
	}

	// check fields filled correctly
	boolean allFieldsCorrect = true;

	// draw fields
	for (Field field : fields) {
		field.draw();

		if (!field.correctBlock) {
			allFieldsCorrect = false;
		}
	}

	// if fields are filled correctly
	if (allFieldsCorrect) {
		println("all fields are correct");
	}
}

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
	if (verbose) println("add obj " + tobj.getSymbolID() + " (" + tobj.getSessionID() + ") " + tobj.getX() + " " + tobj.getY() + " " + tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
	if (verbose) println("set obj " + tobj.getSymbolID() + " (" + tobj.getSessionID() + ") " + tobj.getX() + " " + tobj.getY() + " " + tobj.getAngle() + " " + tobj.getMotionSpeed() + " " + tobj.getRotationSpeed() + " " + tobj.getMotionAccel() + " " + tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
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
	if (verbose) println("set cur " + tcur.getCursorID() + " (" + tcur.getSessionID() + ") " + tcur.getX() + " " + tcur.getY() + " " + tcur.getMotionSpeed() + " " + tcur.getMotionAccel());
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
	if (verbose) println("set blb " + tblb.getBlobID() + " (" + tblb.getSessionID() + ") " + tblb.getX() + " " + tblb.getY() + " " + tblb.getAngle() + " " + tblb.getWidth() + " " + tblb.getHeight() + " " + tblb.getArea() + " " + tblb.getMotionSpeed() + " " + tblb.getRotationSpeed() + " " + tblb.getMotionAccel() + " " + tblb.getRotationAccel());
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