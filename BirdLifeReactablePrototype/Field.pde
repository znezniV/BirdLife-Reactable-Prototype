class Field { 
	int x, y, w, h;

	// ID of any block that is placed on field (no matter if correct or not)
	Integer occupiedID;

	// ID of correct block that is placed on field
	Integer correctID;

	boolean correctBlock;
	boolean isOccupied;
	color c;
	color cHighlight;

	String cat;
	String text;
	String state;

	int[] nrs;

	// TODO: array of possible numbers that can match - currently only one number
	Field (PVector pos, int[] numbers, String category) {
		x = int(pos.x);
		y = int(pos.y);
		w = 99;
		h = 99;
		correctBlock = false;
		isOccupied = false;
		c = colorNeutral;
		cat = category;
		nrs = numbers;
		state = "empty";
	}

	void draw() { 
		noStroke();
		fill(c);
		noStroke();
		ellipse(x, y, w, h);
		collideWithBlock();
		pushMatrix();
		translate(x, y);
		rotate(radians(90));
		// choose label
		switch (cat) {
			case "alpha": 
				text = "α";
				break;
			case "beta": 
				text = "β";
				break;
			case "gamma": 
				text = "γ";
				break;
			case "omega": 
				text = "ω";
				break;
			default : 
				text = "XXX";
				break;	
		}
		fill(colorBG);
		textFont(font,40);
		text(text, 0 - w/8, 0 + h/9);
		// choose color validation highlighting
		switch (state) {
			case "empty":
				cHighlight = colorBG;
				break;
			case "occupied":
				cHighlight = color(32);
				break;
			case "correct":
				cHighlight = colorSuccess;
				break;
			case "wrong":
				cHighlight = colorError;
				break;
			default :
				cHighlight = colorBG;
				break;	
		}
		stroke(cHighlight);
		strokeWeight(10);
		noFill();
		ellipse(0, 0, w + 10, h + 10);
		popMatrix();
	}

	void collideWithBlock() {
		for (int i = 0; i < tuioObjectList.size(); i++) {
			TuioObject block = tuioObjectList.get(i);

			// detection of collition with tuio object
			if (
				trX(block.getScreenX(width)) >= x - w &&
				trX(block.getScreenX(width)) <= x + w && 
				block.getScreenY(height) >= y - h/2 && 
				block.getScreenY(height) <= y + h/2
			) {
				for (int number : nrs) {
					if (block.getSymbolID() == number) {
						correctBlock = true;
						break;
					}
				}
					
				if (correctBlock) {
					// c = colorSuccess;
					correctID = block.getSymbolID();
				} else {
					// c = colorError;
					correctID = null;
				}

				isOccupied = true;
				occupiedID = block.getSymbolID();
				break;

			} else {
				// c = colorNeutral;
				correctBlock = false;
				isOccupied = false;
				occupiedID = null;
				correctID = null;
			}
		}
	}
} 