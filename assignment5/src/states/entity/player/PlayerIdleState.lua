--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
	self.entity = player
	self.dungeon = dungeon
	self.objects = dungeon.currentRoom.objects
    self.entity.offsetY = 5
    self.entity.offsetX = 0

	self.entity:changeAnimation('idle-' .. self.entity.direction)
end
function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite

end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')

    elseif love.keyboard.wasPressed('return') then
		if self.entity.direction == 'left' then
			for k, object in pairs(self.objects) do
				if object.type == 'pot' then
					if self.entity.x - object.x < 20 and
					   self.entity.x - object.x > 0 then
						self.entity:changeState('pickup')
						object.pickedUp = true
						Timer.tween(.1, {
							[object] = {x = self.entity.x + 16, y = self.entity.y - 16},
						})

						object.update = function(dt)
							object.x = self.entity.x
							object.y = self.entity.y  - 16
						end
						break
					end
				end
			end
		elseif self.entity.direction == 'right' then
			for k, object in pairs(self.objects) do
				if object.type == 'pot' then
					if object.x - self.entity.x < 20 and
					   object.x - self.entity.x > 0 then
						self.entity:changeState('pickup')
						object.pickedUp = true
						Timer.tween(.1, {
							[object] = {x = self.entity.x + 16, y = self.entity.y - 16},
						})

						object.update = function(dt)
							object.x = self.entity.x
							object.y = self.entity.y  - 16
						end
						break
					end
				end
			end
		elseif self.entity.direction == 'up' then
			for k, object in pairs(self.objects) do
				if object.type == 'pot' then
					if self.entity.y - object.y < 20 and
					   self.entity.y - object.y > 0 then
						self.entity:changeState('pickup')
						object.pickedUp = true
						Timer.tween(.1, {
							[object] = {x = self.entity.x + 16, y = self.entity.y - 16},
						})

						object.update = function(dt)
							object.x = self.entity.x
							object.y = self.entity.y  - 16
						end
						break
					end
				end
			end
		elseif self.entity.direction == 'down'then
			for k, object in pairs(self.objects) do
				if object.type == 'pot' then
					if (object.y - self.entity.y < 25 and
					   object.y - self.entity.y > 0)
					   and (math.abs(object.x - self.entity.x) < 5 ) then
						self.entity:changeState('pickup')
						object.pickedUp = true
						Timer.tween(.1, {
							[object] = {x = self.entity.x + 16, y = self.entity.y - 16},
						})

						object.update = function(dt)
							object.x = self.entity.x
							object.y = self.entity.y  - 16
						end
						break
					end
				end
			end
		end
	end
end
