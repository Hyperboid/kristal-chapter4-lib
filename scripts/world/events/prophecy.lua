---@class Event.prophecy : Event
local event, super = Class(Event, "prophecy")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    if properties.texture then
        self:setSprite(properties.texture)
    end
    self.afx = self:addFX(AlphaFX(1))
    if properties.text then
        self:setText(properties.text)
    end
end

function event:getSortPosition()
    return self.x,self.y
end

function event:setSprite(texture)
    if self.sprite then self.sprite:remove() end
    if not texture then return end
    self.sprite = Sprite(texture, self.width/2, 0)
    self.sprite:setOrigin(0.5,1)
    self:addChild(self.sprite)
    self.sprite:setScale(2)
    self.sprite:addFX(ProphecyScrollFX())
    self.sprite:addFX(ProphecyEchoFX())
end

function event:setText(text)
    if self.text then self.text:remove() end
    if not text then return end
    self.text = Text(text)
    self:addChild(self.text)
end

function event:applyTransformTo(transform, floor_x,floor_y)
    local yoff = Utils.wave(RUNTIME*math.pi/2, -20, 20)
    if floor_y then
        yoff = Utils.floor(yoff, floor_y)
    end
    super.applyTransformTo(self,transform,floor_x,floor_y)
end

function event:update()
    super.update(self)
    Object.startCache()
    if self:collidesWith(self.world.player) then
        self.afx.alpha = Utils.approach(self.afx.alpha, 1, DT*4)
    else
        self.afx.alpha = Utils.approach(self.afx.alpha, 0, DT*2)
    end
    Object.endCache()
end

return event