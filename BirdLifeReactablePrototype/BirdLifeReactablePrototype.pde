// import the TUIO library
import TUIO.*;
import processing.sound.*;
import processing.video.*;
import ddf.minim.*;

// declare a Minim sound
Minim minim;

// declare movie variable
Movie birdAnimation;

// declare a TuioProcessing client
TuioProcessing tuioClient;

int numberOfFields = 8;

Field fields [] = new Field [numberOfFields];
AudioPlayer sounds [] = new AudioPlayer [8];
int snippetCount = 0;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;

PFont font;
PFont textFont;
PFont textFontBold;
PFont fontIcon;

boolean verbose = false; // print console debug messages
boolean callback = false; // updates only after callbacks

boolean projector = true;

color colorBG = color(0);
color colorNeutral = color(64);
color colorSuccess = color(18,178,82);
color colorError = color(178,17,17);

PImage uglyParking;

// tuio object list
ArrayList<TuioObject> tuioObjectList;

void setup() {
	// GUI setup
	fullScreen();

	// size(960, 540);

	noCursor();
	noStroke();
	fill(0);

	// Configure fields
	fields[0] = new Field(new PVector(674, 81), new int[] {0, 1, 2}, "alpha");
	fields[1] = new Field(new PVector(674, 212), new int[] {0, 1, 2}, "alpha");
	fields[2] = new Field(new PVector(674, 343), new int[] {0, 1, 2}, "alpha");
	fields[3] = new Field(new PVector(545, 474), new int[] {3, 4}, "beta");
	fields[4] = new Field(new PVector(545, 604), new int[] {3, 4}, "beta");
	fields[5] = new Field(new PVector(416, 737), new int[] {5, 6}, "gamma");
	fields[6] = new Field(new PVector(416, 868), new int[] {5, 6}, "gamma");
	fields[7] = new Field(new PVector(287, 999), new int[] {7}, "omega");

	minim = new Minim (this);

	sounds[0] = minim.loadFile("sounds/Alpha01.wav");
	sounds[1] = minim.loadFile("sounds/Alpha02.wav");
	sounds[2] = minim.loadFile("sounds/Alpha03.wav");
	sounds[3] = minim.loadFile("sounds/Beta01.wav");
	sounds[4] = minim.loadFile("sounds/Beta02.wav");
	sounds[5] = minim.loadFile("sounds/Gamma01.wav");
	sounds[6] = minim.loadFile("sounds/Gamma02.wav");
	sounds[7] = minim.loadFile("sounds/Omega01.wav");
	
	// load image for parking space
	uglyParking = loadImage("img/parking.png");

	// load video for bird animation
	birdAnimation = new Movie(this, "video/birdAnimation.mov");
	birdAnimation.loop();

	// periodic updates
	if (!callback) {
		frameRate(60);
		loop();
	} else {
		noLoop(); // or callback updates 
	}
	
	font = createFont("HelveticaNeue", 20);
	textFont = createFont("Phenomena-Regular", 26);
	textFontBold = createFont("Phenomena-Black", 26);
	fontIcon = createFont("HelveticaRoundedLTStd-Bd", 26);

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
	background(colorBG);
	textFont(font,18 * scale_factor);
	float obj_size = object_size * scale_factor; 
	float cur_size = cursor_size * scale_factor;

	// draw tuio objects
	tuioObjectList = tuioClient.getTuioObjectList();
	for (int i = 0; i < tuioObjectList.size(); i++) {
		TuioObject tobj = tuioObjectList.get(i);
		// PVector pos = new PVector(trX(tobj.getScreenX(width)), tobj.getScreenY(height));
		// stroke(0);
		// fill(0, 255, 0);
		// pushMatrix();
		// translate(pos.x, pos.y);
		// rotate(tobj.getAngle());
		// ellipse(0, 0, obj_size, obj_size);
		// fill(0,255,0);
		// rect(-6/2, -6/2, 6,6);
		// popMatrix();
		// fill(255);
		// text(""+tobj.getSymbolID(), pos.x, pos.y);
	}

	// check fields filled correctly
	boolean allFieldsCorrect = true;
	boolean allFieldsOccupied = true;

	// draw fields
	for (Field field : fields) {
		field.draw();

		// check if all fields are occupied 
		if (field.isOccupied) {

			// hightlight that field is occupied 
			field.state = "occupied";
		} else {

			// switch back to empty if removed
			field.state = "empty";
			allFieldsOccupied = false;
		}

		// check if field is correct
		if (!field.correctBlock) {
			allFieldsCorrect = false;
		}
	}

	// if fields are occupied
	if (allFieldsOccupied) {

		// if fields are filled correctly
		if (allFieldsCorrect) {

			// switch all fields to correct state
			for (Field field : fields) {
				field.state = "correct";
			}

			// play first snippet
			if (snippetCount == 0) {

				soundMapping(fields[0].correctID).rewind();
				soundMapping(fields[0].correctID).play();
				snippetCount++;

			} else if (snippetCount < sounds.length) {

				// play following snippets if the previous isn't playing
				if (!soundMapping(fields[snippetCount - 1].correctID).isPlaying()) {

					soundMapping(fields[snippetCount].correctID).rewind();
					soundMapping(fields[snippetCount].correctID).play();
					snippetCount++;
				}
			}

		} else {
			snippetCount = 0;

			// when all fields are occupied, hightlight the wrong fields
			for (Field field : fields) {
				if (!field.correctBlock) {
					field.state = "wrong";
				}
			}
		}
	} else {

		// remove error highlighting if not all fields are occupied
		for (Field field : fields) {
			if (!field.correctBlock) {
				field.c = colorNeutral;
			}
		}
	}
	noStroke();
	fill(colorNeutral);

	// nice parking space
	// rect(30, 30, 100, height-60, 60);

	// ugly parking space
	image(uglyParking, 0, 0, 80, height);

	pushMatrix();
	// play bird animation
	translate(width, 0);
	rotate(radians(90));
	image(birdAnimation, 0, 0, 1080, 888);
	popMatrix();

	pushMatrix();
	translate(907, 540);
	rotate(radians(90));
	rect(-height/2, -250, height, 250);
	fill(255);
	textFont(textFontBold,26);
	text("Bring mir das Singen bei", -height/2 + 30, -250+20, height - 30, 250);
	textFont(textFont,26);
	text("«Als Baby-Vogel trainiere ich meine Singstimme, indem ich Geräusche in meiner Umgebung nachahme. Bring mir das Singen bei, indem du die Figuren auf die richtige Alpha-, Beta-, Gamma- und Omega-Position schiebst. Hebe die Figuren an, um das Gesangs-Element vorzuhören.»", -height/2 + 30, -250+60, height - 30, 250);
	popMatrix();

	noFill();
	stroke(220, 250, 190);
	strokeWeight(3);

	pushMatrix();
	translate(674, height-30-65);
	rect(0, 0, 65, 65, 12);
	textFont(fontIcon, 45);
	rotate(radians(90));
	fill(220, 250, 190);
	text("?", 22, -17);
	popMatrix();
}

// map sounds to argument
AudioPlayer soundMapping(int id) {
	switch (id) {
		case 0:
			return sounds[0];
		case 1:
			return sounds[1];
		case 2:
			return sounds[2];
		case 3:
			return sounds[3];
		case 4:
			return sounds[4];
		case 5:
			return sounds[5];
		case 6:
			return sounds[7];
		default :
			return sounds[0];	
	}
}

// mirror x-position of tujo object
int trX (int posX) {
	return width - posX;
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
	m.read();
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
	soundMapping(tobj.getSymbolID()).rewind();
	soundMapping(tobj.getSymbolID()).play();

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