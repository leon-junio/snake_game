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
  UP(0, + 10),
    DOWN(0, - 10),
    LEFT(+ 10, 0),
    RIGHT(- 10, 0);

  private SnakeMove(int offsetX, int offsetY) {
    this.offsetX = (byte) offsetX;
    this.offsetY = (byte) offsetY;
  }

  private byte offsetX, offsetY;

  public byte getOffsetX() {
    return offsetX;
  }

  public byte getOffsetY() {
    return offsetY;
  }
}
