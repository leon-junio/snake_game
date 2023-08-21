/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

public class SnakeBody {

  public SnakeBody(SnakeMove movement, int[] position) {
    this.position = position.clone();
    this.movement = movement;
  }

  private SnakeMove movement;
  private final int[] position;

  public int getX() {
    return position[0];
  }

  public int getY() {
    return position[1];
  }

  public void setX(int x) {
    position[0] = x;
  }

  public void setY(int y) {
    position[1] = y;
  }

  public int[] getPosition() {
    return position;
  }

  public void setMovement(SnakeMove movement) {
    this.movement = movement;
  }

  public SnakeMove getMovement() {
    return movement;
  }

  /**
   * Do a movement in the snake body with a velocity value
   * @param velocity int value of velocity
   */
  public void doMovement(int velocity) {
    movement.run(position, velocity);
  }
}
