class Field { 
	int x, y, w, h;
	boolean correctBlock;
	color c;

	color colorNeutral = color(0);
	color colorSuccess = color(0,255,0);
	color colorError = color(255,0,0);

	ArrayList<Integer> numbers;

	// TODO: array of possible numbers that can match - currently only one number
	Field (PVector pos) {
		x = int(pos.x);
		y = int(pos.y);
		w = 75;
		h = 75;
		correctBlock = false;
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
				for (int number : numbers) {
					if (block.getSymbolID() == number) {
						correctBlock = true;
					}
				}
					
				if (correctBlock) {
					c = colorSuccess;
				} else {
					c = colorError;
				}

				break;

			} else {
				c = colorNeutral;
				correctBlock = false;
			}
		}
	}
} 