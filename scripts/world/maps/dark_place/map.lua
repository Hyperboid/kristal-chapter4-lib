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
    local effect = RippleEffect(char, {Game.party[1]:getColor()})
    local x, y = char:getRelativePos(18/2, 72/2)
    -- TODO: I couldn't find the right numbers
    if Input.down("cancel") then
        RippleEffect:MakeRipple(x,y, 60, {74/255, 145/255, 246/255}, 192, 1, 15):applySpeedFrom(char, 0.75)
    else
        -- RippleEffect:MakeRipple(x,y, 30, nil, 192/2, 1, 8):applySpeedFrom(char, 0.75)
        -- RippleEffect:MakeRipple(x,y, 30, nil, 192/3, 1, 8):applySpeedFrom(char, 0.75)
        self.world:addChild(RippleEffect(x, y, 30, 192/2, 8, {74/255, 145/255, 246/255})):applySpeedFrom(char, 0.75)
        self.world:addChild(RippleEffect(x, y, 30, 192/3, 8, {74/255, 145/255, 246/255})):applySpeedFrom(char, 0.75)
    end
end

return map