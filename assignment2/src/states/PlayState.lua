--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores

    self.level = params.level

    self.recoverPoints = 5000
    self.increaseSizePoints = 10000
    -- give ball random starting velocity
    params.ball.dx = math.random(-200, 200)
    params.ball.dy = math.random(-50, -60)

    -- balls table, to keep it in case of powerup
    self.balls = {}
    table.insert(self.balls, params.ball)

    -- triple powerup
    self.tripleBall = Powerup(0, 0, 3)

       self.key = Powerup(0, 0, 9)
       self.takenKey = false

end

function PlayState:update(dt)
    if self.paused then
	if love.keyboard.wasPressed('space') then
	    self.paused = false
	    gSounds['pause']:play()
	else
	    return
	end
    elseif love.keyboard.wasPressed('space') then
	self.paused = true
	gSounds['pause']:play()
	return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    for k, ball in pairs(self.balls) do
       ball:update(dt)
    end

    -- collision checking for each of the balls
    for k, ball in pairs(self.balls) do
       if ball:collides(self.paddle) then
	  -- raise ball above paddle in case it goes below it, then reverse dy
	  ball.y = self.paddle.y - 8
	  ball.dy = -ball.dy

	  --
	  -- tweak angle of bounce based on where it hits the paddle
	  --

	  -- if we hit the paddle on its left side while moving left...
	  if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
	     ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))

	     -- else if we hit the paddle on its right side while moving right...
	  elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
	     ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
	  end

	  gSounds['paddle-hit']:play()
       end
    end


    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do

       -- only check collision if we're in play
       for k, ball in pairs(self.balls) do

	  if brick.inPlay and ball:collides(brick) then

	     -- add to score
	     self.score = self.score + (brick.tier * 200 + brick.color * 25)

	     -- trigger the brick's hit function, which removes it from play
	     if brick.isLocked == true then
		if self.takenKey then
		   brick:hit()
		   self.score = self.score + 1000
		end

	     else
		brick:hit()
	     end

	     -- if we have enough points, recover a point of health
	     if self.score > self.recoverPoints then
		-- can't go above 3 health
		self.health = math.min(3, self.health + 1)

		-- multiply recover points by 2
		self.recoverPoints = math.min(100000, self.recoverPoints * 2)

		-- play recover sound effect
		gSounds['recover']:play()
	     end

	     if self.score > self.increaseSizePoints then
		self.paddle:increaseSize()

		self.increaseSizePoints = self.increaseSizePoints * 2
	     end


	     -- go to our victory screen if there are no more bricks left
	     if self:checkVictory() then
		gSounds['victory']:play()

		gStateMachine:change('victory', {
					level = self.level,
					paddle = self.paddle,
					health = self.health,
					score = self.score,
					highScores = self.highScores,
					ball = self.balls[k],
					recoverPoints = self.recoverPoints
		})
	     end

	     -- chance to render powerup unless already on screen
	     -- render only if brick is destroyed
	     if self.tripleBall.appeared == false and (brick.color == 1 and brick.tier == 0) and (math.floor(love.timer.getTime()) % 7 == 0) then
		self.tripleBall.x = brick.x
		self.tripleBall.y = brick.y
		self.tripleBall.appeared = true
	     end

	     -- key
	     if containsLockedBrick then
		-- can spawn the key if the locked brick gets hit, in case it is the last brick left. Dont spawn if triple ball on screen.
		if brick.color == 1 and brick.tier == 0 and (math.floor(love.timer.getTime()) % 7 == 0)
		and self.takenKey == false and self.tripleBall.appeared == false then
		   self.key.x = brick.x
		   self.key.y = brick.y
		   self.key.appeared = true
		end
	     end


	     --
	     -- collision code for bricks
	     --
	     -- we check to see if the opposite side of our velocity is outside of the brick;
	     -- if it is, we trigger a collision on that side. else we're within the X + width of
	     -- the brick and should check to see if the top or bottom edge is outside of the brick,
	     -- colliding on the top or bottom accordingly
	     --

	     -- left edge; only check if we're moving right, and offset the check by a couple of pixels
	     -- so that flush corner hits register as Y flips, not X flips

	     if ball.x + 2 < brick.x and ball.dx > 0 then

		-- flip x velocity and reset position outside of brick
		ball.dx = -ball.dx
		ball.x = brick.x - 8

		-- right edge; only check if we're moving left, , and offset the check by a couple of pixels
		-- so that flush corner hits register as Y flips, not X flips
	     elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

		-- flip x velocity and reset position outside of brick
		ball.dx = -ball.dx
		  ball.x = brick.x + 32

		  -- top edge if no X collisions, always check
	       elseif ball.y < brick.y then

		  -- flip y velocity and reset position outside of brick
		  ball.dy = -ball.dy
		  ball.y = brick.y - 8

	       -- bottom edge if no X collisions or top collision, last possibility
	       else

		  -- flip y velocity and reset position outside of brick
		  ball.dy = -ball.dy
		  ball.y = brick.y + 16
	    end

	    -- slightly scale the y velocity to speed up the game, capping at +- 150
	       if math.abs(ball.dy) < 150 then
		  ball.dy = ball.dy * 1.02
	       end

	       -- only allow colliding with one brick, for corners
	       break


	  end
       end
    end

    for k, ball in pairs(self.balls) do
       -- if ball goes below bounds, revert to serve state and decrease health
       if ball.y >= VIRTUAL_HEIGHT then
	  table.remove(self.balls, k)

	  -- decrease health if this was the last ball
	  if table.getn(self.balls) == 0 then
	     self.health = self.health - 1

	     -- change paddle
	     self.paddle:decreaseSize()

	     gSounds['hurt']:play()
	  end

	if self.health == 0 then
	    gStateMachine:change('game-over', {
		score = self.score,
		highScores = self.highScores
	    })
	else
	   -- change state only when last ball went down
	   if table.getn(self.balls) == 0 then
	      gStateMachine:change('serve', {
				      paddle = self.paddle,
				      bricks = self.bricks,
				      health = self.health,
				      score = self.score,
				      highScores = self.highScores,
				      level = self.level,
				      recoverPoints = self.recoverPoints
	      })
	   -- do nothing
	   else

	   end
	end
       end
    end
    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
	brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
	love.event.quit()
    end

    -- if player catches powerup
    if self.tripleBall:collides(self.paddle) and self.tripleBall.appeared then
       self.tripleBall.appeared = false

       local i = 1
       for i = 1,2 do
	  local lball = Ball(math.random(7))
	  lball.dx = i % 2 == 0 and math.random(0, 200) or math.random(-200, 0)
	  lball.dy = math.random(-50, -60)
	  lball.x = self.paddle.x
	  lball.y = self.paddle.y - self.paddle.height

	  table.insert(self.balls, lball)
       end
    end

    -- if player takes key
    if self.key:collides(self.paddle) and self.key.appeared then
       self.key.appeared = false
       self.takenKey = true
    end


    --updating powerup
    self.key:update(dt)
    self.tripleBall:update(dt)
end

function PlayState:render()

   --render powerup
   self.tripleBall:render()

   self.key:render()

    -- render bricks
    for k, brick in pairs(self.bricks) do
	brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
	brick:renderParticles()
    end

    self.paddle:render()

    -- render all the balls
    for k, ball in pairs(self.balls) do
       ball:render()
    end


    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
	love.graphics.setFont(gFonts['large'])
	love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
	if brick.inPlay then
	    return false
	end
    end

    return true
end
