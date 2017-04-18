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
		
		public Probable(int row, int col, Random rand, int dir, Smart s) {
			this.row = row;
			this.col = col;
			this.dir = dir;
			this.rand = rand;
			this.guess = -1;
			
			this.dirs = new int[]{1, 1, 1, 1};
			if( !s.validCoord(row-1, col) || s.getPlace(row-1, col).isHit() )
				dirs[0] = 0;
			if( !s.validCoord(row, col+1) || s.getPlace(row, col+1).isHit() )
				dirs[1] = 0;
			if( !s.validCoord(row+1, col) || s.getPlace(row+1, col).isHit() )
				dirs[2] = 0;
			if( !s.validCoord(row, col-1) || s.getPlace(row, col-1).isHit() )
				dirs[3] = 0;
		}
			
		/**
		 * Get the next location to fire at
		 * @return
		 */
		public int[] getNext() {
			if( this.dir != -1 && this.dirs[this.dir] == 0 ) {
				return new int[] {-1, -1};
			}
			
			int row = this.row;
			int col = this.col;
			int dir = (this.dir > -1? this.dir : this.getDir());
			this.guess = dir;
			
			if( dir == 0 ) {
				row --;
			} else if( dir == 1 ) {
				col ++;
			} else if( dir == 2 ) {
				row ++;
			} else {
				col --;
			}
			
			
			this.dirs[dir] = 0;
			return new int[]{row, col};
		}
		
		/**
		 * Gets a location to fire at
		 * @return
		 */
		public int[] getReverse() {
			// make sure this probable has been used a direction
			if( this.guess != -1 && this.dirs[(this.guess + 2) % 4] != 0) {
				int row = this.row;
				int col = this.col;
				int dir = (this.guess + 2) % 4;
				this.guess = dir;
				
				if( dir == 0 ) {
					row --;
				} else if( dir == 1 ) {
					col ++;
				} else if( dir == 2 ) {
					row ++;
				} else {
					col --;
				}
				
				this.dirs[dir] = 0;
				return new int[]{ row, col };
			} else {
				return this.getNext();
			}
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

	/**
	 * Smart constructor
	 * @param p
	 * @param b
	 * @param places
	 */
	public Smart(BoardPanel p, Board b, ArrayList<Place> places) {
		super(p, b, places);
		
		hitProbs = new Stack<Probable>();
		hitProbs.push(new Probable(this.random(0, b.size()), this.random(0, b.size()), this.rand, -1, this));
	}
	
	/**
	 * Retrieves a random location to shoot to
	 * @return
	 */
	private Probable randomProb() {
		int row;
		int col;
		do {
			row = this.random(0, b.size());
			col = this.random(0, b.size());
		} while( this.getPlace(row, col).isHit() );
		return new Probable(row, col, this.rand, -1, this);
	}
	
	@Override
	public void fire() {
		
		// get probable
		Probable probable = hitProbs.pop();

		// fire at location the probable has located
		int[] coords;
		int row = probable.row;
		int col = probable.col;
		
		// something wrong with this probable get a good one
		while( this.getPlace(row, col).isHit() || !this.validCoord(row, col) ) {
			if( hitProbs.size() > 0 ) {
				coords = resetString(probable);
				row = coords[0];
				col = coords[1];
				int guess = coords[2];
				Probable temp = new Probable(row, col, this.rand, guess, this);
			} else
				probable = this.randomProb();
			
			row = probable.row;
			col = probable.col;
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
		 * and probable is root
		 */
		else if( this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk() && probable.dir == -1 ) {
			// find a coord around the probable that can be shot at
			
			coords = probable.getNext();
			row = coords[0];
			col = coords[1];
			int guess = probable.guess;
			
			while( probable.isValid() && !this.validCoord(row, col) ) {
				coords = probable.getNext();
				row = coords[0];
				col = coords[1];
				guess = probable.guess;
			}
			
			if( !probable.isValid() ) {
				coords = resetString(probable);
				row = coords[0];
				col = coords[1];
				guess = coords[2];
			}
			
			// create a new probable with the coords of where we should fire next turn
			Probable temp = new Probable(row, col, this.rand, guess, this);
			
			// push this probable onto the stack
			hitProbs.push(probable);
			
			// replace the probable
			hitProbs.push(temp);
		}
		
		/*
		 * This probable isn't the root and it has a ship that isn't sunk so we should keep shooting the same way
		 *  but we the direction is saying to shoot at a place that is off the board or that is hit
		 */
		else if( probable.dir != -1 && this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk() ) {
			coords = probable.getNext();
			row = coords[0];
			col = coords[1];
			int guess = probable.guess;
			
			if( !this.validCoord(row, col) || this.getPlace(row, col).isHit() ) {
				coords = resetString(probable);
				row = coords[0];
				col = coords[1];
				guess = coords[2];
			}
			
			// create a new probable with the coords of where we should fire next turn
			Probable temp = new Probable(row, col, this.rand, guess, this);
			
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
			Probable temp = new Probable(row, col, this.rand, coords[2], this);
			
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
			System.out.println("whileLoop");
			if( probable.isValid() &&  this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk() ) {
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
		
		if( probable.dir == -1 && probable.isValid() && this.getPlace(probable.row, probable.col).hasShip() && !this.getPlace(probable.row, probable.col).ship().isSunk()) {
			hitProbs.push(probable);
			coords = probable.getReverse();
			return new int[]{coords[0], coords[1], probable.guess};
		} else if( this.getPlace(probable.row, probable.col).hasShip() && this.getPlace(probable.row, probable.col).ship().isSunk() && hitProbs.size() == 0 ) {
			probable = this.randomProb();
			return new int[]{probable.row, probable.col, -1};
		} else if( this.getPlace(probable.row, probable.col).hasShip() && this.getPlace(probable.row, probable.col).ship().isSunk() && hitProbs.size() != 0) {
			probable = hitProbs.pop();
			coords = this.resetString(probable);
			return new int[]{coords[0], coords[1], coords[2]};
		} else if( !probable.isValid() ) {
			if( hitProbs.size() > 0 )
				probable = hitProbs.pop();
			else
				probable = this.randomProb();
			coords = this.resetString(probable);
			return new int[]{coords[0], coords[1], coords[2]};
		} else {
			probable = this.randomProb();
			return new int[]{probable.row, probable.col, -1};
		}
	}

}
