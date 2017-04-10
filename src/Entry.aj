import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;

import javax.swing.AbstractAction;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Place;

privileged aspect Entry {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		System.out.println("test2");
        BattleshipDialog dialog = new BattleshipDialog();
        dialog.setVisible(true);
        dialog.setDefaultCloseOperation(BattleshipDialog.DISPOSE_ON_CLOSE);
	}
}