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

  UP((position, velocity) -> new Integer[] { position[0], position[1] - velocity  }),
    DOWN((position, velocity) -> new Integer[] { position[0], position[1] + velocity  }),
    LEFT((position, velocity) -> new Integer[] { position[0] - velocity, position[1] }),
    RIGHT((position, velocity) -> new Integer[] { position[0] + velocity, position[1] });

  private BiFunction<Integer[], Integer, Integer[]> action;
  private final Integer OFFSET = 10;

  private SnakeMove(BiFunction<Integer[], Integer, Integer[]> action) {
    this.action = action;
  }

  /**
   * Apply the move to the body piece
   * @param position - Position of the body piece
   * @param velocity - Velocity of the snake
   * @return Integer[] - New position of the body piece
   **/
  public Integer[] run(Integer position[], Integer velocity) {
    return action.apply(position, velocity);
  }

  /**
   * Get the offset to apply to the body piece when the snake moves
   * @return Integer[] - Offset to apply to the body piece when the snake moves
   **/
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