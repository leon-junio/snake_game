/* autogenerated by Processing revision 1277 on 2023-08-21 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.Random;
import java.util.List;
import java.util.ArrayList;
import java.util.function.BiFunction;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class SnakeGame extends PApplet {

/**
 * Snake Game
 * @author Leon-Junio
 */



public static final int[] BG_COLOR = {50, 230, 50};
private static Snake snake;
public static final int W = 600, H = 400;
public static final int SNAKE_SIZE_W = 10, SNAKE_SIZE_H = 10, BORDER = 20, GRID_SIZE = 10, VELOCITY = 10;
public static int MOVE_INTERVAL = 100;
private static int score;
private static SnakeMove lastMove = null;
public static boolean isRunning;
private static long currentTime = 0l, lastMoveTime;
private static SnakeBody body = null;
private static int FOOD_X, FOOD_Y;
private static int[] FOOD_COLOR;
private static Random random;


/**
 * Setup configuration of the game
 *
 */
 public void setup() {
  /* size commented out by preprocessor */;
  score = 0;
  isRunning = true;
  lastMoveTime = System.currentTimeMillis();
  frameRate(60);
  snake = new Snake();
  snake.startSnake(new int[]{(int)W/2, (int)H/2});
  random = new Random();
  newFood();
}

/**
 * Draw the game frame by frame (gameplay loop function - 60fps)
 */
 public void draw() {
  try {
    background(BG_COLOR[0], BG_COLOR[1], BG_COLOR[2]);
    drawBorders();
    drawScore();
    if (!isRunning) {
      drawGameOver();
      return;
    }
    drawFood();
    drawSnake();
    currentTime = System.currentTimeMillis();
    if (currentTime - lastMoveTime >= MOVE_INTERVAL) {
      snake.updateMovement();
      lastMoveTime = currentTime;
    }
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

/** RENDERS **/

/**
 * Draw the game over screen
 */
 public void drawGameOver() {
  fill(255, 255, 255);
  textFont(createFont("Impact", 32));
  text("Game Over", (W/2)-65, H/2);
  text("Press 'R' to restart", (W/2)-120, (H/2)+40);
}

/**
 * Draw the snake body and head in the screen
 */
 public void drawSnake() {
  body = snake.getBody(0);
  stroke(0, 30, 255);
  fill(150, 60, 200);
  rect(body.getX(), body.getY(), SNAKE_SIZE_W, SNAKE_SIZE_H);
  for (int index = 1; index < snake.bodySize(); index++) {
    body = snake.getBody(index);
    stroke(0, 30, 255);
    fill(50, 100, 200);
    rect(body.getX(), body.getY(), SNAKE_SIZE_W, SNAKE_SIZE_H);
  }
}

/**
 * Draw the score in the screen (bottom center)
 */
 public void drawScore() {
  fill(255, 255, 255);
  textFont(createFont("Impact", 18));
  text("Leon Snake Game: "+score, (W/2) - 70, H - 3);
}

/**
 * Draw the borders of the game (4 rects - top, left, right, bottom)
 */
 public void drawBorders() {
  fill(20, 100, 255);
  noStroke();
  rect(0, 0, W, BORDER);
  rect(0, 0, BORDER, H);
  rect(W-BORDER, 0, BORDER, H);
  rect(0, H-BORDER, W, BORDER);
}

/**
 * Draw the food in the screen (random position and color)
 * if food is null, spawn a new food
 */
 public void drawFood() {
  stroke(255, 255, 255);
  fill(FOOD_COLOR[0], FOOD_COLOR[1], FOOD_COLOR[2]);
  rect(FOOD_X, FOOD_Y, GRID_SIZE, GRID_SIZE);
}

/** GAME LOGIC **/

/**
 * Run the game over logic (remove food, destroy snake and stop game)
 */
public static void gameOver() {
  isRunning = false;
  snake.destroySnake();
  System.gc(); //free some memory
}

/**
 * Restart the game (reset snake, food, score and move interval)
 */
 public void restartGame() {
  snake.startSnake(new int[]{(int)W/2, (int)H/2});
  lastMove = null;
  isRunning = true;
  MOVE_INTERVAL = 100;
  score = 0;
}

/**
 * Update the score (add 1 to score)
 */
public static void updateScore() {
  score++;
}

/**
 * Spawn a new food in the screen (random position and color)
 * For each spawn increase the snake speed (decrease the move interval)
 */
public static void newFood() {
  FOOD_X = random.ints(0 + GRID_SIZE + BORDER, W - GRID_SIZE - BORDER).findFirst().getAsInt();
  FOOD_Y = random.ints(0 + GRID_SIZE + BORDER, H - GRID_SIZE - BORDER).findFirst().getAsInt();
  FOOD_COLOR = new int[]{random.nextInt(255), random.nextInt(255), random.nextInt(255)};
  if (MOVE_INTERVAL > 50)
    MOVE_INTERVAL -= 1;
}

/**
 * Capture the key typed and update the snake movement
 * If the game is not running, capture the 'r' key to restart the game
 */
 public void keyTyped() {
  if (isRunning) {
    switch(key) {
    case 'w':
      if (lastMove == SnakeMove.DOWN) break;
      lastMove = SnakeMove.UP;
      snake.updatePosition(lastMove);
      break;
    case 'a':
      if (lastMove == SnakeMove.RIGHT) break;
      lastMove = SnakeMove.LEFT;
      snake.updatePosition(lastMove);
      break;
    case 's':
      if (lastMove == SnakeMove.UP) break;
      lastMove = SnakeMove.DOWN;
      snake.updatePosition(lastMove);
      break;
    case 'd':
      if (lastMove == SnakeMove.LEFT) break;
      lastMove = SnakeMove.RIGHT;
      snake.updatePosition(lastMove);
      break;
    }
  } else {
    if (key == 'r') {
      restartGame();
    }
  }
}
/**
 * Snake Game
 * @author Leon-Junio
 *
 **/




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
/**
 * Snake Game
 * @author Leon-Junio
 *
 **/



/**
 * Enum to represent the snake moves
 * @param action - BiFunction to apply the move to the body piece
 * @param OFFSET - Offset to apply to the body piece when the snake moves
 **/
public enum SnakeMove {

  UP((position, velocity) -> {
    position[1] -= velocity;
    return position;
  }
  ),
    DOWN((position, velocity) -> {
    position[1] += velocity;
    return position;
  }
  ),
    LEFT((position, velocity) -> {
    position[0] -= velocity;
    return position;
  }
  ),
    RIGHT((position, velocity) -> {
    position[0] += velocity;
    return position;
  }
  );

  private BiFunction<int[], Integer, int[]> action;
  private final int OFFSET = 10;

  private SnakeMove(BiFunction<int[], Integer, int[]> action) {
    this.action = action;
  }

  /**
   * Apply the move to the body piece
   * @param position - Position of the body piece
   * @param velocity - Velocity of the snake
   **/
  public void run(int position[], int velocity) {
    action.apply(position, velocity);
  }

  /**
   * Get the offset to apply to the body piece when the snake moves
   * @return int[] - Offset to apply to the body piece when the snake moves
   **/
  public int[] getOffset() {
    int[] result = {};
    switch(this) {
    case UP:
      result = new int[]{0, +OFFSET};
      break;
    case DOWN:
      result = new int[]{0, -OFFSET};
      break;
    case LEFT:
      result = new int[]{+OFFSET, 0};
      break;
    case RIGHT:
      result = new int[]{-OFFSET, 0};
      break;
    }
    return result;
  }
}


  public void settings() { size(600, 400); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SnakeGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
