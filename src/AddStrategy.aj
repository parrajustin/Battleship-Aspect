import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_LEFT_MARGIN;
import static battleship.Constants.DEFAULT_MISS_COLOR;
import static battleship.Constants.DEFAULT_TOP_MARGIN;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
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
import battleship.model.Place;
import battleship.model.Ship;


privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	private boolean playMode = false;
	private BattleshipDialog dialogHolder = null;
	private JPanel ships;
	private Board board;
	
	JButton[] mineButtons;
	JButton[] subButtons;
	JButton[] frigButtons;
	JButton[] battleButtons;
	JButton[] carrierButtons;
	
	int mineI = 0;
	int subI = 0;
	int frigI = 0;
	int battleI = 0;
	int carrierI = 0;
	
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
		this.ships = container;
		container.setLayout(new BoxLayout(container, BoxLayout.X_AXIS));
		
		JPanel view = new JPanel();
		view.setLayout(new BoxLayout(view, BoxLayout.Y_AXIS));
		view.setBorder(BorderFactory.createBevelBorder(0,Color.BLACK, Color.GRAY));
		view.setPreferredSize(new Dimension(80, 150));
		
		JPanel mine = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel1 = new JLabel("Minesweeper");
		mine.add(jlabel1);
		this.mineButtons = new JButton[2];
		for( int i = 0; i < 2; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			mine.add(button);
			this.mineButtons[i] = button;
		}
		
		JPanel sub = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel2 = new JLabel("Submarine");
		sub.add(jlabel2);
		this.subButtons = new JButton[3];
		for( int i = 0; i < 3; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			sub.add(button);
			this.subButtons[i] = button;
		}
		
		JPanel frigate = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel3 = new JLabel("Frigate");
		frigate.add(jlabel3);
		this.frigButtons = new JButton[3];
		for( int i = 0; i < 3; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			frigate.add(button);
			this.frigButtons[i] = button;
		}
		
		JPanel battleship = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel4 = new JLabel("Battleship");
		battleship.add(jlabel4);
		this.battleButtons = new JButton[4];
		for( int i = 0; i < 4; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			battleship.add(button);
			this.battleButtons[i] = button;
		}
		
		JPanel carrier = new JPanel(new FlowLayout(FlowLayout.LEFT));
		JLabel jlabel5 = new JLabel("Aircraft carrier");
		carrier.add(jlabel5);
		this.carrierButtons = new JButton[5];
		for( int i = 0; i < 5; i++ ) {
			JButton button = new JButton("");
			button.setBorderPainted( false );
			button.setFocusPainted( false );
			button.setPreferredSize(new Dimension(10, 10));
			button.setForeground(Color.GRAY);
			button.setBackground(Color.GRAY);
			carrier.add(button);
			this.carrierButtons[i] = button;
		}
		
		view.add(mine, BorderLayout.WEST);
		view.add(sub, BorderLayout.WEST);
		view.add(frigate, BorderLayout.WEST);
		view.add(battleship, BorderLayout.WEST);
		view.add(carrier, BorderLayout.WEST);
		
		Board holder = new Board(10);
		this.board = holder;
		
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
        holder.addBoardChangeListener(new Board.BoardChangeAdapter() {
            public void hit(Place place, int numOfShots) {
            	if( place.hasShip() && place.ship().name() == "Minesweeper" ) {
            		mineButtons[mineI].setForeground(Color.RED);
            		mineButtons[mineI].setBackground(Color.RED);
            		mineI++;
            	}
            	else if( place.hasShip() && place.ship().name() == "Submarine" ) {
            		subButtons[subI].setForeground(Color.RED);
            		subButtons[subI].setBackground(Color.RED);
            		subI++;
            	}
            	else if( place.hasShip() && place.ship().name() == "Frigate" ) {
            		frigButtons[frigI].setForeground(Color.RED);
            		frigButtons[frigI].setBackground(Color.RED);
            		frigI++;
            	}
            	else if( place.hasShip() && place.ship().name() == "Battleship" ) {
            		battleButtons[battleI].setForeground(Color.RED);
            		battleButtons[battleI].setBackground(Color.RED);
            		battleI++;
            	}
            	else if( place.hasShip() && place.ship().name() == "Aircraft carrier" ) {
            		carrierButtons[carrierI].setForeground(Color.RED);
            		carrierButtons[carrierI].setBackground(Color.RED);
            		carrierI++;
            	}
            }
        });
		
		container.add(view);
		BoardPanel secondView = new BoardPanel(
				holder,
				DEFAULT_TOP_MARGIN, DEFAULT_LEFT_MARGIN, 10,
	    	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR
				);
		secondView.removeMouseListener(secondView.getMouseListeners()[0]);
		
		container.add(secondView);
		container.setVisible(this.playMode);
		content.add(container, BorderLayout.CENTER);		
		return content;	
	}
	
	/**
	 * Done Whenever the practice button is pushed, used to reset the game if in play mode
	 */
	void around(): call(void BattleshipDialog.startNewGame()) && withincode(void BattleshipDialog.playButtonClicked(ActionEvent)) {
		/**
		 * We need to reset the other game mode since it doesn't have a nice clean mode
		 */
		if( playMode ) {
			playMode = false;
			this.ships.setVisible(playMode);
			
			resetPlayMode();
		}
		proceed();	
	}
	
	public void resetPlayMode() {
		this.mineI = 0;
		this.subI = 0;
		this.battleI = 0;
		this.frigI = 0;
		this.carrierI = 0;
		
		for(JButton b: mineButtons) {
			b.setForeground(Color.GRAY);
			b.setBackground(Color.GRAY);
		}
		for(JButton b: subButtons) {
			b.setForeground(Color.GRAY);
			b.setBackground(Color.GRAY);
		}
		for(JButton b: frigButtons) {
			b.setForeground(Color.GRAY);
			b.setBackground(Color.GRAY);
		}
		for(JButton b: battleButtons) {
			b.setForeground(Color.GRAY);
			b.setBackground(Color.GRAY);
		}
		for(JButton b: carrierButtons) {
			b.setForeground(Color.GRAY);
			b.setBackground(Color.GRAY);
		}
		
		this.board.reset();
		
		int size = board.size();
		Random random = new Random();
        for (Ship ship : board.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!board.placeShip(ship, i, j, dir));
        }
	}
	
	public void playButtonClicked(ActionEvent event) {
		if( !playMode )
			playMode = true;
		else
			resetPlayMode();
		this.dialogHolder.startNewGame();
		this.ships.setVisible(playMode);
	}
	
}
