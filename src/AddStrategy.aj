import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import ai.DebugSmart;
import ai.RandomAI;
import ai.Smart;
import ai.Strategy;
import ai.Under34;
import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;


privileged aspect AddStrategy {
	private boolean playMode = false;
	private BattleshipDialog dialogHolder = null;
	private JPanel ships;
	private Board board;
	private BoardPanel panel;
	private Strategy ai;
	
	private ArrayList<Place> places;
	
	/**
	 * Creates the practice button
	 * @param dialog
	 */
	after(BattleshipDialog dialog): this(dialog) && execution(JPanel BattleshipDialog.makeControlPane()) {
		if( this.dialogHolder == null ) {
			this.dialogHolder = dialog;
		}
		
		JButton playButton = new JButton("Play");
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
		view.setLayout(new BoxLayout(view, BoxLayout.X_AXIS));/*Changed to X_AXIS*/
		view.setBorder(BorderFactory.createBevelBorder(0,Color.BLACK, Color.GRAY));
		view.setPreferredSize(new Dimension(100, 150));

		this.board = new Board(10);
		this.placeShips(this.board);
		/*Create the ships panels*/
		ShipPanel ship1 = new ShipPanel(this.board, "Aircraft carrier");
		ShipPanel ship2 = new ShipPanel(this.board, "Battleship");
		ShipPanel ship3 = new ShipPanel(this.board, "Frigate");
		ShipPanel ship4 = new ShipPanel(this.board, "Submarine");
		ShipPanel ship5 = new ShipPanel(this.board, "Minesweeper");
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
		
        this.board.addBoardChangeListener(new Board.BoardChangeAdapter() {
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
            		ship2.repaint();
            	}
            	else if( place.hasShip() && place.ship().name() == "Aircraft carrier" ) {
            		ship1.repaint();
            	}
            }
        });
		
		container.add(view);
		BoardPanel secondView = new BoardPanel(
				this.board,
				10, 10, 10,
				new Color(51, 153, 255), Color.RED, Color.GRAY
				);
		secondView.removeMouseListener(secondView.getMouseListeners()[0]);
		this.panel = secondView;
		this.places = new ArrayList<Place>();
		
		for (Place p : this.board.places()) {
		    this.places.add(p);
		}
		
		ai = new Smart(secondView, this.board, places);
		
		container.add(secondView);
		container.setVisible(this.playMode);
		content.add(container, BorderLayout.CENTER);		
		return content;	
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
	
	void around(Place p): args(p) && call(void BoardPanel.placeClicked(Place)) && target(BoardPanel) {
		boolean temp = p.isHit();
		if( !ai.isGameOver() )
			proceed(p);
		
		if( temp != p.isHit() && this.playMode ) {
			Random rand = new Random();
//			System.out.println(this.places.get(rand.nextInt(this.places.size())).x);
			if( !ai.isGameOver() )
				ai.fire();
			if( ai.isGameOver() ) {
				this.dialogHolder.showMessage("Game Over, You've Lost!");
				int dialogButton = JOptionPane.YES_OPTION;
				JOptionPane.showConfirmDialog(null, "You've lost! :(", "Warning", dialogButton);
			}
			
			this.panel.repaint();
		}
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
	
	/**
	 * Change the size of the battleship dialog
	 */
	after(): execution(BattleshipDialog.new()) && this(BattleshipDialog) {
		BattleshipDialog dialog = (BattleshipDialog) thisJoinPoint.getThis();
		
		dialog.setSize(new Dimension(335, 570));
	}
	
	/**
	 * Resets the battleship play mode
	 */
	public void resetPlayMode() {
		this.board.reset();
		this.placeShips(this.board);
	}
	
	/**
	 * Action taken when the play button is clicked
	 * It brings up a confirm dialog
	 * @param event
	 */
	public void playButtonClicked(ActionEvent event) {
		JPanel panel = new JPanel();
        panel.add(new JLabel("Please make a selection:"));
        DefaultComboBoxModel model = new DefaultComboBoxModel();
        model.addElement("Random");
        model.addElement("Smart");
        model.addElement("Debug Smart");
        model.addElement("Every Other");
        JComboBox comboBox = new JComboBox(model);
        panel.add(comboBox);
        
        int result = JOptionPane.showConfirmDialog(null, panel, "Flavor", JOptionPane.OK_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE);
        switch (result) {
            case JOptionPane.OK_OPTION:
                if( comboBox.getSelectedItem() == "Random" )
                	this.ai = new RandomAI(this.panel, this.board, this.places);
                else if( comboBox.getSelectedItem() == "Smart" )
                	this.ai = new Smart(this.panel, this.board, this.places);
                else if( comboBox.getSelectedItem() == "Debug Smart" )
                	this.ai = new DebugSmart(this.panel, this.board, this.places);
                else if( comboBox.getSelectedItem() == "Every Other" )
                	this.ai = new Under34(this.panel, this.board, this.places);
                
                
        		if( !playMode )
        			playMode = true;
        		else
        			resetPlayMode();
        		this.dialogHolder.startNewGame();
        		this.ships.setVisible(playMode);
                break;
        }
	
	}
	
}