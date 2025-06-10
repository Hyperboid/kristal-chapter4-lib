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
    -- TODO: Find out what the right color is
    self.secondary_color = {1, 1, 1}
    self.secondary_offset = 100
    self.secondary_timescale = 1
    self.secondary_texture = Assets.getTexture("backgrounds/perlin_noise_looping")
end

function ProphecyScrollFX:update()
    self.tick = self.tick + ((1/15) * self.scroll_speed * DTMULT)
end

function ProphecyScrollFX:draw(texture)
    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        local shader = Assets.getShader("limitedmask")
        shader:send("min", 0)
        shader:send("max", 0.5)
        love.graphics.setShader(shader)
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    
    local t = Utils.floor(self.tick * 15, 2)
    Draw.setColor(self.color)
    love.graphics.setStencilTest("greater", 0)
    local ox, oy = self.parent:getScreenPos()
    Draw.drawWrapped(self.texture, true, true, t+ox, t+oy, 0, 2,2)

    love.graphics.stencil(function()
        local last_shader = love.graphics.getShader()
        local shader = Assets.getShader("limitedmask")
        shader:send("min", 0.5)
        shader:send("max", 1)
        love.graphics.setShader(shader)
        Draw.draw(texture)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    t = (t * self.secondary_timescale) + self.secondary_offset
    Draw.setColor(self.color)
    Draw.drawWrapped(self.texture, true, true, t+ox, t+oy, 0, 2,2)
    love.graphics.setBlendMode("add")
    Draw.drawWrapped(self.secondary_texture, true, true, t+ox, t+oy, 0, 2, 2)
    love.graphics.setBlendMode("alpha")
    love.graphics.setStencilTest()
end

return ProphecyScrollFX