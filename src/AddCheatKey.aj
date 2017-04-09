import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JPanel;
import battleship.*;
import battleship.model.Place;

privileged aspect AddCheatKey {
//	long around(int x): call(long math.fact(int)) && args(x) {
	void around(Graphics g): args(g) && this(BoardPanel) && call(void BoardPanel.paint(Graphics)) {
		System.out.println("ran");
		BoardPanel panel = (BoardPanel) thisJoinPoint.getThis();
		
		proceed(g);
		
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
