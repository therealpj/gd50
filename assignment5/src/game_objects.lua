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
        -- TODO
    },
	['heart'] = {
		type = 'heart',
		texture = 'hearts',
		frame = 5,
		width = 16,
		height = 16,
		solid = false,
		defaultState  = 'unpicked',
		consumable = true,
		states = {
			['unpicked'] = {
				frame = 5
			}
		},
		onConsume = function(heart, def)
			def.room.player.health = def.room.player.health >= 5 and 6 or def.room.player.health + 2

		end
	}
}
