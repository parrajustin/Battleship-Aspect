package ai;

import java.util.ArrayList;
import java.util.Random;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;

public abstract class Strategy {
	protected BoardPanel p;
	protected Board b;
	protected ArrayList<Place> places;
	protected Random rand;
	
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
	 * Returns the value of the ai game
	 * @return
	 */
	public boolean isGameOver() {
		return this.b.isGameOver();
	}
	
//	public void 
	
//	private void change(int row, int col, int min, int max, int modifier) {
//		if( index % b.size() != 0 && this.probs[index-1] != 0 )
//			this.probs[index-1] = this.probs[index-1] + (rand.nextInt(max-min) + min) * modifier;
//		if( index % b.size() != b.size()-1 && this.probs[index+1] != 0 )
//			this.probs[index+1] = this.probs[index+1] + (rand.nextInt(max-min) + min) * modifier;
//		if( index / b.size() != 0 && this.probs[((index/b.size())-1) * b.size() + index % b.size()] > 0 ) {
//			int north = ((index/b.size())-1) * b.size() + index % b.size();
//			this.probs[north] = this.probs[north] + (rand.nextInt(max-min) + min) * modifier;
//		}
//		if( index / b.size() != b.size()-1 && this.probs[((index/b.size())+1) * b.size() + index % b.size()] > 0 ) {
//			int south = ((index/b.size())+1) * b.size() + index % b.size();
//			this.probs[south] = this.probs[south] + (rand.nextInt(max-min) + min) * modifier;
//		}
//	}
	
	/**
	 * Returns a value x where : min <= x < max
	 * @param min
	 * @param max
	 * @return
	 */
	protected int random(int min, int max) {
		return this.rand.nextInt(max-min) + min;
	}
	
	/**
	 * Check if a coordinate is valid
	 * @param row
	 * @param col
	 * @return
	 */
	protected boolean validCoord(int row, int col) {
		return (row >= 0 && row < b.size() && col >= 0 && col < b.size());
	}
	
	/**
	 * Retrieves a place based on its row and column
	 * @param row
	 * @param col
	 * @return
	 */
	protected Place getPlace(int row, int col) {
		return this.places.get(row * b.size() + col);
	}
}
