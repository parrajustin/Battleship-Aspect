import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import static battleship.Constants.*;
import battleship.model.*;


privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	private boolean playMode = false;
	private BattleshipDialog dialogHolder = null;
	private JPanel topView;
	
	/**
	 * Done to create the practice and play buttons
	 * @param dialog
	 */
	after(BattleshipDialog dialog): this(dialog) && execution(JPanel BattleshipDialog.makeControlPane()) {
		if( this.dialogHolder == null ) {
			this.dialogHolder = dialog;
		}
		
		dialog.playButton.setText("practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playButton);

        playButton.addActionListener(this::playButtonClicked);
	}
	
	/**
	 * Done to add the new control panel additions
	 * @return
	 */
	JPanel around(): call(JPanel BattleshipDialog.makeControlPane()) {
		JPanel content = proceed();
		
		JPanel container = new JPanel();
		container.setLayout(new BoxLayout(container, BoxLayout.X_AXIS));
		
		JPanel view = new JPanel();
		view.setLayout(new BoxLayout(view, BoxLayout.Y_AXIS));
		view.setBorder(BorderFactory.createBevelBorder(0,Color.BLACK, Color.GRAY));
		
		JPanel mine = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel1 = new JLabel("Minesweeper");
		mine.add(jlabel1);
		
		JPanel sub = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel2 = new JLabel("Submarine");
		sub.add(jlabel2);
		
		JPanel frigate = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel3 = new JLabel("Frigate");
		frigate.add(jlabel3);
		
		JPanel battleship = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel4 = new JLabel("Battleship");
		battleship.add(jlabel4);
		
		JPanel carrier = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel5 = new JLabel("Aircraft carrier");
		carrier.add(jlabel5);
		
		view.add(mine, BorderLayout.WEST);
		view.add(sub, BorderLayout.WEST);
		view.add(frigate, BorderLayout.WEST);
		view.add(battleship, BorderLayout.WEST);
		view.add(carrier, BorderLayout.WEST);
		
		container.add(view);
		JPanel secondView = new BoardPanel(
				new Board(10),
				DEFAULT_TOP_MARGIN, DEFAULT_LEFT_MARGIN, 10,
	    	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR
				);
		
		container.add(secondView);
		content.add(container, BorderLayout.CENTER);		
		
		return content;	
	}
	
	/**
	 * Done Whenever the practice button is pushed, used to reset the game if in play mode
	 */
	void around(): call(void BattleshipDialog.startNewGame()) && withincode(void BattleshipDialog.playButtonClicked(ActionEvent)) {
		playMode = false;
		proceed();	
	}
	
	public void playButtonClicked(ActionEvent event) {
		if( !playMode ) {
			playMode = true;
			this.dialogHolder.makeControlPane();
		}
	}
	
}
