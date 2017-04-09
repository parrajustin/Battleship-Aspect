import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.swing.JButton;
import javax.swing.JPanel;

import battleship.BattleshipDialog;


privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	Map<Integer, Integer> cache = new ConcurrentHashMap<>();

	
	after(BattleshipDialog dialog): this(dialog) && execution(JPanel BattleshipDialog.makeControlPane()) {
		dialog.playButton.setText("practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playButton);
	}
}
