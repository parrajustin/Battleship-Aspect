import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;

privileged aspect AddCheatKey {
	public boolean cheatModeActive = false;
	
	/**
	 * Done after the draw places method has been called, if cheat mode is active all ships will be lit up
	 * @param g
	 */
	void around(Graphics g): args(g) && this(BoardPanel) && call(void BoardPanel.drawPlaces(Graphics)) {
		BoardPanel panel = (BoardPanel) thisJoinPoint.getThis();
		
		proceed(g);
		
//		System.out.println(panel.getParent().getY());
		if( cheatModeActive || panel.getParent().getY() > 0 ) {
	        final Color oldColor = g.getColor();
	        for (Place p: panel.board.places()) {
	    		if (p.hasShip() && !p.isHit()) {
	    		    int x = panel.leftMargin + (p.getX() - 1) * panel.placeSize;
	    		    int y = panel.topMargin + (p.getY() - 1) * panel.placeSize;
	    		    g.fillRect(x + 1, y + 1, panel.placeSize - 1, panel.placeSize - 1);
	    		}
	        }
	        g.setColor(oldColor);
		}
	}
	
	/**
	 * Inject action map into the board panel constructor
	 */
	after(): execution(BoardPanel.new(Board)) && this(BoardPanel) {
		BoardPanel panel = (BoardPanel) thisJoinPoint.getThis();
		
		ActionMap actionMap = panel.getActionMap();
	    int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
	    InputMap inputMap = panel.getInputMap(condition);
	    String cheat = "Cheat";
	    inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
	    actionMap.put(cheat, new KeyAction(panel, cheat));
	}
	
	/**
	 * Done to intersect the key action 
	 */
	after(): this(KeyAction) && execution(void KeyAction.actionPerformed(..)) {
		KeyAction key = (KeyAction) thisJoinPoint.getThis();
		
		// if this key action was for the one for cheats do the cheat action
		if( key.getValue(key.action).equals("Cheat") ) {
			cheatModeActive = !cheatModeActive; // enable cheat mode to highlight ships
			key.boardPanel.paint(key.boardPanel.getGraphics()); // call the paint method to actually run the ship highlight advice
		}
	}
}

@SuppressWarnings("serial") class KeyAction extends AbstractAction {
	   public final BoardPanel boardPanel;
	   public final String action = ACTION_COMMAND_KEY;
	   
	   public KeyAction(BoardPanel boardPanel, String command) {
	       this.boardPanel = boardPanel;
	       putValue(action, command);
	   }
	   
	   /** Called when a cheat is requested. */
	   public void actionPerformed(ActionEvent event) {
		   // nothing
	   }   
	}
