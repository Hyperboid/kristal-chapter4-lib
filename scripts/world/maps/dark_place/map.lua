---@class Map.dark_place : Map
local map, super = Class(Map, "dark_place")

function map:init(world, data)
    super.init(self, world, data)
    
end

function map:onEnter()
    self.world.color = COLORS.black
end

function map:onExit()
    self.world.color = COLORS.white
end

---@param char Player
function map:onFootstep(char, num)
    if not char.is_player then return end
    Assets.playSound("step"..num)
    ---@type RippleEffect
    local effect = RippleEffect(char.x, char.y, {Game.party[1]:getColor()})
    effect.physics.speed_x = (char.x - char.last_x)/DTMULT
    effect.physics.speed_y = (char.y - char.last_y)/DTMULT
    self.world:addChild(effect)
end

return map