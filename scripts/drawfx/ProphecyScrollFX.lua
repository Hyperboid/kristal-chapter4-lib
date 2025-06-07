---@class ProphecyScrollFX: FXBase
local ProphecyScrollFX, super = Class(FXBase)

function ProphecyScrollFX:init(texture, priority)
    super.init(self, priority)
    ---@type love.Image
    self.texture = type(texture) == "string" and Assets.getTexture(texture) or (type(texture) == "userdata" and texture)
    self.texture = self.texture or Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_BRIGHTER")
    self.tick = 0
    self.scroll_speed = 1
    self.color = Utils.hexToRgb("#42D0FF")
end

function ProphecyScrollFX:update()
    self.tick = self.tick + ((1/15) * self.scroll_speed * DTMULT)
end

function ProphecyScrollFX:draw(texture)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    
    local t = Utils.floor(self.tick * 15, 2)
    Draw.setColor(self.color)
    love.graphics.setStencilTest("greater", .9)
    local ox, oy = self.parent:getScreenPos()
    Draw.drawWrapped(self.texture, true, true, t+ox, t+oy, 0, 2,2)
    love.graphics.setStencilTest()
end

return ProphecyScrollFX