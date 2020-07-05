StatState = Class{__includes = BaseState}

function StatState:init(pokemon, HPIncrease, attackIncrease, defenseIncrease, speedIncrease, onClose)
	self.pokemon = pokemon
	self.onClose = onClose
	self.statMenu = Menu {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 180,
        width = 160,
        height = 180,
		cursor = false,
        items = {
			{
				text = 'HP: ' .. self.pokemon.HP - HPIncrease.. " + " .. HPIncrease .. " = " .. self.pokemon.HP
			},

            {
                text = 'Attack: ' .. self.pokemon.attack - attackIncrease .. " + " .. attackIncrease .. " = " .. self.pokemon.attack

            },
			{
				text = 'Defense: ' .. self.pokemon.defense  - defenseIncrease.. " + " .. defenseIncrease .. " = " .. self.pokemon.defense
			},
			{
				text = 'Speed: ' .. self.pokemon.speed - speedIncrease .. " + " .. speedIncrease .. " = " .. self.pokemon.speed
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
