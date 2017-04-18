

import java.awt.Dimension;
import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Place;
import battleship.model.Board;
import battleship.model.Ship;


privileged aspect AddSound {
	 /** Directory where audio files are stored. */
    private static final String SOUND_DIR = "./sounds/";
    AudioInputStream hit;
    AudioInputStream sink;
    Clip hitClip;
    Clip sinkClip;
    
    /**
     * This advice will setup the audio system
     */
	after(): execution(BattleshipDialog.new()) && this(BattleshipDialog) {
		try {
			hit = AudioSystem.getAudioInputStream(AddSound.class.getResource(SOUND_DIR + "miss.wav"));
			sink = AudioSystem.getAudioInputStream(AddSound.class.getResource(SOUND_DIR + "torpedo.wav"));
			hitClip = AudioSystem.getClip();
			hitClip.open(hit);
			hitClip.stop();
			sinkClip = AudioSystem.getClip();
			sinkClip.open(sink);
			sinkClip.stop();
			
		} catch (UnsupportedAudioFileException | IOException | LineUnavailableException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
    
	/**
	 * This is ran after everytime the place is clicked that does not belong to the ai board
	 * @param place place that was clicked
	 */
    void around(Place place):  call(void BoardPanel.placeClicked(Place)) && args(place) && target(BoardPanel) {
    	proceed(place);
    	
    	BoardPanel boardPane = (BoardPanel) thisJoinPoint.getTarget();
    	if( (!place.hasShip() || !place.ship().isSunk()) && boardPane.getParent().getY() == 0 && !boardPane.board.isGameOver() ) {
    		
			if( hitClip.isRunning() ) {
				hitClip.stop();
				hitClip.setFramePosition(0);
				hitClip.start();
			} else {
				hitClip.setFramePosition(0);
				hitClip.start();
			}
			
    	}
    }
    
    /*
     * Make sound where the ship is sunk
     */
    void around(Ship ship): call(void Board.notifyShipSunk(Ship)) && args(ship) && target(Board) {
    	proceed(ship);
    	
    	if( ship.isSunk() ) {    	
			if( sinkClip.isRunning() ) {
				sinkClip.stop();
				sinkClip.setFramePosition(0);
				sinkClip.start();
			} else {
				sinkClip.setFramePosition(0);
				sinkClip.start();
			}
    	}
    }
    
    
}
