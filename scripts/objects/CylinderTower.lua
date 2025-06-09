---@class CylinderTower: Object
---@field world World
---@field layers TileLayer[]
local CylinderTower, super = Class(Object)

---@param map Map
---@param depth number
function CylinderTower:init(map, depth)
    super.init(self, SCREEN_WIDTH/2, 0)
    self.layer = depth or self.layer
    self.map = map
    self.world = map.world
    self.current_depth = depth or 0
    self.layers = {}
end

function CylinderTower:addLayer(layer, depth)
    local tilelayer = TileLayer(self.map, layer)
    table.insert(self.layers, tilelayer)
    self:addChild(tilelayer)
end

function CylinderTower:draw()
    local canvas = Draw.pushCanvas(self.map.width * self.map.tile_width, self.map.height * self.map.tile_height)
    super.draw(self)
    Draw.popCanvas()
    Draw.drawWrapped(canvas, true, true, self.world.player.onrotatingtower and -self.world.player.x or -self.x)
end

return CylinderTower