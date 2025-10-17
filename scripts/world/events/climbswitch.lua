---@class Event.climbcoin : Event
local event, super = Class(Event, "climbswitch")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.timed = properties["timed"] or false
    self.time = properties["time"] or 300
    self.stay = properties["stay"] or false
    self:setSprite("world/events/climbswitch/climbswitch")
    self.sprite:stop()
    self.con = 0
    self.siner = 0
    self.bowlindex = 0
    self.complexsnd = ComplexSound(0,0,-1)
    self.timber = 0
    self.canceltimer = 0
    self.tickcount = 0
end

function event:update()
    super.update(self)
    self.siner = self.siner + DTMULT
    local collider = Hitbox(self, 0, 0, 40, 40)
    if self.con == 0 then
        Object.startCache()
        if Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" then
            if self.con == 0 then
                self.con = 1
            end
        end
        Object.endCache()
    end
    if self.con == 1 then
        self.complexsnd:add(1, "metalhit", 0.85, 1, 0, -1, 0)
        self.complexsnd:add(2, "swallow", 1.3, 1, 0, -1, 0)
        self.complexsnd:play()
        self.canceltimer = 0
        if self.timed then
            self.timber = self.time
        end
        self.con = 2
    end
    self.sprite:setFrame(1)
    if self.con == 2 then
        self.sprite:setFrame(2)
        if self.timed then
            Object.startCache()
            if not Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" then
                self.timber = self.timber - DTMULT
            end
            Object.endCache()
            local tickrate = 10
            
            if self.timber < 320 then
                tickrate = 8
            end
            if self.timber < 160 then
                tickrate = 6
            end
            if self.timber < 80 then
                tickrate = 4
            end
            if self.timber < 40 then
                tickrate = 2
            end
            if self.timber < 15 then
                tickrate = 1
            end
            if MathUtils.round(self.timber - 1) % tickrate == 0 then
                self.tickcount = self.tickcount + 1
                local pitch = 0.75
                if self.tickcount % 2 == 0 then
                    pitch = 1
                end
                Assets.playSound("ui_move", 0.7, pitch)
            end
            if self.timber <= 0 then
                self.complexsnd:add(1, "ghostappear", 0.8, 0.7, 0, -1, 0)
                self.complexsnd:add(2, "ghostappear", 1.3, 0.7, 0, -1, 0)
                self.complexsnd:play()
                self.con = 0
            end
        else
            if not self.stay then
                Object.startCache()
                if not Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" then
                    self.con = 0
                end
                Object.endCache()
            end
        end
    end
    self.complexsnd:update()
end

return event
