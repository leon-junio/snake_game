/* autogenerated by Processing revision 1277 on 2023-08-20 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
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

 public void setup() {
  /* size commented out by preprocessor */;
  isRunning = true;
  lastMoveTime = System.currentTimeMillis();
  frameRate(60);
  snake = new Snake();
  snake.startSnake(new Integer[]{(Integer)W/2, (Integer)H/2});
}

 public void draw() {
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

 public void drawSnake() {
  for (var body : snake.getSnakeBody()) {
    stroke(50,200,100);
    fill(0, 255, 0);
    rect(body.position.getX(), body.position.getY(), SNAKE_SIZE_W, SNAKE_SIZE_H);
  }
}

 public void drawBorders() {
  fill(20, 100, 255);
  noStroke();
  rect(0, 0, W, BORDER);
  rect(0, 0, BORDER, H);
  rect(W-BORDER, 0, BORDER, H);
  rect(0, H-BORDER, W, BORDER);
}

 public void drawFood() {
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

 public void restartGame() {
  snake.startSnake(new Integer[]{(Integer)W/2, (Integer)H/2});
  lastMove = null;
  isRunning = true;
}

public static void newFood() {
  food = null;
}

 public void spawnFood() {
  var x = (int)random(0 + GRID_SIZE + BORDER, W - GRID_SIZE - BORDER);
  var y = (int)random(0 + GRID_SIZE + BORDER, H - GRID_SIZE - BORDER);
  var colors = new int[]{(int)random(0, 255), (int)random(0, 255), (int)random(0, 255)};
  food = new Food(new Position(new Integer[]{x, y}), colors);
}

 public void keyTyped() {
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
public class Food {

  public Food() {
  };

  public Food(Position position, int[] filledColor) {
    this.position = position;
    this.filledColor = filledColor;
  }

  private Position position;
  private int[] filledColor;

  public void setPosition(Position position) {
    this.position = position;
  }

  public Position getPosition() {
    return position;
  }

  public void setFilledColor(int[] filledColor) {
    this.filledColor = filledColor;
  }

  public int[] getFilledColor() {
    return filledColor;
  }


}


public class Position {
  private final Integer[] position;

  public Position(Integer[] position) {
    this.position = position;
  }

  public Integer getX() {
    return position[0];
  }

  public Integer getY() {
    return position[1];
  }

  public void sum(Integer x, Integer y) {
    position[0] += x;
    position[1] += y;
  }
  
  public Integer[] toArray(){
    return position;
  }

  @Override
    public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Position that = (Position) o;
    return Arrays.equals(position, that.position);
  }

  @Override
    public int hashCode() {
    return Arrays.hashCode(position);
  }

  @Override
  public Position clone() {
    return new Position(position.clone());
  }
}





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


public enum SnakeMove {

  UP((position, velocity) -> new Integer[] { position[0], position[1] - velocity  }),
    DOWN((position, velocity) -> new Integer[] { position[0], position[1] + velocity  }),
    LEFT((position, velocity) -> new Integer[] { position[0] - velocity , position[1] }),
    RIGHT((position, velocity) -> new Integer[] { position[0] + velocity , position[1] });

  private BiFunction<Integer[], Integer, Integer[]> action;
  private final Integer OFFSET = 10;

  private SnakeMove(BiFunction<Integer[], Integer, Integer[]> action) {
    this.action = action;
  }


  public Integer[] run(Integer position[], Integer velocity) {
    return action.apply(position, velocity);
  }

  public Integer[] getOffset() {
    Integer[] result = {};
    switch(this) {
    case UP:
      result = new Integer[] {0, +OFFSET};
      break;
    case DOWN:
      result =  new Integer[]{0, -OFFSET};
      break;
    case LEFT:
      result =  new Integer[]{+OFFSET, 0};
      break;
    case RIGHT:
      result =  new Integer[]{-OFFSET, 0};
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