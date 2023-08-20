import java.util.Arrays;

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

  public void setX(Integer x) {
    position[0] = x;
  }

  public void setY(Integer y) {
    position[1] = y;
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
