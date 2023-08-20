import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class Snake {

  public Snake() {
  }

  private List<SnakeBody> snakeBody = new ArrayList<>();
  private Map<Position, SnakeMove> positions = new HashMap<>();

  public List<SnakeBody> getSnakeBody() {
    return snakeBody;
  }

  public void setSnakeBody(List<SnakeBody> snakeBody) {
    this.snakeBody = snakeBody;
  }

  public Map<Position, SnakeMove> getPositions() {
    return positions;
  }

  public void setPositions(Map<Position, SnakeMove> positions) {
    this.positions = positions;
  }

  public void addPosition(Position position, SnakeMove movement) {
    positions.put(position.clone(), movement);
  }

  public void addSnakeBody(SnakeBody body) {
    snakeBody.add(body);
  }

  public void getPosition(Position position) {
    positions.get(position);
  }

  public void destroySnake() {
    snakeBody.clear();
    if (!positions.isEmpty())
      positions.clear();
  }

  public void updateMovement() {
    if (!positions.isEmpty()) {
      for (int index = 0; index < snakeBody.size(); index++) {
        var body = snakeBody.get(index);
        if (checkBodyPosition(body.getPosition())) {
          var actualMovement = positions.get(body.getPosition());
          body.setMovement(actualMovement);
          checkLastBody(index);
        }
      }
    }
    updateAllPositions();
    if(checkCollisionWithFood()){
      SnakeGame.newFood();
      newBody();
    }
    if (checkCollisionWithBorders() || checkCollisionWithBody()) {
      SnakeGame.gameOver();
    }
  }

  public void startSnake(Integer[] position) {
    addPosition(new Position(position), SnakeMove.UP);
    addSnakeBody(new SnakeBody(SnakeMove.UP, new Position(position)));
  }

  public Position getFirstPosition() {
    return snakeBody.get(0).position;
  }

  private void updateAllPositions() {
    for (var body : snakeBody) {
      body.doMovement(SnakeGame.VELOCITY);
    }
  }

  private boolean checkCollisionWithBody() {
    var firstPosition = getFirstPosition();
    var result = false;
    for (int index = 1; index < snakeBody.size(); index++) {
      var bodyPos = snakeBody.get(index).getPosition();
      int tolerance = 1;
      if (Math.abs(bodyPos.getX() - firstPosition.getX()) <= tolerance &&
        Math.abs(bodyPos.getY() - firstPosition.getY()) <= tolerance) {
        result = true;
        break;
      }
    }
    return result;
  }

  private boolean checkCollisionWithFood(){
    var firstPosition = getFirstPosition();
    var foodPosition = SnakeGame.food.getPosition();
    int tolerance = 10;
    return (Math.abs(foodPosition.getX() - firstPosition.getX()) <= tolerance &&
      Math.abs(foodPosition.getY() - firstPosition.getY()) <= tolerance);
  }

  private boolean checkCollisionWithBorders() {
    var position = getFirstPosition();
    return  (position.getX() < SnakeGame.BORDER || position.getX() > SnakeGame.W - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_W ||
      position.getY() < SnakeGame.BORDER || position.getY() > SnakeGame.H - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_H);
  }

  private void checkLastBody(int index) {
    if (snakeBody.size() == 1 || index == snakeBody.size()-1) {
      positions.remove(snakeBody.get(index).getPosition());
    }
  }

  private boolean checkBodyPosition(Position bodyPosition) {
    return positions.containsKey(bodyPosition);
  }

  public void newBody() {
    var lastBody = snakeBody.get(snakeBody.size()-1);
    var positions = lastBody.getPosition();
    var movement = lastBody.getMovement();
    var offset = movement.getOffset();
    var body = new SnakeBody(movement, positions);
    body.position.sum(offset[0], offset[1]);
    addSnakeBody(body);
  }
}
