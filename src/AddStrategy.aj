import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
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
	private BoardPanel panel;
	private Smart ai;
	
	private ArrayList<Place> places;
	
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
				10, 10, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY
				);
		secondView.removeMouseListener(secondView.getMouseListeners()[0]);
		this.panel = secondView;
		this.places = new ArrayList<Place>();
//		this.board.places().forEach(action);
		for (Place p : this.board.places()) {
		    this.places.add(p);
		}
		
		ai = new Smart(secondView, holder, places);
		
		container.add(secondView);
		container.setVisible(this.playMode);
		content.add(container, BorderLayout.CENTER);		
		return content;	
	}
	
	void around(Place p): args(p) && call(void BoardPanel.placeClicked(Place)) && target(BoardPanel) {
		boolean temp = p.isHit();
		proceed(p);
		
		if( temp != p.isHit() && this.playMode ) {
			Random rand = new Random();
//			System.out.println(this.places.get(rand.nextInt(this.places.size())).x);
			ai.fire();
			this.panel.repaint();
		}
//		BoardPanel boardPane = (BoardPanel) thisJoinPoint.getThis();
//		if( !boardPane.board.isGameOver() && !p.isHit() ) {
//			proceed(p);
//			Random rand = new Random();
//			this.places.get(rand.nextInt(this.places.size())).hit();
//		}
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

class Smart {
	BoardPanel p;
	Board b;
	ArrayList<Place> places;
	Random rand;
	int[] probs;
	
	public Smart(BoardPanel p, Board b, ArrayList<Place> places) {
		this.p = p;
		this.b = b;
		this.places = places;
		probs = new int[b.size()*b.size()];
		
		rand = new Random();
		for( int i = 0; i < probs.length; i++ ) {
			probs[i] = rand.nextInt(10) + 1;
		}
	}
	
	public void fire() {
		int index;
		do {
			index = getNext();
		} while( places.get(index).isHit() );
		
		b.hit(places.get(index));
		if( places.get(index).hasShip() ) {
			this.change(index, 0, 3, 1);
		} else {
			this.change(index, 0, 3, -1);
		}
		this.probs[index] = 0;
	}
	
	public void setProb(int row, int col, int val) {
		probs[row*b.size() + col] = val;
	}
//	public void getProb(int row, int col) {
//		probs[]
//	}
	
	private void change(int index, int min, int max, int modifier) {
		if( index % b.size() != 0 && this.probs[index-1] != 0 )
			this.probs[index-1] = this.probs[index-1] + (rand.nextInt(max-min) + min) * modifier;
		if( index % b.size() != b.size()-1 && this.probs[index+1] != 0 )
			this.probs[index+1] = this.probs[index+1] + (rand.nextInt(max-min) + min) * modifier;
		if( index / b.size() != 0 && this.probs[((index/b.size())-1) * b.size() + index % b.size()] > 0 ) {
			int north = ((index/b.size())-1) * b.size() + index % b.size();
			this.probs[north] = this.probs[north] + (rand.nextInt(max-min) + min) * modifier;
		}
		if( index / b.size() != b.size()-1 && this.probs[((index/b.size())+1) * b.size() + index % b.size()] > 0 ) {
			int south = ((index/b.size())+1) * b.size() + index % b.size();
			this.probs[south] = this.probs[south] + (rand.nextInt(max-min) + min) * modifier;
		}
	}
	
	private int getNext() {
		int index = 0;
		int prob = 0;
		for( int i = 0; i < probs.length; i++ ) {
			if( probs[i] != 0 && probs[i] > prob ) {
				prob = probs[i];
				index = i;
			} else if( probs[i] != 0 && probs[i] == prob && rand.nextInt(2) > 0 ) {
				prob = probs[i];
				index = i;
			}
		}
		
		return index;
	}
}
