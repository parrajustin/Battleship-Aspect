import battleship.BattleshipDialog;

public aspect Entry {

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
