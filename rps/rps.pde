final int CS_NORMAL =  0, 
CS_HOVER = 1, 
CS_PRESS = 2, 
CS_CLICK = 3, 
CS_RELEASE = 4;


class Control
{
  float x, y, w, h;
  color fg, bg;
  int state;
  Control()
  {
  }
  Control(int x_pos, int y_pos, int Width, int Height, color foreground, color background)
  {
    state = CS_NORMAL;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = foreground;
    bg = background;
  }
  void draw()
  {
    noStroke();
    fill(bg, 192);
    rect(x, y, w, h);
  }
  int hitTest()
  {
    if (mouseX>=x&&mouseX-x<=w)
    {
      if (mouseY>=y&&mouseY-y<=h)
      {
        // Mouse in area
        if (mousePressed)
        {
          if (state != CS_PRESS)
          {
            state = CS_PRESS;
            return CS_CLICK;
          }
          return CS_PRESS;
        }
        if (state == CS_PRESS)
        {
          state = CS_HOVER;
          return CS_RELEASE;
        }
        state = CS_HOVER;
        return CS_HOVER;
      }
    }
    state = CS_NORMAL;
    return CS_NORMAL;
  }
}

class Slider extends Control
{
  public float value;
  Slider(float init_val, int x_pos, int y_pos, int Width, int Height, color background, color tint)
  {
    //    super.Control(x_pos, y_pos, Width, Height, tint, background);
    state = CS_NORMAL;
    x = x_pos;
    y = y_pos;
    w = Width/1.1;
    h = Height;
    fg = tint;
    bg = background;
    value = init_val;
  }
  void draw()
  {
    // Reset Out-of-Bounds
    if (value<0)
    {
      value = 0;
    }
    if (value>1)
    {
      value = 1;
    }
    float w_temp = w; // Slider background must be complete
    w*=1.1;
    super.draw();
    w = w_temp; // Set back for slider drawing
    // Draw Slider
    noStroke();
    switch(state)
    {
    case CS_NORMAL:
      fill(fg, 153);
      break;
    case CS_HOVER:
      fill(fg, 255);
      break;
    case CS_PRESS:
      fill(fg, 192);
      break;
    }
    rect(x+value*w, y, w/10, h);
  }
  float drag_begin_displacement; // Temp variable for dragging
  float value0;
  private void updateVal()
  {
    value = value0 + ((float)((mouseX-drag_begin_displacement)))/((float)w);
  }
  int hitTest()
  {
    if (mouseY>=y&&mouseY-y<=h)
    {
      if (mouseX>=x+value*w&&mouseX-(x+value*w)<=w/10&&value>=0&&value<=1)
      {
        // Mouse on block
        if (mousePressed)
        {
          // Update value
          if (state != CS_PRESS)
          {
            // Just Began dragging
            drag_begin_displacement = mouseX;
            value0 = value;
          }
          updateVal();
          state = CS_PRESS;
          return CS_PRESS;
        }
        state = CS_HOVER;
        return CS_HOVER;
      }
      // Outside, fall out
    }
    if (mousePressed&&state==CS_PRESS&&value>=0&&value<=1)
    {
      // Drag out of region, but continue
      updateVal();
      return CS_PRESS;
    }
    state = CS_NORMAL;
    return CS_NORMAL;
  }
}

class Button extends Control
{
  public String title;
  Button()
  {
  }
  Button(String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    title = text;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }
  void draw()
  {
    stroke(fg);
    switch(state)
    {
    case CS_NORMAL:
      fill(bg, 153);
      break;
    case CS_HOVER:
      fill(bg, 255);
      break;
    case CS_PRESS:
      fill(bg, 192);
      break;
    }
    rect(x, y, w, h);
    fill(fg);
    textSize(h/1.5);
    textAlign(CENTER, CENTER);
    text(title, x, y, w, h);
  }
}

class StateButton extends Button
{
  public boolean selected;
  StateButton(boolean Selected, String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    selected = Selected;
    title = text;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }
  void draw()
  {
    noStroke();
    switch(state)
    {
    case CS_NORMAL:
      if (selected)
      {
        fill(bg, 255);
      } else
      {
        fill(bg, 153);
      }
      break;
    case CS_HOVER:
      fill(bg, 255);
      break;
    case CS_PRESS:
      fill(bg, 192);
      break;
    }
    rect(x, y, w, h);
    fill(fg);
    textSize(h/1.5);
    textAlign(CENTER, CENTER);
    text(title, x, y, w, h);
  }
  int hitTest()
  {
    int test_result = super.hitTest();
    if (test_result == CS_CLICK)
    {
      selected = true;
    }
    return test_result;
  }
}

class Switch extends Button
{
  boolean value;
  Switch(boolean initVal, String text, int x_pos, int y_pos, int Width, int Height, color textColor, color background)
  {
    value = initVal;
    title = text;
    x = x_pos;
    y = y_pos;
    w = Width;
    h = Height;
    fg = textColor;
    bg = background;
  }  
  int hitTest()
  {
    int result = super.hitTest();
    if (result == CS_CLICK)
    {
      value = !value;
    }
    return result;
  }
  void draw()
  {
    super.draw();
    stroke(#FFFFFF);
    if (value)
    {
      fill(#00ff00,255);
    }
    else
    {
      fill(#666666,153);
    }
    ellipse(x+8,y+h/2,h/2,h/2);
  }
}

// Begin

Button r_button = new Button("Rock", 10,10,80,30, #000000, #66ccff);
Button p_button = new Button("Paper", 110,10,80,30, #000000, #66ccff);
Button s_button = new Button("Scissor", 210,10,80,30, #000000, #66ccff);

Button r_aibutton = new Button("Rock", 10,250,80,30, #000000, #666666);
Button p_aibutton = new Button("Paper", 110,250,80,30, #000000, #666666);
Button s_aibutton = new Button("Scissor", 210,250,80,30, #000000, #666666);

StateButton ai1_button = new StateButton(true, "AI1(Always Scissor)", 10, 310, 280, 30, #000000, #66ccff);
StateButton ai2_button = new StateButton(false, "AI2(Random)", 10, 350, 280, 30, #000000, #66ccff);
StateButton ai3_button = new StateButton(false, "AI3(Not Done)", 10, 390, 280, 30, #000000, #66ccff);


boolean began = false;

final int ROCK = 0,
PAPER = 1,
SCISSOR = 2;

final String[] description = {"ROCK","PAPER","SCISSOR"};

int AI = 1;
int userSel, aiSel;

void setup()
{
  size(300,450);
}

void display_result()
{
  if(!began)
  {
    return;
  }
  fill(0);
  textAlign(CENTER,CENTER);
  textSize(24);
  text("You played "+description[userSel], 10, 50, 290, 50);
  text("AI played "+description[aiSel], 10, 190, 290, 50);
  int result;// 0=draw, 1=user, 2(-1)=ai
  result = userSel-aiSel;
  result = (result+3)%3;
  switch(result)
  {
    case 0:
    // draw
      fill(#ffcc00);
      text("It's a draw", 10, 100, 290, 90);
      break;
    case 1:
      fill(#ff0000);
      text("You WIN!", 10, 100, 290, 90);
      break;
    case 2:
      fill(#66cc21);
      text("Sorry, you lose.", 10, 100, 290, 90);
      break;
  }
}

void play(int player)
{
  began = true;
  userSel = player;
  switch(AI)
  {
    case 1:
      aiSel = SCISSOR;
      break;
    case 2:
      aiSel = (int)random(0,3);
      break;
    case 3:
      break;
  }
}

void draw()
{
  background(#ffffff);
  if(r_button.hitTest()==CS_RELEASE)
  {
    play(ROCK);
  }
  r_button.draw();
  if(p_button.hitTest()==CS_RELEASE)
  {
    play(PAPER);
  }
  p_button.draw();
  if(s_button.hitTest()==CS_RELEASE)
  {
    play(SCISSOR);
  }
  s_button.draw();
  r_aibutton.draw();
  p_aibutton.draw();
  s_aibutton.draw();
  
  if(ai1_button.hitTest()==CS_CLICK)
  {
    AI=1;
    ai1_button.selected=true;
    ai2_button.selected=false;
    ai3_button.selected=false;
  }
  if(ai2_button.hitTest()==CS_CLICK)
  {
    AI=2;
    ai1_button.selected=false;
    ai2_button.selected=true;
    ai3_button.selected=false;
  }
  if(ai3_button.hitTest()==CS_CLICK)
  {
    AI=3;
    ai1_button.selected=false;
    ai2_button.selected=false;
    ai3_button.selected=true;
  }
  ai1_button.draw();
  ai2_button.draw();
  ai3_button.draw();
  display_result();
//  text(mouseY,100,10);
}
