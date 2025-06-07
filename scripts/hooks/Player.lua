---@class Player : Player
---@field world World
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.state_manager:addState("CLIMB", {enter = self.beginClimb, leave = self.endClimb, update = self.updateClimb})
end

function Player:beginClimb(last_state)
    self:setSprite("climb/climb")
end

function Player:endClimb(next_state)
    self:resetSprite()
end

function Player:updateClimb()
    -- Placeholder, obviously.
    local o_noclip = self.noclip
    self.noclip = true
    self:updateWalk()
    self.noclip = o_noclip

    Object.startCache()
    Object.endCache()
end

return Player