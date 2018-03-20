class Field { 
	int x, y, w, h;

	// ID of any block that is placed on field (no matter if correct or not)
	Integer occupiedID;

	// ID of correct block that is placed on field
	Integer correctID;

	boolean correctBlock;
	boolean isOccupied;
	color c;

	color colorNeutral = color(255,255/2);
	color colorSuccess = color(0,255,0);
	color colorError = color(255,0,0);

	String cat;
	String text;

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

	}

	void draw() { 
		noStroke();
		fill(c);
		ellipse(x, y, w, h);
		collideWithBlock();

		switch (cat) {
			case "alpha": text = "α";
				break;
			case "beta": text = "β";
				break;
			case "gamma": text = "γ";
				break;
			case "omega": text = "ω";
				break;
			default : text = "XXX";
				break;	
		}
		fill(0);
		pushMatrix();
		translate(x, y);
		rotate(radians(-90));
		textFont(font,40);
		text(text, 0 - w/8, 0 + h/9);
		popMatrix();
	}

	void collideWithBlock() {
		for (int i = 0; i < tuioObjectList.size(); i++) {
			TuioObject block = tuioObjectList.get(i);
			if (
				block.getScreenX(width) >= x &&
				block.getScreenX(width) <= x + w && 
				block.getScreenY(height) >= y && 
				block.getScreenY(height) <= y + h
			) {
				for (int number : nrs) {
					if (block.getSymbolID() == number) {
						correctBlock = true;
						break;
					}
				}
					
				if (correctBlock) {
					c = colorSuccess;
					correctID = block.getSymbolID();
				} else {
					c = colorError;
					correctID = null;
				}

				isOccupied = true;
				occupiedID = block.getSymbolID();
				break;

			} else {
				c = colorNeutral;
				correctBlock = false;
				isOccupied = false;
				occupiedID = null;
				correctID = null;

			}
		}
	}
} 