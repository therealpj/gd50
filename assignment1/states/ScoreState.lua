--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}


local gold_trophy = love.graphics.newImage('gold_trophy.png')
local bronze_trophy = love.graphics.newImage('bronze_trophy.png')
local silver_trophy = love.graphics.newImage('silver_trophy.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
	gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score <= 2 then
       love.graphics.printf("There's always room for improvement!", 0, 150 ,VIRTUAL_WIDTH, 'center')
    elseif self.score > 2 and self.score < 5 then
       love.graphics.printf("Nice try! Here's your bronze trophy!", 0, 150 ,VIRTUAL_WIDTH, 'center')
       love.graphics.draw(bronze_trophy, VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2 + 40)
    elseif self.score >=5 and self.score < 10 then
       love.graphics.printf("Very Nice try! Here's your silver trophy!", 0, 150 ,VIRTUAL_WIDTH, 'center')
       love.graphics.draw(silver_trophy, VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2 + 40)
    else
       love.graphics.printf("Excellent try! Here's your gold trophy!", 0, 150 ,VIRTUAL_WIDTH, 'center')
       love.graphics.draw(gold_trophy, VIRTUAL_WIDTH / 2 - 20, VIRTUAL_HEIGHT / 2 + 40)
    end


    love.graphics.printf('Press Enter to Play Again!', 0, 250, VIRTUAL_WIDTH, 'center')
end
