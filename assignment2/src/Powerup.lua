Powerup = Class{}

function Powerup:init(x, y, pos)
   self.x = x
   self.y = y
   self.pos = pos

   --speed moving down
   self.dy = 50

   self.appeared = false

   self.height = 16
   self.width = 16


   -- image of the powerup based on the given pos
   local x_pos = self.pos * self.width
   local y_pos = 12 * 16

   local atlas = love.graphics.newImage('graphics/breakout.png')
   self.image = love.graphics.newQuad(x_pos, y_pos, self.width, self.height, atlas:getDimensions())
end


function Powerup:collides(target)
   if self.appeared then
      if self.x > target.x + target.width or target.x > self.x + self.width then
	 return false
      end

      if self.y > target.y + target.height or target.y > self.y + self.height then
	 return false
      end

      return true
   else
      return false
   end

end

function Powerup:update(dt)
   if self.appeared then
      self.y = self.y + self.dy * dt
   end

   -- stop rendering it if it reaches below the screen
   if self.y > VIRTUAL_HEIGHT + self.height then
      self.appeared = false
   end
end



function Powerup:render()



   if self.appeared then
      love.graphics.draw(gTextures['main'], self.image, self.x, self.y)
   end
end
