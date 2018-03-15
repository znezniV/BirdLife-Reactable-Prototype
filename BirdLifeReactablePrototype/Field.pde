class Field { 
	int x, y, w, h;
	boolean correctBlock;
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
		w = 75;
		h = 75;
		correctBlock = false;
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
		text(text, x -7,  y+7);
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