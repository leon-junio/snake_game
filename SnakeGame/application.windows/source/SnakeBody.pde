/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

public class SnakeBody {

  public SnakeBody(SnakeMove movement, Position position) {
    this.position = position.clone();
    this.movement = movement;
  }

  private SnakeMove movement;
  private Position position;

  public void setMovement(SnakeMove movement) {
    this.movement = movement;
  }

  public void setPosition(Position position) {
    this.position = position;
  }

  public Position getPosition() {
    return position;
  }

  public SnakeMove getMovement() {
    return movement;
  }

  /**
   * Do a movement in the snake body with a velocity value
   * @param velocity Integer value of velocity
   */
  public void doMovement(Integer velocity) {
    var positionAux = movement.run(position.toArray(), velocity);
    position = new Position(positionAux.clone());
  }
}
