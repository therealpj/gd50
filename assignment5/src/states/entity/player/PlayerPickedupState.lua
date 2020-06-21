PlayerPickedupState = Class{__includes = BaseState}

function PlayerPickedupState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 5
	self.player.offsetX = 0

	self.player:changeAnimation('pickedup-' .. self.player.direction)
end


function PlayerPickedupState:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
		self.player:changeState('pickedup-walk')
	end

	if love.keyboard.wasPressed('return') then
		-- throw logic here
		self.player:changeState('idle')
	end

end

function PlayerPickedupState:render()
	local anim = self.player.currentAnimation
	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
