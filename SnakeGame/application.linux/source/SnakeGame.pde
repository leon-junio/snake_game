/**
 * Snake Game
 * @author Leon-Junio
 */

import java.util.Random;

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
void setup() {
  size(600, 400);
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
void draw() {
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
void drawGameOver() {
  fill(255, 255, 255);
  textFont(createFont("Impact", 32));
  text("Game Over", (W/2)-65, H/2);
  text("Press 'R' to restart", (W/2)-120, (H/2)+40);
}

/**
 * Draw the snake body and head in the screen
 */
void drawSnake() {
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
void drawScore() {
  fill(255, 255, 255);
  textFont(createFont("Impact", 18));
  text("Leon Snake Game: "+score, (W/2) - 70, H - 3);
}

/**
 * Draw the borders of the game (4 rects - top, left, right, bottom)
 */
void drawBorders() {
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
void drawFood() {
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
void restartGame() {
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
void keyTyped() {
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
