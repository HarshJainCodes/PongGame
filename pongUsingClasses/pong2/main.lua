WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 600

-- we need to require class to be able to use oop in lua
Class = require 'class'

-- we create a new class named Paddle
Paddle = Class{}

-- the init method of the Paddle class
-- (also known as __init__ in python or constructor in c++)
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 200
end

-- create a class name Ball
Ball = Class{}

-- the init method of Ball class
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.xspeed = 300
    self.yspeed = 300
end

function Ball:update(dt)
    self.x = self.x + self.xspeed * dt
    self.y = self.y + self.yspeed * dt
end

--gets called only once at the start of the game
function love.load()
    -- setting the window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- setting the paddle
    left_paddle = Paddle(0, WINDOW_HEIGHT/2 - 50, 10, 100)
    right_paddle = Paddle(WINDOW_WIDTH - 10, WINDOW_HEIGHT/2 - 50, 10, 100)

    -- setting the ball
    ball = Ball(WINDOW_WIDTH/2 - 5, WINDOW_HEIGHT/2 - 5, 10, 10)

    gamestate = "main_menu"
end

-- gets called when you press a key
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- we quit the game
    elseif key == "return" then
        gamestate = "play"
    end
end

function collision(k, v)
    return k.x + k.width > v.x and
            k.x < v.x + v.width and
            k.y +k.height > v.y and
            k.y < v.y + v.height
end

-- gets called every frame
function love.update(dt)

    -- movement of paddles
    if love.keyboard.isDown('w') then
        left_paddle.y = math.max(0, left_paddle.y - left_paddle.speed * dt)
    end
    if love.keyboard.isDown('s') then
        left_paddle.y = math.min(WINDOW_HEIGHT - left_paddle.height, left_paddle.y + left_paddle.speed * dt)
    end
    if love.keyboard.isDown('up') then
        right_paddle.y = math.max(0, right_paddle.y - right_paddle.speed * dt)
    end
    if love.keyboard.isDown('down') then
        right_paddle.y = math.min(WINDOW_HEIGHT - right_paddle.height, right_paddle.y + right_paddle.speed * dt)
    end

    -- movement of ball
    if gamestate == "play" then
        ball:update(dt)
    end
    
    if ball.y > WINDOW_HEIGHT - ball.height or ball.y < 0 then
        ball.yspeed = -ball.yspeed
    end

    if collision(ball, left_paddle) or collision(ball, right_paddle) then
        ball.xspeed = -ball.xspeed
    end
end

-- renders everything onto the screen
function love.draw()
    if gamestate == "main_menu" then
        love.graphics.printf("Press enter to start the game", WINDOW_WIDTH/2 - 70, WINDOW_HEIGHT/2 + 20, 200, "center")
    end
    love.graphics.rectangle("fill", left_paddle.x, left_paddle.y, left_paddle.width, left_paddle.height)
    love.graphics.rectangle("fill", right_paddle.x, right_paddle.y, right_paddle.width, right_paddle.height)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
end