/**
 * Snake Game
 * @author Leon-Junio
 *
 **/

import java.util.function.BiFunction;

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
