WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 600

-- we need to require class to be able to use oop in lua
Class = require 'class'

-- we create a new class names Paddle
Paddle = Class{}

-- the init method of the Paddle class
-- (also known as __init__ in python or a constructor in c++)
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 200
end

--gets called only once at the start of the game
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    -- left and right paddle of the game
    left_paddle = Paddle(0, WINDOW_HEIGHT/2 - 50, 20, 100)
    right_paddle = Paddle(WINDOW_WIDTH - 20, WINDOW_HEIGHT/2 - 50, 20, 100)
end

-- gets called everytime you press a key
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- we quit the game
    end
end

-- gets called every frame
function love.update(dt)
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
end

-- renders everything onto the screen
function love.draw()
    -- syntax : love.graphics.rectangle("mode", x, y, width, height)
    love.graphics.rectangle("fill", left_paddle.x, left_paddle.y, left_paddle.width, left_paddle.height)
    love.graphics.rectangle("fill", right_paddle.x, right_paddle.y, right_paddle.width, right_paddle.height)
end