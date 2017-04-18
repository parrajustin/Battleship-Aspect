package ai;

import java.util.ArrayList;
import java.util.Random;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;

/**
 * The abstract strategy class that the other strategys extend
 * @author Justin P, Sebastian A, Luis R.
 *
 */
public abstract class Strategy {
	protected BoardPanel p;
	protected Board b;
	protected ArrayList<Place> places;
	protected Random rand;
	
	/**
	 * Strategy Class and children constructor
	 * @param p	A board panel refrence used to repaint
	 * @param b The board that contains the ships and places
	 * @param places an array list for Place for easier access
	 */
	public Strategy(BoardPanel p, Board b, ArrayList<Place> places) {
		this.p = p;
		this.b = b;
		this.places = places;
		rand = new Random();
	}
	
	/**
	 * Tells the ai to take its turn
	 */
	public abstract void fire();
	
	/**
	 * Returns the game state
	 * @return true if game is over
	 */
	public boolean isGameOver() {
		return this.b.isGameOver();
	}
	
	/**
	 * Returns a value x where : min <= x < max
	 * @param min minimum value to return
	 * @param max exclusive max value
	 * @return min <= x < max
	 */
	protected int random(int min, int max) {
		return this.rand.nextInt(max-min) + min;
	}
	
	/**
	 * Check if a coordinate is valid
	 * @param row 0-index based row
	 * @param col 0-index based column
	 * @return boolean true if coordinate is valid
	 */
	protected boolean validCoord(int row, int col) {
		return (row >= 0 && row < b.size() && col >= 0 && col < b.size());
	}
	
	/**
	 * Retrieves a place based on its row and column
	 * 0 index
	 * @param row 0-index based row
	 * @param col 0-index based column
	 * @return returns a random game Place
	 */
	protected Place getPlace(int row, int col) {
		return this.places.get(row * b.size() + col);
	}
}
