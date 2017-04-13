package ai;

import java.util.ArrayList;
import java.util.Random;
import java.util.Stack;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;

public class Smart extends Strategy {
	
	/**
	 * Used to indidate possible locations of a ship
	 * @author jparra
	 *
	 */
	private class Probable {
		int row;
		int col;
		int[] dirs;
		int dir;
		ArrayList<Place> p;
		Random rand;
		int size;
		
		public Probable(int row, int col, Random rand, int size, ArrayList<Place> p, int dir) {
			this.row = row;
			this.col = col;
			this.rand = rand;
			this.dir = dir;
			this.p = p;
			this.size = size;
			
			if( dir == -1 ) {
				dirs = new int[]{ rand.nextInt(5) + 1, rand.nextInt(5) + 1, rand.nextInt(5) + 1, rand.nextInt(5) + 1};
				if( row == 0 )
					dirs[0] = 0;
				else if( row == size -1 ) 
					dirs[size-1] = 0;
				
				if( col == 0 )
					dirs[0] = 0;
				else if( row == size - 1 )
					dirs[size-1] = 0;
			}
		}
		
		/**
		 * Returns where this probable says to shoot
		 * @return
		 */
		public int getDir() {
			return dir;
		}
		
		public int getOppositeDir(int dir) {
			return (this.dir + 2) % 4;
		}
		
		public void setDir(int dir) {
			this.dir = dir;
		}
		
		/**
		 * Returns where to fire next based [0] = row, [1] = col
		 * @return
		 */
		public int[] getNext() {
			if( dir != -1 ) {
				int row = this.row;
				int col = this.col;
				if( dir % 2 == 0 ) {
					if( (dir == 0 && row != 0) || row == size-1)
						row--;
					else
						row++;
				} else {
					if( (dir == 1 && col != size-1) || col == 0 )
						col++;
					else
						col--;
				}
				
				return new int[]{row, col};
			}
			
			int index = 0;
			int prob = 0;
			for( int i = 0; i < dirs.length; i++ ) {
				if( dirs[i] != 0 && dirs[i] > prob ) {
					prob = dirs[i];
					index = i;
				} else if( dirs[i] != 0 && dirs[i] == prob && rand.nextInt(2) > 0 ) {
					prob = dirs[i];
					index = i;
				}
			}
			
			int row = this.row;
			int col = this.col;
			if( index % 2 == 0 ) {
				if( index == 0 )
					row--;
				else
					row++;
			} else {
				if( index == 1 )
					col++;
				else
					col--;
			}
			
			return new int[]{row, col};
		}
	}
	
	Stack<Probable> hitProbs;

	public Smart(BoardPanel p, Board b, ArrayList<Place> places) {
		super(p, b, places);
		
		hitProbs = new Stack<Probable>();
		hitProbs.push(new Probable(this.random(0, b.size()), this.random(0, b.size()), this.rand, b.size(), this.places, -1));
	}
	
	@Override
	public void fire() {
		
		// initialize variables
		int index = getHitNext();
		int row = index / b.size();
		int col = index % b.size();
		Place place = this.getPlace(row, col);
		
		// tell game board to hit that place
		this.b.hit(place);
		
		// check if the place contained a ship
		if( place.hasShip() ) {
			this.modifySurrounding(row, col, 20, 45, 1);
			
			handleHitProbs();
		} else {
			this.modifySurrounding(row, col, 0, 3, -1);
		}
		
		// set place to have been hit
		this.modify(row, col, false, -1 * this.random(1, 5));
	}
	
	public int getHitNext() {
		Probable probable = hitProbs.pop();
		int[] coords = probable.getNext();
		int row = coords[0];
		int col = coords[1];
		
		// the probable place to hit is saying to hit somewhere that has already been hit so this means that we reached the end of the board and need to 
		// double back
		if( this.getPlace(row, col).isHit() ) {
			
		} else {
			
		}
	}
	
	public void hasBeenHit(int row, int row) {
		this.places
	}
	
	/**
	 * Changes the probability of all values surrounding an element
	 * @param row
	 * @param col
	 * @param min
	 * @param max
	 * @param modifier
	 */
	private void modifySurrounding(int row, int col, int min, int max, int modifier) {
		
		// modify elements above and below this element
		if( row != 0 && this.getProb(row - 1, col) != 0 )
			this.modify(row -1, col, false, this.random(min, max) * modifier);
		
		if( row != b.size() - 1 && this.getProb(row + 1, col) != 0 )
			this.modify(row + 1, col, false, this.random(min, max) * modifier);
		
		// modify elements to the left and right of this element
		if( col != 0 && this.getProb(row, col - 1) != 0 )
			this.modify(row, col - 1, false, this.random(min, max) * modifier);
		
		if( col != b.size() - 1 && this.getProb(row, col + 1) != 0 )
			this.modify(row, col + 1, false, this.random(min, max) * modifier);
		
	}
	
	/**
	 * Returns the prob index with the highest probability
	 * @return
	 */
	private Probable getNext() {
		return this.hitProbs.pop();
	}
}
