// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

int numberOfFields = 3;

Field fields [] = new Field [3];

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

// tuio object list
ArrayList<TuioObject> tuioObjectList;

void setup() {
	// GUI setup
	noCursor();
	size(displayWidth, displayHeight);
	noStroke();
	fill(0);

	for (int i = 0; i < numberOfFields; i++) {
		fields[i] = new Field(new PVector((200 * i + 100), 500), i);
	}
	
	// periodic updates
	if (!callback) {
		frameRate(60);
		loop();
	} else {
		noLoop(); // or callback updates 
	}
	
	font = createFont("Arial", 18);
	scale_factor = height/table_size;
	
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
		popMatrix();
		fill(255);
		text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
	}

	// draw fields
	for (int i = 0; i < fields.length; i++) {
		fields[i].draw();
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