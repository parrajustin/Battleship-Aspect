import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import javax.swing.JPanel;

import battleship.model.Board;
import battleship.model.Place;
import static battleship.Constants.*;

public class ShipPanel extends JPanel {
	/**
     * Height of the blank space above the board panel in pixel. It is 10 by
     * default.
     */
    protected final int topMargin;

    /**
     * Width of the blank space left of the board panel in pixel. It is 10 by
     * default.
     */
    protected final int leftMargin;

    /**
     * Number of pixels between horizontal/vertical lines of the board panel to
     * present places. By default, it is 30.
     */
    protected int placeSize;

    /**
     * Number of rows/columns of the battleship board. The board will have
     * <code>boardSize x boardSize</code> places.
     */
    protected int shipSize;

    /** Background color of the board. It's blue by default. */
    protected Color boardColor;

    /** Color for drawing places that are hit and have a ship. */
    protected final Color hitColor;

    /** Color for drawing places that are hit but have no ship. */
    protected final Color missColor;

    /** Foreground color for drawing 2-d grid lines for board and places. */
    protected final Color lineColor = DEFAULT_LINE_COLOR;

    /** Battleship board to be displayed by this panel. */
    protected final Board board;
    
    protected final String shipName;
    
    protected int hits=0;
    
    public ShipPanel(Board battleBoard, String name){
    	this(battleBoard, name,
        	   10, 0, DEFAULT_PLACE_SIZE,
        	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR);
        }
    
    public ShipPanel(Board board, String name,
            int topMargin, int leftMargin, int placeSize,
            Color boardColor, Color hitColor, Color missColor){
    	this.board = board;
    	this.shipName=name;
    	this.shipSize = board.ship(name).size();
    	this.topMargin = topMargin;
    	this.leftMargin = leftMargin;
    	this.placeSize = placeSize/2;
    	this.boardColor = boardColor;
    	this.hitColor = hitColor;
    	this.missColor = missColor;
    	setPreferredSize(new Dimension(155,35));
    	
    }
    
    public void paint(Graphics g) {
        super.paint(g); // clear the background
        drawGrid(g);
        drawPlaces(g);
    }

    /*Modified code from BoardPanel*/
    private void drawGrid(Graphics g) {
        Color oldColor = g.getColor(); 

        // fill the background of the frame.
		final int frameSize = shipSize * placeSize;
        g.setColor(boardColor);
        g.fillRect(leftMargin, topMargin, frameSize, placeSize);
        
        // draw vertical and horizontal lines
        g.setColor(lineColor);
        int x = leftMargin;
        int y = topMargin;
        for (int i = 0; i <= shipSize; i++) {
            g.drawLine(x, topMargin, x, topMargin + placeSize);
            if(i<2){
            	g.drawLine(leftMargin, y, leftMargin + frameSize, y);
            }
            x += placeSize;
            y += placeSize;
        }

        g.setColor(oldColor);
    }
    
    /*Modified code from BoardPanel*/
    private void drawPlaces(Graphics g) {
        final Color oldColor = g.getColor();
        for (Place p: board.ship(shipName).places()) {
    		if (p.isHit()) {
    		    int x = leftMargin + hits * placeSize;
    		    int y = topMargin;
    		    g.setColor(hitColor);
    		    g.fillRect(x + 1, y + 1, placeSize - 1, placeSize - 1);
                if (p.hasShip() && p.ship().isSunk()) {
                    g.setColor(Color.BLACK);
                    g.drawLine(x + 1, y + 1,
                            x + placeSize - 1, y + placeSize - 1);
                    g.drawLine(x + 1, y + placeSize - 1,
                            x + placeSize - 1, y + 1);
                }
                hits++;
    		}
        }
        hits=0;
        g.setColor(oldColor);
    }
}
    
    
