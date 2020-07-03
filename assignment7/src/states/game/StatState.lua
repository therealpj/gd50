StatState = Class{__includes = BaseState}

function StatState:init(pokemon, HPIncrease, attackIncrease, defenseIncrease, speedIncrease, onClose)
	self.pokemon = pokemon
	self.onClose = onClose
	self.statMenu = Menu {
        x = VIRTUAL_WIDTH - 140,
        y = VIRTUAL_HEIGHT - 170,
        width = 140,
        height = 170,
		cursor = false,
        items = {
            {
                text = 'Attack: ' .. self.pokemon.attack .. " + " .. attackIncrease

            },
			{
				text = 'Defense: ' .. self.pokemon.defense .. " + " .. defenseIncrease
			},
			{
				text = 'HP: ' .. self.pokemon.HP .. " + " .. HPIncrease
			},
			{
				text = 'Speed: ' .. self.pokemon.speed .. " + " .. speedIncrease
			},
        }
    }
end

function StatState:update(dt)
	self.statMenu:update(dt)
	if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
		self.onClose()
	end
end

function StatState:render()
	self.statMenu:render()
end
