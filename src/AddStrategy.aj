import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_LEFT_MARGIN;
import static battleship.Constants.DEFAULT_MISS_COLOR;
import static battleship.Constants.DEFAULT_TOP_MARGIN;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.util.Random;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Ship;


privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	private boolean playMode = false;
	private BattleshipDialog dialogHolder = null;
	private JPanel ships;
	
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
		view.setPreferredSize(new Dimension(80, 150));
		
		JPanel mine = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel1 = new JLabel("Minesweeper");
		mine.add(jlabel1);
		for( int i = 0; i < 2; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			mine.add(button);
		}
		
		JPanel sub = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel2 = new JLabel("Submarine");
		sub.add(jlabel2);
		for( int i = 0; i < 3; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			sub.add(button);
		}
		
		JPanel frigate = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel3 = new JLabel("Frigate");
		frigate.add(jlabel3);
		for( int i = 0; i < 3; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			frigate.add(button);
		}
		
		JPanel battleship = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel4 = new JLabel("Battleship");
		battleship.add(jlabel4);
		for( int i = 0; i < 4; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			battleship.add(button);
		}
		
		JPanel carrier = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel5 = new JLabel("Aircraft carrier");
		carrier.add(jlabel5);
		for( int i = 0; i < 5; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			carrier.add(button);
		}
		
		view.add(mine, BorderLayout.WEST);
		view.add(sub, BorderLayout.WEST);
		view.add(frigate, BorderLayout.WEST);
		view.add(battleship, BorderLayout.WEST);
		view.add(carrier, BorderLayout.WEST);
		
		Board holder = new Board(10);
		
		Random random = new Random();
        int size = holder.size();
        for (Ship ship : holder.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!holder.placeShip(ship, i, j, dir));
        }
		
		container.add(view);
		JPanel secondView = new BoardPanel(
				holder,
				DEFAULT_TOP_MARGIN, DEFAULT_LEFT_MARGIN, 10,
	    	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR
				);
		
		container.add(secondView);
		
//		container.setVisible(false);
		
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
			this.dialogHolder.startNewGame();
		}
	}
	
}
