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
		public int dir;
		Random rand;
		public int guess;
		boolean beenReversed;
		
		public Probable(int row, int col, Random rand, int dir) {
			this.row = row;
			this.col = col;
			this.dir = dir;
			this.rand = rand;
			this.guess = -1;
			
			this.dirs = new int[]{1, 1, 1, 1};
		}
		
		/**
		 * Get the next location to fire at
		 * @return
		 */
		public int[] getNext() {
			int rowModifier = 0;
			int colModifier = 0;
			int dir = (this.dir > -1? this.dir : this.getDir());
			
			if( dir %2 == 0) {
				if( dir == 0 )
					rowModifier = -1;
				else
					rowModifier = 1;
			} else {
				if( dir == 1 )
					colModifier = 1;
				else
					colModifier = -1;
			}
			
			this.guess = dir;
			this.dirs[dir] = 0;
			return new int[]{this.row + rowModifier, this.col + colModifier};
		}
		
		/**
		 * Gets a location to fire at
		 * @return
		 */
		public int[] getReverse() {
			// make sure this probable has been used a direction
			if( this.guess != -1 ) {
				dir = (dir + 2) % 4;
				this.beenReversed = true;
			}
			return this.getNext();
		}
		
		/**
		 * Returns the dir that is avlid
		 * @return
		 */
		private int getDir() {
			int dir = this.rand.nextInt(4);
			int count = 0;
			while( this.dirs[dir] == 0 ) {
				dir = (dir + 1) % 4;
				
				// just in case if needed
				count++;
				if ( count > 4 )
					return 0;
			}
			return dir;
		}
		
		/**
		 * Sets this probable as a root hit location
		 */
		public void setRoot() {
			this.dir = -1;
			this.beenReversed = false;
		}
		
		/**
		 * Checks if a place can still fire a certain way
		 * @return
		 */
		public boolean isValid() {
			for(int i = 0; i < this.dirs.length; i++ ) {
				if( this.dirs[i] > 0 )
					return true;
			}
			return false;
		}
			
	}
	
	Stack<Probable> hitProbs;

	public Smart(BoardPanel p, Board b, ArrayList<Place> places) {
		super(p, b, places);
		
		hitProbs = new Stack<Probable>();
		hitProbs.push(new Probable(this.random(0, b.size()), this.random(0, b.size()), this.rand, -1));
	}
	
	private Probable randomProb() {
		int row;
		int col;
		do {
			row = this.random(0, b.size());
			col = this.random(0, b.size());
		} while( this.getPlace(row, col).isHit() );
		return new Probable(row, col, this.rand, -1);
	}
	
	@Override
	public void fire() {
		
		System.out.println("firing");
		
		// get probable
		Probable probable = hitProbs.pop();

		// fire at location the probable has located
		int[] coords;
		int row = probable.row;
		int col = probable.col;
		
		// something wrong with this probable get a good one
		while( this.getPlace(row, col).isHit() || !this.validCoord(row, col) ) {
			System.out.println(this.getPlace(row, col).isHit());
			System.out.println(this.getPlace(row, col).hasShip());
			System.out.println(this.getPlace(row, col).x);
			System.out.println(this.getPlace(row, col).y);
			System.out.println(row);
			System.out.println(col);
			System.out.println(!this.validCoord(row, col));
			if( hitProbs.size() > 0 )
				probable = hitProbs.pop();
			else
				probable = this.randomProb();
			
			row = probable.row;
			col = probable.col;
			System.out.println("Something Wrong");
		}
		
		// fire at this probable
		this.b.hit(this.getPlace(row, col));
		
		// Now we need to decide on the next place to fire at
		
		/*
		 * The place we just fired at had no ship so just get a random place
		 */
		if( !this.getPlace(probable.row, probable.col).hasShip() && this.hitProbs.size() == 0 ) {
			hitProbs.push(this.randomProb());
		}
		
		/*
		 * We hit a place so find the next place to shoot at
		 */
		else if( this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk() ) {
			System.out.println("Hit Something");
			// find a coord around the probable that can be shot at
			System.out.println("before");
			System.out.println(row);
			System.out.println(col);
			
			
			coords = probable.getNext();
			row = coords[0];
			col = coords[1];
			
			if( !this.validCoord(row, col) ) {
				coords = resetString(probable);
			}
			
			row = coords[0];
			col = coords[1];
			
			// create a new probable with the coords of where we should fire next turn
			Probable temp = new Probable(row, col, this.rand, probable.guess);
			
			// push this probable onto the stack
			hitProbs.push(probable);
			
			// replace the probable
			hitProbs.push(temp);
		}
		
		/*
		 * Either the ship has been sunk or we hit an element that didn't have anything
		 * But we have some probable locations of ships saved: this means we have hit a ship before and were trying to target this ship
		 */
		else if( this.hitProbs.size() > 0 && (!this.getPlace(probable.row, probable.col).hasShip() || this.getPlace(probable.row, probable.col).ship().isSunk()) ) {
			coords = resetString(probable);
			
			row = coords[0];
			col = coords[1];
			
			// create a new probable with the coords of where we should fire next turn
			Probable temp = new Probable(row, col, this.rand, probable.guess);
			
			// push this probable onto the stack
			hitProbs.push(probable);
			
			// replace the probable
			hitProbs.push(temp);
		} 

	}
	
	public int[] resetString(Probable probable) {
		int[] coords;
		int row = probable.row;
		int col = probable.col;
		Stack<Probable> tempStack = new Stack<Probable>();
		
		// find the root probable
		while( probable.dir != -1 && hitProbs.size() > 0) {
			// only put onto temp stack if the Probable's ship hasn't been sunk
			if( this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk() ) {
				tempStack.push(probable);
			}
			probable = hitProbs.pop();
		}
		
		// move all probables from temp stack into the hit probs stack
		while( tempStack.size() > 0 ) {
			Probable temp = tempStack.pop();
			temp.setRoot();
			hitProbs.push(temp);
		}
		
		// check if the root prob we found is valid if not look for another probable or get a random one
		System.out.println("row: " + probable.row);
		System.out.println("col: " + probable.col);
		if( this.getPlace(probable.row, probable.col).ship().isSunk() ) {
			
			if( hitProbs.size() == 0 ) {
				probable = this.randomProb();
				hitProbs.push(probable);
				return new int[]{ probable.row, probable.col };
			} else {
				while( this.getPlace(probable.row, probable.col).ship().isSunk() )
					probable = hitProbs.pop();
			}
		}
		
		// find a coord around the probable that can be shot at
		do {
			coords = probable.getReverse();
			row = coords[0];
			col = coords[1];
		} while( !this.validCoord(row, col) || this.getPlace(row, col).isHit() );
		
		return new int[]{ row, col};
//		// create a new probable with the coords of where we should fire next turn
//		Probable temp = new Probable(row, col, this.rand, probable.guess);
//		
//		// push this probable onto the stack
//		hitProbs.push(probable);
//		
//		// replace the probable
//		hitProbs.push(temp);
	}
	
//	public int getHitNext() {
//		Probable probable = hitProbs.pop();
//		int[] coords = probable.getNext();
//		int row = coords[0];
//		int col = coords[1];
//		
//		// the probable place to hit is saying to hit somewhere that has already been hit so this means that we reached the end of the board and need to 
//		// double back
//		if( this.getPlace(row, col).isHit() ) {
//			
//		} else {
//			
//		}
//	}
	
//	public void hasBeenHit(int row, int row) {
//		this.places
//	}
//	
//	/**
//	 * Changes the probability of all values surrounding an element
//	 * @param row
//	 * @param col
//	 * @param min
//	 * @param max
//	 * @param modifier
//	 */
//	private void modifySurrounding(int row, int col, int min, int max, int modifier) {
//		
//		// modify elements above and below this element
//		if( row != 0 && this.getProb(row - 1, col) != 0 )
//			this.modify(row -1, col, false, this.random(min, max) * modifier);
//		
//		if( row != b.size() - 1 && this.getProb(row + 1, col) != 0 )
//			this.modify(row + 1, col, false, this.random(min, max) * modifier);
//		
//		// modify elements to the left and right of this element
//		if( col != 0 && this.getProb(row, col - 1) != 0 )
//			this.modify(row, col - 1, false, this.random(min, max) * modifier);
//		
//		if( col != b.size() - 1 && this.getProb(row, col + 1) != 0 )
//			this.modify(row, col + 1, false, this.random(min, max) * modifier);
//		
//	}
	
	/**
	 * Returns the prob index with the highest probability
	 * @return
	 */
	private Probable getNext() {
		return this.hitProbs.pop();
	}
}
