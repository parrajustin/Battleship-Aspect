package ext;

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
	
	private boolean BoardPanel.cheatEnabled=false;
	
	private void BoardPanel.drawShips(Graphics g,Color color){
		   final Color oldColor = g.getColor();
	        for (Place p: board.places()) {
	    		if (p.hasShip()) {
	    				int x = leftMargin + (p.getX() - 1) * placeSize;
	    		    	int y = topMargin + (p.getY() - 1) * placeSize;
	                    g.setColor(color);
	                    g.drawLine(x, y, x+placeSize, y);
	                    g.drawLine(x+placeSize, y, x+placeSize, y+placeSize);
	                    g.drawLine(x, y, x, y+placeSize);
	                    g.drawLine(x, y+placeSize, x+placeSize, y+placeSize);
	                }
	        }
	        g.setColor(oldColor);
	    }
	@SuppressWarnings("serial")
    private static class KeyAction extends AbstractAction {
       private final BoardPanel boardPanel;
       
       public KeyAction(BoardPanel boardPanel, String command) {
           this.boardPanel = boardPanel;
           putValue(ACTION_COMMAND_KEY, command);
       }
       
       /** Called when a cheat is requested. */
       public void actionPerformed(ActionEvent event) {
    	   
    	   if(!boardPanel.cheatEnabled){
    		   boardPanel.drawShips(boardPanel.getGraphics(),Color.YELLOW);
    		   boardPanel.cheatEnabled=true;
    	   }else{
    		   boardPanel.drawShips(boardPanel.getGraphics(),Color.BLACK);
    		   boardPanel.cheatEnabled=false;
    	   }
       }   
    }
	
	after(BoardPanel panel):target(panel) && initialization(BoardPanel.new(Board))&&!within(AddCheatKey){
		 ActionMap actionMap = panel.getActionMap();
	     int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
	     InputMap inputMap = panel.getInputMap(condition);
	     String cheat = "Cheat";
	     inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);
	     actionMap.put(cheat, new KeyAction(panel, cheat));
	     
	}
	
	void around(BoardPanel panel,Graphics g):args(g)&& target(panel) && call(void BoardPanel.drawPlaces(Graphics)){
		proceed(panel,g);
		if(panel.cheatEnabled){
			final Color oldColor = g.getColor();
	        for (Place p: panel.board.places()) {
	    		if (p.hasShip()) {
	    				int x = panel.leftMargin + (p.getX() - 1) * panel.placeSize;
	    		    	int y = panel.topMargin + (p.getY() - 1) * panel.placeSize;
	                    g.setColor(Color.YELLOW);
	                    g.drawLine(x, y, x+panel.placeSize, y);
	                    g.drawLine(x+panel.placeSize, y, x+panel.placeSize, y+panel.placeSize);
	                    g.drawLine(x, y, x, y+panel.placeSize);
	                    g.drawLine(x, y+panel.placeSize, x+panel.placeSize, y+panel.placeSize);
	                }
	        }
	        g.setColor(oldColor);
		}
	}
	
}
