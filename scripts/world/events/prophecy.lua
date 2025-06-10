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
    self.container = Object(0,0)
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
    self.text = Text(text, self.width/2, -self.height, {auto_size = true})
    self.text:setOrigin(0.5, 1)

    self.text:addFX(ProphecyScrollFX())
    self:addChild(self.text)
end

function event:update()
    super.update(self)
    if self.sprite then
        self.sprite.y = Utils.wave(RUNTIME*2, -10, 10)
        
    end
    Object.startCache()
    if self:collidesWith(self.world.player) then
        self.afx.alpha = Utils.approach(self.afx.alpha, 1, DT*4)
    else
        self.afx.alpha = Utils.approach(self.afx.alpha, 0, DT*2)
    end
    Object.endCache()
end

return event