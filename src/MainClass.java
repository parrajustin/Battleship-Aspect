import battleship.BattleshipDialog;

public class MainClass {
    public static void main(String[] args) {
        BattleshipDialog dialog = new BattleshipDialog();
        dialog.setVisible(true);
        dialog.setDefaultCloseOperation(dialog.DISPOSE_ON_CLOSE);
    }
}
