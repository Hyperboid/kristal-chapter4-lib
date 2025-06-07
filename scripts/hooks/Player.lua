---@class Player : Player
---@field world World
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.state_manager:addState("CLIMB", {enter = self.beginClimb, leave = self.endClimb, update = self.updateClimb})
    ---@type "left"|"right"|"up"|"down"?
    self.last_climb_direction = nil
    self.climb_delay = 0
end

function Player:beginClimb(last_state)
    self:setSprite("climb/climb")
    self.world.can_open_menu = false
end

function Player:setActor(actor)
    super.setActor(self, actor)
    local size = 14
    self.climb_collider = Hitbox(self, (self.width/2) - (size/2), (self.height/2) - (size/2) + 8, (size), (size))
end

function Player:draw()
    -- Draw the player
    super.draw(self)

    if DEBUG_RENDER then
        self.climb_collider:draw(1, 1, 0)
    end
end

function Player:endClimb(next_state)
    self:resetSprite()
    self.world.can_open_menu = true
    self.physics.move_target = nil
end

function Player:processClimbInputs()
    if self.climb_delay > 0 then
        self.climb_delay = Utils.approach(self.climb_delay, 0, DT)
        return
    end
    local dist
    if Input.down("confirm") then
        return
    end
    if Input.released("confirm") then
        dist = 3
    end
    if Input.down("left") then
        self:doClimbJump("left", dist)
    elseif Input.down("right") then
        self:doClimbJump("right", dist)
    elseif Input.down("up") then
        self:doClimbJump("up", dist)
    elseif Input.down("down") then
        self:doClimbJump("down", dist)
    end
end

---@return boolean allowed
---@return Object? obj The object, if any, responsible for this outcome.
function Player:canClimb(dx, dy)
    Object.startCache()
    local climbarea
    local trigger
    for _, area in ipairs(self.world.stage:getObjects(Registry.getEvent("climbarea"))) do
        ---@cast area Event.climbarea
        local size = 14
        local x,y = (self.width/2) - (size/2), (self.height/2) - (size/2) + 8
        x,y = x + (dx*20),y + (dy*20)
        self.climb_collider.x, self.climb_collider.y = x, y
        if area:collidesWith(self.climb_collider) then
            climbarea = area
        end
    end
    for _, event in ipairs(self.world.stage:getObjects(Event)) do
        ---@cast event Event
        local size = 14
        local x,y = (self.width/2) - (size/2), (self.height/2) - (size/2) + 8
        x,y = x + (dx*20),y + (dy*20)
        self.climb_collider.x, self.climb_collider.y = x, y
        if event.preClimbEnter and event:collidesWith(self.climb_collider) then
            trigger = event
        end
    end
    Object.endCache()
    if climbarea then
        return true, climbarea
    end
    return NOCLIP, trigger
end

---@param direction "up"|"down"|"left"|"right"
---@param distance integer?
function Player:doClimbJump(direction, distance)
    
    local charged = (distance ~= nil)
    distance = distance or 1
    local dx, dy = unpack(({
        up = {0, -1},
        down = {0, 1},
        left = {-1, 0},
        right = {1, 0},
    })[direction])
    -- Logic dictates that duration calc goes in the loop. Nope!
    local duration = (8/30)
    if charged then
        duration = (3/30) * distance
    end


    Object.startCache()
    local found_obj_dist
    for dist = distance, 1, -1 do
        local allowed, obj = self:canClimb(dx*dist, dy*dist)
        if allowed then
            Assets.playSound("wing", 0.6, 1.1 + (love.math.random()*0.1))
            self:slideTo(self.x + (dx*40*dist), self.y + (dy*40*dist), duration, "linear", function ()
                self.climb_delay = 2/30
                if self.climb_callback then
                    self:climb_callback()
                    self.climb_callback = nil
                end
                if obj and obj.onClimbEnter then
                    obj:onClimbEnter(self)
                end
            end)
            if dist == 1 then
                Assets.playSound("snd_bump")
            end
        end
        if obj and obj.preClimbEnter then
            obj:preClimbEnter(self)
        end
        if allowed then
            break
        end
    end
    Object.endCache()
end

function Player:updateClimb()
    if self:isMovementEnabled() and not self.physics.move_target then
        self:processClimbInputs()
    end
    -- Placeholder, obviously.
    local o_noclip = self.noclip
    self.noclip = true
    -- self:updateWalk()
    self.noclip = o_noclip

    Object.startCache()
    Object.endCache()
end

return Player