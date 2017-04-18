package ai;

import java.util.ArrayList;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;

/**
 * A random ai class that just shoots at random positions on the map
 * @author Justin P, Sebastian A, Luis R.
 *
 */
public class RandomAI extends Strategy {

	public RandomAI(BoardPanel p, Board b, ArrayList<Place> places) {
		super(p, b, places);
	}

	@Override
	public void fire() {
		int row;
		int col;
		do {
			row = this.random(0, b.size());
			col = this.random(0, b.size());
		} while( this.getPlace(row, col).isHit() );
		
		this.b.hit(this.getPlace(row, col));
	}

}
