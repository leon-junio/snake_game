/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class Snake {

  public Snake() {
  }

  private static final int FOOD_COLISION_TOLERANCE = 10, BODY_COLISION_TOLERANCE = 1;
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

  /**
   * Get the size of the snake body
   * @return int the size of the snake body
   */
  public int bodySize() {
    return snakeBody.size();
  }

  /**
   * Get the snake body at the specified index
   * @param index the index of the snake body
   * @return SnakeBody the snake body at the specified index
   */
  public SnakeBody getBody(int index) {
    return snakeBody.get(index);
  }

  /**
   * Get the snake body at the specified index
   * @param index the index of the snake body
   * @return SnakeBody the snake body at the specified index
   */
  public void addPosition(Position position, SnakeMove movement) {
    positions.put(position.clone(), movement);
  }

  /**
   * Adds a new SnakeBody to the snake.
   * @param body The SnakeBody to be added.
   */
  public void addSnakeBody(SnakeBody body) {
    snakeBody.add(body);
  }

  /**
   * Gets the position of the snake.
   * @param position The position to be retrieved.
   */
  public void getPosition(Position position) {
    positions.get(position);
  }

  /**
   * Gets the first position of the snake.
   * @return Position The first position of the snake.
   */
  public Position getFirstPosition() {
    return snakeBody.get(0).position;
  }

  /**
   * Destroys the snake by clearing its body and positions.
   */
  public void destroySnake() {
    snakeBody.clear();
    if (!positions.isEmpty())
      positions.clear();
  }

  /**
   * Adds a new body to the snake.
   * The new body is created based on the last body's position and movement.
   * The new body is positioned one movement offset away from the last body.
   */
  public void newBody() {
    var lastBody = snakeBody.get(snakeBody.size()-1);
    var positions = lastBody.getPosition();
    var movement = lastBody.getMovement();
    var offset = movement.getOffset();
    var body = new SnakeBody(movement, positions);
    body.position.sum(offset[0], offset[1]);
    addSnakeBody(body);
  }

  /**
   * Updates the movement of the snake and checks for collisions with food, borders and body.
   * If the snake collides with food, a new food is created and the score is updated.
   * If the snake collides with borders or body, the game is over.
   */
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
    if (checkCollisionWithFood()) {
      SnakeGame.newFood();
      newBody();
      SnakeGame.updateScore();
    }
    if (checkCollisionWithBorders() || checkCollisionWithBody()) {
      SnakeGame.gameOver();
    }
  }

  /**
   * Starts the snake at the specified position.
   * @param position The position to start the snake.
   */
  public void startSnake(Integer[] position) {
    addPosition(new Position(position), SnakeMove.UP);
    addSnakeBody(new SnakeBody(SnakeMove.UP, new Position(position)));
  }

  /**
   * Updates the position of all snake pieces of body.
   */
  private void updateAllPositions() {
    for (var body : snakeBody) {
      body.doMovement(SnakeGame.VELOCITY);
    }
  }


  /**
   * Checks if the snake's head collides with its body.
   * @return true if there is a collision, false otherwise.
   */
  private boolean checkCollisionWithBody() {
    var firstPosition = getFirstPosition();
    var result = false;
    for (int index = 1; index < snakeBody.size(); index++) {
      var bodyPos = snakeBody.get(index).getPosition();
      if (Math.abs(bodyPos.getX() - firstPosition.getX()) <= BODY_COLISION_TOLERANCE &&
        Math.abs(bodyPos.getY() - firstPosition.getY()) <= BODY_COLISION_TOLERANCE) {
        result = true;
        break;
      }
    }
    return result;
  }


  /**
   * Checks if the snake collides with the food.
   * @return true if the snake collides with the food, false otherwise.
   */
  private boolean checkCollisionWithFood() {
    var firstPosition = getFirstPosition();
    var foodPosition = SnakeGame.food.getPosition();
    return (Math.abs(foodPosition.getX() - firstPosition.getX()) <= FOOD_COLISION_TOLERANCE &&
      Math.abs(foodPosition.getY() - firstPosition.getY()) <= FOOD_COLISION_TOLERANCE);
  }

  /**
   * Checks if the snake has collided with the game borders.
   * @return true if the snake has collided with the borders, false otherwise.
   */
  private boolean checkCollisionWithBorders() {
    var position = getFirstPosition();
    return  (position.getX() < SnakeGame.BORDER || position.getX() > SnakeGame.W - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_W ||
      position.getY() < SnakeGame.BORDER || position.getY() > SnakeGame.H - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_H);
  }

  /**
   * Checks if the last body of the snake has been reached and removes its position from the positions map if so.
   * @param index The index of the current body part being checked.
   */
  private void checkLastBody(int index) {
    if (snakeBody.size() == 1 || index == snakeBody.size()-1) {
      positions.remove(snakeBody.get(index).getPosition());
    }
  }

  /**
   * Checks if the given body position is one joint of movement.
   * @param bodyPosition The position to be checked.
   * @return True if the position is already occupied, false otherwise.
   */
  private boolean checkBodyPosition(Position bodyPosition) {
    return positions.containsKey(bodyPosition);
  }
}
