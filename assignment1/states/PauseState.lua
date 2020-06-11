PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
   self.bird = params.bird
   self.pipePairs = params.pipePairs
   self.timer = params.timer
   self.score = params.score
   self.lastY = params.lastY
end


function PauseState:update(dt)
   if love.keyboard.wasPressed('p') then
      gStateMachine:change('play', {bird = self.bird,
				    pipePairs = self.pipePairs,
				    timer = self.timer,
				    score = self.score,
				    lastY = self.lastY
      })
   end
end


function PauseState:render()

   print(self.score)

end
