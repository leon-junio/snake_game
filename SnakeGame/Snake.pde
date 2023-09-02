/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

import java.util.List;
import java.util.ArrayList;

public class Snake {

  private static final byte FOOD_COLISION_TOLERANCE = 10, BODY_COLISION_TOLERANCE = 1;
  private short[] bodyX, bodyY;
  private short arrIndex;
  private SnakeMove[] movements;
  private byte gap;

  public Snake() {
    init();
  }

  public short getPositionX(int index) {
    return bodyX[index];
  }

  public short getPositionY(int index) {
    return bodyY[index];
  }

  /**
   * Init the arrays and run the calc to the screen
   */
  private void init() {
    arrIndex = 0;
    var pieces = piecesPerScreen();
    bodyX = new short[pieces];
    bodyY = new short[pieces];
    movements = new SnakeMove[pieces];
  }

  /**
   * Calc how much pieces per screen the snake can handle
   * @return int result of calc
   */
  private int piecesPerScreen() {
    return (SnakeGame.W * SnakeGame.H) / (SnakeGame.SNAKE_SIZE_W * SnakeGame.SNAKE_SIZE_H);
  }

  /**
   * Get the snake body at the specified index
   * @param index the index of the snake body
   * @return SnakeBody the snake body at the specified index
   */
  public short[] getPosition(int index) {
    return new short[]{bodyX[index], bodyY[index]};
  }

  /**
   * Update position of snakeHead
   * @param movement SnakeMove that user typed
   * @return SnakeBody the snake body at the specified index
   */
  public void updatePosition(SnakeMove movement) {
    movements[0] = movement;
  }

  /**
   * Destroys the snake by clearing its body and positions.
   */
  public void destroySnake() {
    arrIndex = 0;
  }

  /**
   * Adds a new body to the snake.
   * The new body is created based on the last body's position and movement.
   * The new body is positioned one movement offset away from the last body.
   */
  public void newBody() {
    SnakeMove movement = movements[arrIndex];
    bodyX[arrIndex+1] = (short) (getPositionX(arrIndex) + movement.getOffsetX());
    bodyY[arrIndex+1] = (short) (getPositionY(arrIndex) + movement.getOffsetY());
    movements[arrIndex+1] = movement;
    arrIndex++;
  }

  /**
   * Get the size of array
   */
  public short getSize() {
    return (short) (arrIndex + 1);
  }

  /**
   * Updates the movement of the snake and checks for collisions with food, borders and body.
   * If the snake collides with food, a new food is created and the score is updated.
   * If the snake collides with borders or body, the game is over.
   */
  public void updateMovement() {
    if (getSize() > 1) {
      for (int index = arrIndex; index > 0; index--) {
        bodyX[index] = bodyX[index - 1];
        bodyY[index] = bodyY[index - 1];
        movements[index] = movements[index-1];
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
   * @param positionX The position X to start the snake.
   * @param positionY The position Y to start the snake.
   */
  public void startSnake(short positionX, short positionY) {
    bodyX[0] = positionX;
    bodyY[0] = positionY;
    movements[0] = SnakeMove.UP;
  }

  /**
   * Updates the position of snake head body
   */
  private void updateHeadPosition() {
    doMovement(movements[0], SnakeGame.VELOCITY);
  }

  /**
   * Checks if the snake's head collides with its body.
   * @return true if there is a collision, false otherwise.
   */
  private boolean checkCollisionWithBody() {
    var result = false;
    for (int index = 1; index < getSize(); index++) {
      if (Math.abs(bodyX[index] - bodyX[0]) <= BODY_COLISION_TOLERANCE &&
        Math.abs(bodyY[index] - bodyY[0]) <= BODY_COLISION_TOLERANCE) {
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
    return (Math.abs(SnakeGame.FOOD_X - bodyX[0]) <= FOOD_COLISION_TOLERANCE &&
      Math.abs(SnakeGame.FOOD_Y - bodyY[0]) <= FOOD_COLISION_TOLERANCE);
  }

  /**
   * Checks if the snake has collided with the game borders.
   * @return true if the snake has collided with the borders, false otherwise.
   */
  private boolean checkCollisionWithBorders() {
    return  (bodyX[0] < SnakeGame.BORDER || bodyX[0] > SnakeGame.W - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_W ||
      bodyY[0] < SnakeGame.BORDER || bodyY[0] > SnakeGame.H - SnakeGame.BORDER - SnakeGame.SNAKE_SIZE_H);
  }

  /**
   * Fix body grid when snake moves over Y
   */
  private void fixBodyYGrid() {
    gap = (byte)(bodyY[0] % SnakeGame.GRID_SIZE);
    bodyY[0] = (short) (gap < 5? bodyY[0] - gap : bodyY[0] + gap);
  }

  /**
   * Fix body grid when snake moves over X
   */
  private void fixBodyXGrid() {
    gap = (byte)(bodyY[0] % SnakeGame.GRID_SIZE);
    bodyX[0] = (short) (gap < 5? bodyX[0] - gap : bodyX[0] + gap);
  }

  /**
   * Do a movement in the snake body with a velocity value
   * @param movement actual snakeMove
   * @param velocity short value of velocity
   */
  public void doMovement(SnakeMove movement, short velocity) {
    switch(movement) {
    case UP:
      bodyY[0] -= velocity;
      fixBodyYGrid();
      break;
    case DOWN:
      bodyY[0] += velocity;
      fixBodyYGrid();
      break;
    case LEFT:
      bodyX[0] -= velocity;
      fixBodyXGrid();
      break;
    case RIGHT:
      bodyX[0] += velocity;
      fixBodyXGrid();
      break;
    }
  }
}
