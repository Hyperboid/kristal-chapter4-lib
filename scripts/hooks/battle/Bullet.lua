---@class Bullet : Bullet
local Bullet, super = Utils.hookScript(Bullet)

function Bullet:init(x,y,texture)
    super.init(self,x,y,texture)
    if Game.battle and Game.battle.encounter and Game.battle.encounter.reduced_tp then
        self.grazed = true
        self.tp = self.tp / 8
    end
end

return Bullet