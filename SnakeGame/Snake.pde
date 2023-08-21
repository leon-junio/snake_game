/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

import java.util.List;
import java.util.ArrayList;

public class Snake {

  public Snake() {
  }

  private static final int FOOD_COLISION_TOLERANCE = 10, BODY_COLISION_TOLERANCE = 1;
  private List<SnakeBody> snakeBody = new ArrayList<>();

  public List<SnakeBody> getSnakeBody() {
    return snakeBody;
  }

  public void setSnakeBody(List<SnakeBody> snakeBody) {
    this.snakeBody = snakeBody;
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
   * Update position of snakeHead
   * @param movement SnakeMove that user typed
   * @return SnakeBody the snake body at the specified index
   */
  public void updatePosition(SnakeMove movement) {
    getSnakeHead().setMovement(movement);
  }

  /**
   * Adds a new SnakeBody to the snake.
   * @param body The SnakeBody to be added.
   */
  public void addSnakeBody(SnakeBody body) {
    snakeBody.add(body);
  }

  /**
   * Gets the first position of the snake.
   * @return Position The first position of the snake.
   */
  public int[] getFirstPosition() {
    return getSnakeHead().getPosition();
  }

  /**
   * Destroys the snake by clearing its body and positions.
   */
  public void destroySnake() {
    snakeBody.clear();
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
    body.setX(body.getX() + offset[0]);
    body.setY(body.getY() +offset[1]);
    addSnakeBody(body);
  }

  /**
   * Updates the movement of the snake and checks for collisions with food, borders and body.
   * If the snake collides with food, a new food is created and the score is updated.
   * If the snake collides with borders or body, the game is over.
   */
  public void updateMovement() {
    if (snakeBody.size() > 1) {
        for (int index = snakeBody.size() - 1; index > 0; index--) {
            var currentBody = snakeBody.get(index);
            var previousBody = snakeBody.get(index - 1);
            currentBody.setX(previousBody.getX());
            currentBody.setY(previousBody.getY());
            currentBody.setMovement(previousBody.getMovement());
        }
    }
    updateHeadPosition();
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
  public void startSnake(int[] position) {
    addSnakeBody(new SnakeBody(SnakeMove.UP, position));
  }

  /**
   * Updates the position of all snake pieces of body.
   */
  private void updateHeadPosition() {
     getSnakeHead().doMovement(SnakeGame.VELOCITY);
  }


  /**
   * Checks if the snake's head collides with its body.
   * @return true if there is a collision, false otherwise.
   */
  private boolean checkCollisionWithBody() {
    var firstBody = getSnakeHead();
    var result = false;
    for (int index = 1; index < snakeBody.size(); index++) {
      var body = snakeBody.get(index);
      if (Math.abs(body.getX() - firstBody.getX()) <= BODY_COLISION_TOLERANCE &&
        Math.abs(body.getY() - firstBody.getY()) <= BODY_COLISION_TOLERANCE) {
        result = true;
        break;
      }
    }
    return result;
  }

  /**
   * Gets the snake's head.
   * @return SnakeBody The snake's head.
   */
  public SnakeBody getSnakeHead() {
    return snakeBody.get(0);
  }

  /**
   * Checks if the snake collides with the food.
   * @return true if the snake collides with the food, false otherwise.
   */
  private boolean checkCollisionWithFood() {
    var bodyPos = getSnakeHead();
    return (Math.abs(SnakeGame.FOOD_X - bodyPos.getX()) <= FOOD_COLISION_TOLERANCE &&
      Math.abs(SnakeGame.FOOD_Y - bodyPos.getY()) <= FOOD_COLISION_TOLERANCE);
  }

  /**
   * Checks if the snake has collided with the game borders.
   * @return true if the snake has collided with the borders, false otherwise.
   */
  private boolean checkCollisionWithBorders() {
    var body = getSnakeHead();
    return  (body.getX() < SnakeGame.BORDER || body.getX() > SnakeGame.W - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_W ||
      body.getY() < SnakeGame.BORDER || body.getY() > SnakeGame.H - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_H);
  }
}
