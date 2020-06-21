PlayerPickedupState = Class{__includes = BaseState}

function PlayerPickedupState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 8
	self.player.offsetX = 0

	self.room = dungeon.currentRoom
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
	pot.collides = function()
		local hitboxX, hitboxY, hitboxWidth, hitboxHeight
		if self.player.direction == 'left' then
			hitboxWidth = 16
			hitboxHeight = 16
			hitboxX = self.pot.x
			hitboxY = self.pot.y
		elseif self.player.direction == 'right' then
			hitboxWidth = 16
			hitboxHeight = 16
			hitboxX = self.pot.x
			hitboxY = self.pot.y
		elseif self.player.direction == 'up' then
			hitboxWidth = 16
			hitboxHeight = 16
			hitboxX = self.pot.x
			hitboxY = self.pot.y
		else
			hitboxWidth = 16
			hitboxHeight = 16
			hitboxX = self.pot.x
			hitboxY = self.pot.y
		end
		self.potHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

		for k, entity in pairs(self.room.entities) do

			if entity:collides(self.potHitbox) then
				self.pot.state = 'broken'
				self.pot.update = function(dt) end
				self.pot.pickedUp = false
				entity:damage(1)
				gSounds['hit-enemy']:play()
			end
		end

		if pot.x > (self.room.width - 1) * 16 or
		 pot.y > (self.room.height - 1) * 16 or
		 pot.x < 32 or
		 pot.y < 32 then
			self.pot.state = 'broken'
			self.pot.update = function(dt) end
			self.pot.pickedUp = false
		end

	end

	if love.keyboard.wasPressed('return') then

		if self.player.direction == 'left' then
			pot.update = function(dt)
				pot.x = pot.x - (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity

				pot.collides()
				if throwSpeed == 0 then
					pot.state = 'broken'
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'right' then
			pot.update = function(dt)
				pot.x = pot.x + (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				pot.collides()
				if throwSpeed == 0 then
					pot.state = 'broken'
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'up' then
			pot.update = function(dt)
				pot.y = pot.y - (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				pot.collides()
				if throwSpeed == 0 then
					pot.state = 'broken'
					pot.update = function(dt) end
					pot.pickedUp = false
				end
			end
		elseif self.player.direction == 'down' then
			pot.update = function(dt)
				pot.y = pot.y + (throwSpeed * dt)
				throwSpeed = throwSpeed - gravity
				pot.collides()
				if throwSpeed == 0 then
					pot.state = 'broken'
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
