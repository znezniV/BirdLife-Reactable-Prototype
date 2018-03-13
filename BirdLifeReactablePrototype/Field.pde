class Field { 
	int x, y, w, h, number;
	boolean rightBlock;
	color c;

	color colorNeutral = color(0);
	color colorSuccess = color(0,255,0);
	color colorError = color(255,0,0);

	// TODO: array of possible numbers that can match - currently only one number
	Field (PVector pos, int nr) {
		x = int(pos.x);
		y = int(pos.y);
		w = 75;
		h = 75;
		number = nr;
		rightBlock = false;
		c = colorNeutral;

	}

	void draw() { 
		noFill();
		stroke(c);
		strokeWeight(4);
		rect(x, y, w, h);
		collideWithBlock();
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
					if (block.getSymbolID() == number) {
						// println("right block");
						c = colorSuccess;
						rightBlock = true;
					} else {
						// println("wrong block");
						c = colorError;
						rightBlock = false;
					}
			} else {
				c = colorNeutral;
				rightBlock = false;
			}
		}
	}
} 