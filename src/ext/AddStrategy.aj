//package ext;
//import battleship.BattleshipDialog.*;
//
//import java.awt.event.ActionEvent;
//
//import javax.swing.JButton;
//import javax.swing.JOptionPane;
//import javax.swing.JPanel;
//
//import battleship.BattleshipDialog;
//
//public privileged aspect AddStrategy {
////private static final int DISPOSE_ON_CLOSE = 0;
//	private JButton playButton = new JButton("Play");
//	after(BattleshipDialog dialog): this(dialog) 
//	&& execution(JPanel BattleshipDialog.makeControlPane()){
//		dialog.playButton.setText("Practice");
//		JPanel buttons = (JPanel)dialog.playButton.getParent();
//		
//        playButton.addActionListener(this::playButtonClicked);
//		buttons.add(playButton);
//		
//	}
//	
//	public void playButtonClicked(ActionEvent event){
//		/*if(JOptionPane.showConfirmDialog(BattleshipDialog.this,"play game?", "Battleship",JOptionPane.YES_NO_OPTION == JOptionPane.YES_OPTION)))
//		BattleshipDialog.startNewGame();*/
//	    //startNewGame();
//		System.out.println("WORKSSSSS");
//	}
//	
//}	