---@class RippleEffect: Object
local RippleEffect, super = Class(Object)

function RippleEffect:init(x,y,color,max_radius, mask)
    super.init(self, x, y)
    if color then
        self:setColor(color)
    end
    if mask then
        if mask:includes(Object) then
            self.mask = self:addFX(MaskFX(mask))
        elseif mask:includes(FXBase) then
            self.mask = self:addFX(mask)
        end
    end
    self.max_radius = max_radius or 100
    self.lifetime = 0
    self.shader = Assets.getShader("ripple")
    self.thickness = 10
end

function RippleEffect:update()
    super.update(self)
    if self:getCurrentRadius() > self.max_radius then
        self:remove()
    end
    self.lifetime = self.lifetime + DT
end

-- TODO: Accuracy
function RippleEffect:getCurrentRadius()
    return (self.lifetime^0.5) * 4 * 30
end

function RippleEffect:getDebugRectangle()
    local r = (self:getCurrentRadius())
    return {-r,-r,r*2,r*2}
end

-- TODO: Accuracy, cont'd
function RippleEffect:draw()
    super.draw(self)
    local cx, cy = love.graphics.transformPoint(0,0)
    love.graphics.origin()
    local r = self:getCurrentRadius()
    self.shader:send("rippleCenter", {cx,cy})
    self.shader:send("rippleRad", {r, self.max_radius, self.thickness})
    love.graphics.setShader(self.shader)
    love.graphics.rectangle("fill", 0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setShader()
    local scale = 0.6
    self.shader:send("rippleRad", {r*scale, self.max_radius*scale, self.thickness})
    love.graphics.setShader(self.shader)
    love.graphics.rectangle("fill", 0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
    love.graphics.setShader()
end

return RippleEffect