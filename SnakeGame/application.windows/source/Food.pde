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
