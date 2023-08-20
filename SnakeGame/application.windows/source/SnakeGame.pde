/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

public static final int BG_COLOR = 0; //<>// //<>// //<>// //<>// //<>//
public static Snake snake;
public static final int W = 600, H = 400;
public static final int SNAKE_SIZE_W = 10, SNAKE_SIZE_H = 10, BORDER = 20, GRID_SIZE = 10;
public static final int VELOCITY = 10;
private static SnakeMove lastMove = null;
public static boolean isRunning;
private static long currentTime = 0l;
private static long lastMoveTime;
private static final int MOVE_INTERVAL = 100;
public static Food food = null;

void setup() {
  size(600, 400);
  isRunning = true;
  lastMoveTime = System.currentTimeMillis();
  frameRate(60);
  snake = new Snake();
  snake.startSnake(new Integer[]{(Integer)W/2, (Integer)H/2});
}

void draw() {
  try {
    background(BG_COLOR);
    drawBorders();
    if (!isRunning) {
      fill(255, 255, 255);
      textFont(createFont("Impact", 32));
      text("Game Over", (W/2)-65, H/2);
      text("Press 'R' to restart", (W/2)-120, (H/2)+40);
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

void drawSnake() {
  for (var body : snake.getSnakeBody()) {
    stroke(50,200,100);
    fill(0, 255, 0);
    rect(body.position.getX(), body.position.getY(), SNAKE_SIZE_W, SNAKE_SIZE_H);
  }
}

void drawBorders() {
  fill(20, 100, 255);
  noStroke();
  rect(0, 0, W, BORDER);
  rect(0, 0, BORDER, H);
  rect(W-BORDER, 0, BORDER, H);
  rect(0, H-BORDER, W, BORDER);
}

void drawFood() {
  if (food == null) {
    spawnFood();
  }
  var colors = food.getFilledColor();
  stroke(255, 255, 255);
  fill(colors[0], colors[1], colors[2]);
  rect(food.position.getX(), food.position.getY(), GRID_SIZE, GRID_SIZE);
}

public static void gameOver() {
  isRunning = false;
  food = null;
  snake.destroySnake();
}

void restartGame() {
  snake.startSnake(new Integer[]{(Integer)W/2, (Integer)H/2});
  lastMove = null;
  isRunning = true;
}

public static void newFood() {
  food = null;
}

void spawnFood() {
  var x = (int)random(0 + GRID_SIZE + BORDER, W - GRID_SIZE - BORDER);
  var y = (int)random(0 + GRID_SIZE + BORDER, H - GRID_SIZE - BORDER);
  var colors = new int[]{(int)random(0, 255), (int)random(0, 255), (int)random(0, 255)};
  food = new Food(new Position(new Integer[]{x, y}), colors);
}

void keyTyped() {
  if (isRunning) {
    var lastPosition = snake.getFirstPosition();
    switch(key) {
    case 'w':
      if (lastMove == SnakeMove.DOWN) break;
      lastMove = SnakeMove.UP;
      snake.addPosition(lastPosition, lastMove);
      break;
    case 'a':
      if (lastMove == SnakeMove.RIGHT) break;
      lastMove = SnakeMove.LEFT;
      snake.addPosition(lastPosition, lastMove);
      break;
    case 's':
      if (lastMove == SnakeMove.UP) break;
      lastMove = SnakeMove.DOWN;
      snake.addPosition(lastPosition, lastMove);
      break;
    case 'd':
      if (lastMove == SnakeMove.LEFT) break;
      lastMove = SnakeMove.RIGHT;
      snake.addPosition(lastPosition, lastMove);
      break;
    case 'e':
      snake.newBody();
      break;
    }
  } else {
    if (key == 'r') {
      restartGame();
    }
  }
}
