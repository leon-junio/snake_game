/**
 * Snake Game
 * @author Leon-Junio
 */

import java.util.Random;

private static Snake snake;
private static SnakeMove lastMove = null;
private static Random random;

public static boolean isRunning;
private static PFont FONT_SCORE, FONT_GAME;
private static short[] FOOD_COLOR;
public static final short[] BG_COLOR = {0, 0, 0};
public static final short W = 600, H = 400;
public static final byte SNAKE_SIZE_W = 10, SNAKE_SIZE_H = 10, BORDER = 20, GRID_SIZE = 10, VELOCITY = 10, FOOD_SIZE = 8;
private static byte gapGrid, MOVE_INTERVAL = 100;
private static short score;
private static long currentTime = 0l, lastMoveTime;
private static short FOOD_X, FOOD_Y;



/**
 * Setup configuration of the game
 */
void setup() {
  size(600, 400);
  score = 0;
  isRunning = true;
  lastMoveTime = System.currentTimeMillis();
  frameRate(60);
  FONT_SCORE = createFont("Impact", 18);
  FONT_GAME =  createFont("Impact", 32);
  FOOD_COLOR = new short[3];
  snake = new Snake();
  snake.startSnake((short)(W/2), (short)(H/2));
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
  textFont(FONT_GAME);
  text("Game Over", (W/2)-65, H/2);
  text("Press 'R' to restart", (W/2)-120, (H/2)+40);
}

/**
 * Draw the snake body and head in the screen
 */
void drawSnake() {
  stroke(0, 30, 255);
  fill(150, 200, 60);
  rect(snake.getPositionX(0), snake.getPositionY(0), SNAKE_SIZE_W, SNAKE_SIZE_H);
  for (int index = 1; index < snake.getSize(); index++) {
    stroke(0, 30, 255);
    fill(50, 200, 100);
    rect(snake.getPositionX(index), snake.getPositionY(index), SNAKE_SIZE_W, SNAKE_SIZE_H);
  }
}

/**
 * Draw the score in the screen (bottom center)
 */
void drawScore() {
  fill(255, 255, 255);
  textFont(FONT_SCORE);
  text("Leon Snake Game: "+ score, (W/2) - 70, H - 3);
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
  rect(FOOD_X, FOOD_Y, FOOD_SIZE, FOOD_SIZE);
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
  snake.startSnake((short)(W/2), (short)(H/2));
  lastMove = null;
  isRunning = true;
  MOVE_INTERVAL = 100;
  score = 0;
  newFood();
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
  FOOD_X = (short) random.ints(0 + GRID_SIZE + BORDER, W - GRID_SIZE - BORDER).findFirst().getAsInt();
  gapGrid = (byte)(FOOD_X % GRID_SIZE);
  FOOD_X = (short) (gapGrid < 5? FOOD_X - gapGrid : FOOD_X + gapGrid);
  FOOD_Y = (short) random.ints(0 + GRID_SIZE + BORDER, H - GRID_SIZE - BORDER).findFirst().getAsInt();
  gapGrid = (byte)(FOOD_Y % GRID_SIZE);
  FOOD_Y = (short) (gapGrid < 5? FOOD_Y - gapGrid : FOOD_Y + gapGrid);
  FOOD_COLOR[0] = randColor();
  FOOD_COLOR[1] = randColor();
  FOOD_COLOR[2] = randColor();
  if (score%2 == 0 && MOVE_INTERVAL > 50)
    MOVE_INTERVAL += 1;
}

/**
 * New random color
 * @return short color
 */
private static short randColor() {
  return (short) random.nextInt(255);
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
