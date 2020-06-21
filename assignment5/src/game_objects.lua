--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
		consumable = false,
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },

    ['pot'] = {
		type = 'pot',
		texture = 'tiles',
		frame = 14,
		width = 16,
		height = 16,
		solid = true,
		defaultState = 'unpicked',
		pickedUp = false,
		consumable = false,
		states = {
			['unpicked'] = {
				frame = 14,
			},
		},
		onCollide = function(pot, def)
			if pot.pickedUp == false then
				if def.room.player.direction == 'left' then
					def.room.player.x = pot.x + 17
				elseif def.room.player.direction == 'right' then
					def.room.player.x = pot.x  - 17
				elseif def.room.player.direction == 'up' then
					def.room.player.y = pot.y + 6
				else
					def.room.player.y = pot.y - 24
				end
			end
		end
    },

	['heart'] = {
		type = 'heart',
		texture = 'hearts',
		frame = 5,
		width = 16,
		height = 16,
		solid = false,
		defaultState  = 'fallen',
		consumable = true,
		states = {
			['fallen'] = {
				frame = 5
			}
		},
		onConsume = function(heart, def)
			def.room.player.health = def.room.player.health >= 5 and 6 or def.room.player.health + 2
		end
	}
}
