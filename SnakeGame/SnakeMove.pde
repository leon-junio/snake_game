/**
 * Snake Game
 * @author Leon-Junio
 */

/**
 * Enum to represent the snake moves
 **/
public enum SnakeMove {
  /**
   * Offset to apply to the body piece when the snake moves
   **/
  UP,
    DOWN,
    LEFT,
    RIGHT;

  private final byte OFFSET = 10;

  /**
   * Get the offset to apply to the body piece when the snake moves
   * @return byte[] - Offset to apply to the body piece when the snake moves
   **/
  public byte[] getOffset() {
    byte[] result = {};
    switch(this) {
    case UP:
      result = new byte[]{0, +OFFSET};
      break;
    case DOWN:
      result = new byte[]{0, -OFFSET};
      break;
    case LEFT:
      result = new byte[]{+OFFSET, 0};
      break;
    case RIGHT:
      result = new byte[]{-OFFSET, 0};
      break;
    }
    return result;
  }
}
