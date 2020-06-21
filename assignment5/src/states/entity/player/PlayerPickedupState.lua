PlayerPickedupState = Class{__includes = BaseState}

function PlayerPickedupState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 5
	self.player.offsetX = 0

	self.player:changeAnimation('pickedup-' .. self.player.direction)
	throwSpeed = 300
	gravity = 10
	self.pot = self.player.pickedUpObject
end


function PlayerPickedupState:update(dt)
	if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
		self.player:changeState('pickedup-walk')
	end

	local pot = self.pot
	if love.keyboard.wasPressed('return') then
		if self.player.direction == 'left' then
			pot.update = function(dt)
				pot.x = pot.x - (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				if throwSpeed == 0 then
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'right' then
			pot.update = function(dt)
				pot.x = pot.x + (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				if throwSpeed == 0 then
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'up' then
			pot.update = function(dt)
				pot.y = pot.y - (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				if throwSpeed == 0 then
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'down' then
			pot.update = function(dt)
				pot.y = pot.y + (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				if throwSpeed == 0 then
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		end
			self.player:changeState('idle')
	end
end

function PlayerPickedupState:render()
	local anim = self.player.currentAnimation
	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
