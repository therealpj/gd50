Powerup = Class{}

function Powerup:init(x, y, pos)
   self.x = x
   self.y = y
   self.pos = pos

   --speed moving down
   self.dy = 50

   self.appeared = true

   self.height = 16
   self.width = 16

end


function Powerup:collides(target)
   if self.x > target.x + target.width or target.x > self.x + self.width then
      return false
   end

   if self.y > target.y + target.height or target.y > self.y + self.height then
      return false
   end

   return true
end

function Powerup:update(dt)
   self.y = self.y + self.dy * dt

   -- stop rendering it if it reaches below the screen
   if self.y > VIRTUAL_HEIGHT + self.height then
      self.appeared = false
   end
end



function Powerup:render()
   local x_pos = self.pos * self.width
   local y_pos = 12 * 16

   local atlas = love.graphics.newImage('graphics/breakout.png')
   local image = love.graphics.newQuad(x_pos, y_pos, self.width, self.height, atlas:getDimensions())


   if self.appeared then
      love.graphics.draw(gTextures['main'], image, self.x, self.y)
   end
end
