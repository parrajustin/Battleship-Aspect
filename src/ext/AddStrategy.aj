package ext;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.util.Random;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

import static battleship.Constants.*;

privileged aspect AddStrategy {
	private JButton playButton = new JButton("Play");
	private boolean playMode = false;
	private BattleshipDialog dialogHolder = null;
	private JPanel ships;
	private Board board;
	
	after(BattleshipDialog dialog): this(dialog) && execution(JPanel BattleshipDialog.makeControlPane()){
		if( this.dialogHolder == null ) {
			this.dialogHolder = dialog;
		}
		dialog.playButton.setText("Practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playButton);
		playButton.addActionListener(this::playButtonClicked);
	}
	
	JPanel around(): call(JPanel BattleshipDialog.makeControlPane()) {
		JPanel content = proceed();
		
		JPanel container = new JPanel();
		container.setLayout(new BoxLayout(container, BoxLayout.X_AXIS));
		this.ships = container;
		
		JPanel view = new JPanel();
		view.setLayout(new BoxLayout(view, BoxLayout.X_AXIS));/*Changed to X_AXIS*/
		view.setBorder(BorderFactory.createBevelBorder(0,Color.BLACK, Color.GRAY));
		view.setPreferredSize(new Dimension(100, 150));
		
		Board holder = new Board(10);
		this.board = holder;
		/*Create the ships panels*/
		ShipPanel ship1 = new ShipPanel(holder,"Aircraft carrier");
		ShipPanel ship2 = new ShipPanel(holder,"Battleship");
		ShipPanel ship3 = new ShipPanel(holder,"Frigate");
		ShipPanel ship4 = new ShipPanel(holder,"Submarine");
		ShipPanel ship5 = new ShipPanel(holder,"Minesweeper");
		/*Create the labels*/
		JLabel jlabel1 = new JLabel("Aircraft carrier");
		JLabel jlabel2 = new JLabel("Battleship");
		JLabel jlabel3 = new JLabel("Frigate");
		JLabel jlabel4 = new JLabel("Submarine");
		JLabel jlabel5 = new JLabel("Minesweeper");
		/*New panel with Y_Axis layout to hold the ship panels*/
		JPanel ships =new JPanel();
		ships.setLayout(new BoxLayout(ships, BoxLayout.Y_AXIS));
		/*New panel with Y_Axis layout to hold the ship labels*/
		JPanel labels = new JPanel();
		labels.setLayout(new BoxLayout(labels, BoxLayout.Y_AXIS));
		
		/*Is there a better way to do this???*/
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		labels.add(jlabel1);
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		labels.add(jlabel2);
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		labels.add(jlabel3);
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		labels.add(jlabel4);
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		labels.add(jlabel5);
		labels.add(Box.createRigidArea(new Dimension(0,12)));
		
		ships.add(ship1);
		ships.add(ship2);
		ships.add(ship3);
		ships.add(ship4);
		ships.add(ship5);
		/*Add labels and panels to view*/
		view.add(labels);
		view.add(ships);
		
		/*Changed to a method to save space*/
		placeShips(holder);
		
        /*Is there a better way to do this???*/
        holder.addBoardChangeListener(new Board.BoardChangeAdapter() {
            public void hit(Place place, int numOfShots) {
            	if( place.hasShip() && place.ship().name() == "Minesweeper" ) {
            		ship5.repaint();
            	}
            	else if( place.hasShip() && place.ship().name() == "Submarine" ) {
            		ship4.repaint();
            	}
            	else if( place.hasShip() && place.ship().name() == "Frigate" ) {
            		ship3.repaint();
            	}
            	else if( place.hasShip() && place.ship().name() == "Battleship" ) {
            		ship2.repaint();;
            	}
            	else if( place.hasShip() && place.ship().name() == "Aircraft carrier" ) {
            		ship1.repaint();
            	}
            }
        });
        container.add(view);
		JPanel secondView = new BoardPanel(
				holder,
				DEFAULT_TOP_MARGIN, DEFAULT_LEFT_MARGIN, 10,
	    	    DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR
				);
		container.add(secondView);
		container.setVisible(true);
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
		this.board.reset();
		placeShips(this.board);
	}
	
	public void playButtonClicked(ActionEvent event) {
		if( !playMode )
			playMode = true;
		else
			resetPlayMode();
		this.dialogHolder.startNewGame();
		this.ships.setVisible(playMode);
	}
	
	/*Created this method to save space*/
	private void placeShips(Board battleboard){
		Random random = new Random();
        int size = battleboard.size();
        for (Ship ship : battleboard.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!battleboard.placeShip(ship, i, j, dir));
        }
	}
}