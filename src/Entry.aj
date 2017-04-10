import java.awt.Dimension;

import battleship.BattleshipDialog;

privileged aspect Entry {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		System.out.println("test2");
        BattleshipDialog dialog = new BattleshipDialog(new Dimension(335, 550));
        dialog.setVisible(true);
        dialog.setDefaultCloseOperation(BattleshipDialog.DISPOSE_ON_CLOSE);
	}
}