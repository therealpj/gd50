PlayerPickupState = Class{__includes = BaseState}

function PlayerPickupState:enter(params)
	self.player.offsetY = 5
	self.player.offsetX = 0

	self.player.currentAnimation:refresh()
end

function PlayerPickupState:init(player, dungeon)
	self.player = player
	self.dungeon = dungeon

	self.player.offsetY = 5
	self.player.offsetX = 8

	self.player:changeAnimation('pickup-' .. self.player.direction)
end

function PlayerPickupState:update(dt)

	if self.player.currentAnimation.timesPlayed > 0 then
		self.player.currentAnimation.timesPlayed = 0
		-- Change state to PlayerPickedUpState
		self.player:changeState('idle')
	end

	if love.keyboard.wasPressed('enter') then
		-- change state to PlayerThrowState
		self.player:changeState('idle')
	end
end

function PlayerPickupState:render()
	local anim = self.player.currentAnimation
	love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
