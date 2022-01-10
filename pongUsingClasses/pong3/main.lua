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
    -- the x component of speed of the ball
    self.xspeed = 300
    -- the y component of speed of the ball
    self.yspeed = 300
end

function Ball:update(dt)
    -- update ball's location
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
    -- initial state
    gamestate = "main_menu"
    -- keep track of player's scores
    left_player_score = 0
    right_player_score = 0
    -- increase the font size

    --keep track of player's turn
    turn = 1
    love.graphics.setFont(love.graphics.newFont(40))
end

-- gets called when you press a key
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- we quit the game
    elseif key == "return" and gamestate == "main_menu" or gamestate == "gameover" then
        gamestate = "play"
        ball.xspeed = -ball.xspeed 
    end
end

-- logic for collision detection
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
    
    if ball.y >= WINDOW_HEIGHT - ball.height then -- if ball touches the upper or lower window then change the direction of ball
        ball.yspeed = -ball.yspeed
        ball.y = WINDOW_HEIGHT - ball.height
    elseif ball.y <= 0 then
        ball.y = 0
        ball.yspeed = -ball.yspeed
    elseif ball.x + ball.width > WINDOW_WIDTH then -- ball goes out of the screen
        gamestate = "gameover"
        left_player_score = left_player_score + 1
        turn = 2
        ball.x = WINDOW_WIDTH/2 - 5
        ball.y = WINDOW_HEIGHT/2 - 5
    elseif ball.x < 0 then
        gamestate = "gameover"  -- the ball went out of the screen
        right_player_score = right_player_score + 1
        turn = 1
        ball.x = WINDOW_WIDTH/2 - 5
        ball.y = WINDOW_HEIGHT/2 - 5
    end
    -- check if ball hits the collision
    if collision(ball, left_paddle)  then
        ball.xspeed = -ball.xspeed * 1.01
        ball.x = 10
    elseif collision(ball, right_paddle) then
        ball.x = right_paddle.x - 10
        ball.xspeed = - ball.xspeed * 1.01
        

    end
end

-- renders everything onto the screen
function love.draw()
    if gamestate == "main_menu" then
        love.graphics.printf("Press enter to serve", WINDOW_WIDTH/2 - 250, WINDOW_HEIGHT/2 + 20, 500, "center")
    elseif gamestate == "gameover" then
        --love.graphics.printf("gameover", 500, 400, 300, "center")
        if turn == 1 then
            love.graphics.printf("player 1 to serve", WINDOW_WIDTH/2 - 250, WINDOW_HEIGHT/2 + 100, 500, "center")
        else
            love.graphics.printf("player 2 to serve", WINDOW_WIDTH/2 - 250, WINDOW_HEIGHT/2 + 100, 500, "center")
        end
    end
    love.graphics.printf(left_player_score, WINDOW_WIDTH/3, 100, 50, "center")
    love.graphics.printf(right_player_score, 2 * WINDOW_WIDTH/3, 100, 50, "center")
    love.graphics.rectangle("fill", left_paddle.x, left_paddle.y, left_paddle.width, left_paddle.height)
    love.graphics.rectangle("fill", right_paddle.x, right_paddle.y, right_paddle.width, right_paddle.height)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
end