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
    for i = 1, self.map.width+slice, slice do
        table.insert(self.quads,
            love.graphics.newQuad(
                (i-1)*th, 0,
                tw*slice, th*self.map.height,
                tw*self.map.width, th*self.map.height
            )
        )
    end

    self.world.camera.tower = self
    Game.stage.timer:after(0, function ()
        self:postLoad()
    end)
    self.parallax_x = 0
end

function CylinderTower:postLoad()
    for _, layer in ipairs(self.map.tile_layers) do
        ---@cast layer TileLayer
        layer.wrap_x = true
    end
end

function CylinderTower:addLayer(layer, depth)
    local tilelayer = TileLayer(self.map, layer)
    table.insert(self.layers, tilelayer)
    self:addChild(tilelayer)
end

function CylinderTower:drawReticle()
    love.graphics.push()
    love.graphics.translate(-self.world.width,0)
    -- TODO: We _probably_ don't strictly need 5 rounds of 
    for _=1,3 do
        love.graphics.push()
        local transform = love.graphics.getTransformRef()
        Object.startCache()
        self.world.player:applyTransformTo(transform, 1 / CURRENT_SCALE_X, 1 / CURRENT_SCALE_Y)
        Object.endCache()
        love.graphics.replaceTransform(transform)
        self.world.player:drawClimbReticle()
        love.graphics.pop()
        love.graphics.translate(self.world.width,0)
    end
    love.graphics.pop()
end

function CylinderTower:draw()
    if not self.world.player.onrotatingtower then
        love.graphics.translate(-self.x, 0)
        return super.draw(self)
    end
    Draw.setColor(COLORS.white)
    self:drawLayer(super.draw, 1)
    Draw.setColor(COLORS.white)
    self:drawLayer(self.drawReticle, 1)
    -- Draw.drawWrapped(canvas, true, true, -self.world.player.x)
end

---@param func function
---@param scale number? Unused
---@param ... any
---@overload fun(canvas:love.Texture, scale:number?)
function CylinderTower:drawLayer(func, scale, ...)
    local canvas
    if type(func) == "function" then
        local r,g,b,a = love.graphics.getColor()
        canvas = Draw.pushCanvas(self.map.width * self.map.tile_width, self.map.height * self.map.tile_height)
        func(self)
        Draw.popCanvas()
        love.graphics.setColor(r,g,b,a)
    else
        canvas = func
    end
    love.graphics.push()
    love.graphics.scale(1 + (((self.map.width-22))/22), 1)
    local angle_per_quad = math.rad(360 / #self.quads)
    for i = 1, #self.quads do
        local angle = (i - (#self.quads/2))
        -- TODO: Find out why the hell this works
        local weird_magic_offset = -30 + ((self.map.width-16)*20)
        angle = angle - (((self.world.player.x-(weird_magic_offset))-(SCREEN_WIDTH/2)) / 20)
        angle = 1 + angle
        angle = (angle * angle_per_quad)

        local x1, x2 = math.sin(angle-angle_per_quad/2), math.sin(angle+angle_per_quad/2)
        local cx = (x1+x2)/2
        -- x1, x2 = (math.abs(x1)^1.1) * Utils.sign(x1), (math.abs(x2)^1.1) * Utils.sign(x2)
        x1, x2 = x1 * 140, x2 * 140
        -- This is basically backface culling lol
        if x1 < x2 then
            local quad = self.quads[i]
            local sx = (x2 - x1) / select(3, quad:getViewport())
            local luma = 1.05-math.abs((cx/1.5))
            sx = sx
            Draw.setColor({luma,luma,luma,1})
            Draw.draw(canvas, quad, x1, 0, 0, sx, 1)
        end
    end
    love.graphics.pop()
end

return CylinderTower