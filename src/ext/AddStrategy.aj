package ext;
import javax.swing.JButton;
import javax.swing.JPanel;

import battleship.BattleshipDialog;

privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	after(BattleshipDialog dialog): this(dialog) && execution(JPanel BattleshipDialog.makeControlPane()){
		dialog.playButton.setText("Practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playButton);
	}
	
}