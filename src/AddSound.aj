//
//
//import java.io.IOException;
//
//import javax.sound.sampled.AudioInputStream;
//import javax.sound.sampled.AudioSystem;
//import javax.sound.sampled.Clip;
//import javax.sound.sampled.LineUnavailableException;
//import javax.sound.sampled.UnsupportedAudioFileException;
//
//import battleship.BoardPanel;
//import battleship.model.Place;
//import battleship.model.Board;
//import battleship.model.Ship;
//
//
//public aspect AddSound {
//	 /** Directory where audio files are stored. */
//    private static final String SOUND_DIR = "../sounds/";
//    
//    after(): execution (void BoardPanel.placeClicked(Place)){
//		System.out.println("YOU SUNK A SHIP");		
//		playAudio("torpedo.wav");
//    }
//    
//    /*
//     * Make sound where the ship is sunk
//     */
//    after(): execution (void Board.notifyShipSunk(Ship)){
//		System.out.println("YOU SUNK A SHIP");
//		playAudio("miss.wav");
//    }
//    
//    
//    /** Play the given audio file. Inefficient because a file will be 
//     * (re)loaded each time it is played. */
//    public static void playAudio(String filename) {
//      try {
//          AudioInputStream audioIn = AudioSystem.getAudioInputStream(
//	    AddSound.class.getResource(SOUND_DIR + filename));
//          Clip clip = AudioSystem.getClip();
//          clip.open(audioIn);
//          clip.start();
//      } catch (UnsupportedAudioFileException 
//            | IOException | LineUnavailableException e) {
//          e.printStackTrace();
//      }
//    }
//}
