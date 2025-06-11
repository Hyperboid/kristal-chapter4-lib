---@class TensionBar : TensionBar
local TensionBar, super = Utils.hookScript(TensionBar)

function TensionBar:flash(...)
    -- I just know there will be a better implementation from Kristal
    if super.flash then
        return super.flash(self, ...)
    end
    if self.flashfx then
        self:removeFX(self.flashfx)
    end
    self.flashfx = ColorMaskFX()
    self:addFX(self.flashfx)
end

function TensionBar:update()
    super.update(self)
    if self.flashfx then
        self.flashfx.amount = self.flashfx.amount - (DTMULT/7)
        if self.flashfx.amount < 0 then
            self:removeFX(self.flashfx)
            self.flashfx = nil
        end
    end
end

return TensionBar