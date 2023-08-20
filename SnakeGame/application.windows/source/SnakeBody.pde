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

  public void doMovement(Integer velocity) {
    var positionAux = movement.run(position.toArray(), velocity);
    position = new Position(new Integer[]{positionAux[0], positionAux[1]});
  }
}
