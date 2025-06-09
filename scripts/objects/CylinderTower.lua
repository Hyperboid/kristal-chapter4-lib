---@class CylinderTower: Object
---@field world World
---@field layers TileLayer[]
---@field quads love.Quad[]
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

    self.quads = {}
    local slice = 0.5
    local tw, th = self.map.tile_width, self.map.tile_height
    for _=1,3 do
        for i = 1, self.map.width, slice do
            table.insert(self.quads,
                love.graphics.newQuad(
                    (i-1)*th, 0,
                    tw*slice, th*self.map.height,
                    tw*self.map.width, th*self.map.height
                )
            )
        end
    end
end

function CylinderTower:addLayer(layer, depth)
    local tilelayer = TileLayer(self.map, layer)
    table.insert(self.layers, tilelayer)
    self:addChild(tilelayer)
end

function CylinderTower:draw()
    if not self.world.player.onrotatingtower then
        love.graphics.translate(-self.x, 0)
        return super.draw(self)
    end
    local canvas = Draw.pushCanvas(self.map.width * self.map.tile_width, self.map.height * self.map.tile_height)
    super.draw(self)
    Draw.popCanvas()
    -- Draw.drawWrapped(canvas, true, true, -self.world.player.x)
    for i = 1, #self.quads do

        local angle = (i - (#self.quads/2))
        angle = angle - (((self.world.player.x-110)-(SCREEN_WIDTH/2)) / 20)

        local x1, x2 = (angle-1), angle
        -- x1, x2 = (math.abs(x1)^1.1) * Utils.sign(x1), (math.abs(x2)^1.1) * Utils.sign(x2)
        x1, x2 = x1 * 20, x2 * 20
        -- This is basically backface culling lol
        if x1 < x2 then
            local quad = self.quads[i]
            local sx = (x2 - x1) / select(3, quad:getViewport())
            Draw.draw(canvas, quad, x1, 0, 0, sx, 1)
        end
    end
end

return CylinderTower