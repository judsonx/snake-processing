int _board_size = 60;
int _square_size = 10;
int _min_snake_len = 20;

ArrayList<Offset> _offsets = new ArrayList<Offset>();
Offset _apple_offset;

Vector VLEFT = new Vector(-1, 0);
Vector VUP = new Vector(0, -1);
Vector VRIGHT = new Vector(1, 0);
Vector VDOWN = new Vector(0, 1);

ArrayList<Vector> _v = new ArrayList<Vector>();

color BG_COLOR = color(20);
color APPLE_COLOR = color(255, 0, 0);
color SNAKE_COLOR = color(240, 240, 240);

boolean _key_since_last_frame = false;
boolean _paused = false;

void setup()
{
  size(600, 600);
  frameRate(60);
  background(BG_COLOR);
  
  _apple_offset = randomOffset();
  _v.add(VRIGHT);
}

Offset randomOffset()
{
  return new Offset((int)(random(0, _board_size)), (int)(random(0,_board_size)));
}

class Vector
{
  public Vector(int x, int y)
  {
    X = x;
    Y = y;
  }
  
  public int X;
  public int Y;
}

class Offset
{
  public Offset(int x, int y)
  {
    X = x;
    Y = y;
  }
  
  public int X;
  public int Y;
}

void pushVector(Vector v)
{
  if (!_key_since_last_frame)
    _v.clear();
  _key_since_last_frame = true;
  _v.add(v);
}

Vector popVector()
{
  if (_v.size() < 1)
    return null;

  Vector result = _v.get(0);
  if (_v.size() > 1)
    _v.remove(0);
  return result;
}

void fillSquare(Offset offset)
{
  square(offset.X * _square_size, offset.Y * _square_size, _square_size); 
}

void drawSnake()
{
  fill(SNAKE_COLOR);
  for (int i = 0; i < _offsets.size(); ++i)
  {
    fillSquare(_offsets.get(i)); 
  }
}

void drawApple()
{
  fill(APPLE_COLOR);
  square(_apple_offset.X * _square_size, _apple_offset.Y * _square_size, _square_size);
}

Offset currentPos()
{
  if (_offsets.size() < 1)
    return new Offset(_board_size / 2, _board_size / 2);
  
  return _offsets.get(_offsets.size() - 1);
}

boolean isValid(Offset x)
{
  if (x == null)
    return false;
    
  if (x.X < 0 || x.X >= _board_size)
    return false;
    
  if (x.Y < 0 || x.Y >= _board_size)
    return false;
    
  for (int i = 0; i < _offsets.size(); ++i)
  {
    if (offsetEqual(_offsets.get(i), x))
      return false;
  }
    
  return true;
}

boolean offsetEqual(Offset lhs, Offset rhs)
{
  return lhs.X == rhs.X && lhs.Y == rhs.Y;
}

void next()
{
  Offset current_pos = currentPos();
  Vector v = popVector();
  Offset next_pos = new Offset(current_pos.X + v.X, current_pos.Y + v.Y);
  if (!isValid(next_pos))
  {
    println("Game Over!");
    noLoop();
    return;
  }
  
  if (offsetEqual(next_pos, _apple_offset))
  {
    for (;;)
    {
      _apple_offset = randomOffset();
      if (isValid(_apple_offset))
        break;
    }
    _offsets.add(next_pos);
    _min_snake_len += 20;
  }
  else
  {
    if (_offsets.size() > _min_snake_len)
    {
      fill(BG_COLOR);
      fillSquare(_offsets.get(0));
      _offsets.remove(0);
    }
    _offsets.add(next_pos);
  }
}

void keyPressed() {
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      pushVector(VUP);
    }
    else if (keyCode == DOWN)
    {
      pushVector(VDOWN);
    }
    else if (keyCode == LEFT)
    {
      pushVector(VLEFT);
    }
    else if (keyCode == RIGHT)
    {
      pushVector(VRIGHT);
    }
  }
  else if (key == 'p')
  {
    if (_paused)
      loop();
    else
      noLoop();
    _paused = !_paused;
  }
}

void draw()
{
  if (frameCount % 4 == 0)
  {
    _key_since_last_frame = false;
    next();
  }
  drawSnake();
  drawApple();
}
