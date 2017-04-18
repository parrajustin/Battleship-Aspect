package ai;

import java.util.ArrayList;
import java.util.Stack;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

public class Under34 extends Strategy {
	
	int shotNumber = 0;
	Ship ship = null;
	private Stack<Place> shipPlaces;

	public Under34(BoardPanel p, Board b, ArrayList<Place> places) {
		super(p, b, places);
		// TODO Auto-generated constructor stub
	}
	
	private int[] getNextShot() {
		int row;
		int col;
		do {
			row = this.random(0, b.size());
			col = this.random(0, b.size());
		} while( this.getPlace(row, col).isHit() || this.getPlace(row, col).hasShip() );
		return new int[]{row, col};
	}
	
	private Ship getNextShip() {
		int row;
		int col;
		do {
			row = this.random(0, b.size());
			col = this.random(0, b.size());
		} while( this.getPlace(row, col).isHit() || !this.getPlace(row, col).hasShip() || (this.getPlace(row, col).hasShip() &&this.getPlace(row, col).ship().isSunk()) );
		return this.getPlace(row, col).ship();
	}

	@Override
	public void fire() {
		if( (ship == null || ship.isSunk()) && !this.b.isGameOver() ) {
			ship = getNextShip();
			this.shipPlaces = new Stack<Place>();
			
			for (Place p : this.ship.places()) {
			    this.shipPlaces.push(p);
			}
		}
		
		if( shotNumber % 2 == 0 || this.b.isGameOver() ) {
			missShot();
		} else {
			hitShot();
		}
		shotNumber++;
	}
	
	private void missShot() {
		int[] coords = getNextShot();
		this.b.hit(this.getPlace(coords[0], coords[1]));
	}
	
	private void hitShot() {
		this.b.hit(this.shipPlaces.pop());
	}

}
