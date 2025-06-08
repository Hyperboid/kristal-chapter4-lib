---@class Actor.kris : Actor
local actor, super = Class("kris", true)

function actor:init()
    super.init(self)
    Utils.merge(self.offsets, {
        -- TODO: Accuracy.
        ["climb/climb"] = {-5, 4},
        ["climb/charge"] = {-5, 4},
    })
end

return actor