---@class Player : Player
---@field world World
local Player, super = Utils.hookScript(Player)

function Player:init(chara, x, y)
    super.init(self, chara, x, y)
    self.state_manager:addState("CLIMB", {enter = self.beginClimb, leave = self.endClimb, update = self.updateClimb})
    ---@type "left"|"right"|"up"|"down"?
    self.last_climb_direction = nil
    self.climb_delay = 0
    self.jumpchargesfx = Assets.newSound("chargeshot_charge")
    self.jumpchargesfx:setLooping(true)
    self.jumpchargesfx:setVolume(0.3)
    self.jumpchargecon = -1
    self.jumpchargetimer = 0
    self.chargetime1 = 10
    self.chargetime2 = 22
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
        if self.climb_delay <= 0 then
            if self.climb_ready_callback then
                self:climb_ready_callback()
                self.climb_ready_callback = nil
            end
            self.sprite:setFrame(Utils.clampWrap(self.sprite.frame + 1, 1, #self.sprite.frames))

            if self.sprite.sprite_options[2] ~= "climb/climb" then
                self:setSprite("climb/climb")
            end
        end
        return
    end
    local dist
    if self.jumpchargecon >= 1 then
        if Input.released("confirm") then
            self:doClimbJump(self.facing, self.jumpchargeamount)
        else
            if Input.down("left") then
                self:setFacing("left")
            elseif Input.down("right") then
                self:setFacing("right")
            elseif Input.down("up") then
                self:setFacing("up")
            elseif Input.down("down") then
                self:setFacing("down")
            end
        end
        return
    else
        if Input.down("confirm") then
            self.jumpchargecon = 1
        end
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

function Player:processJumpCharge()
    if (self.jumpchargecon == 1) then
        -- climbmomentum = 0;
        -- x = remx;
        -- y = remy;
        -- jumpchargesfx = snd_loop(snd_chargeshot_charge);
        self.jumpchargesfx:play()
        self.jumpchargesfx:setPitch(0.4)
        -- snd_volume(jumpchargesfx, 0.3, 0);
        self.jumpchargetimer = 0;
        self.jumpchargeamount = 1;
        self.jumpchargecon = 2;
        self:setSprite("climb/charge/up")
        -- sprite_index = spr_kris_climb_new_charge;
        -- image_index = 0;
    end
    
    if (self.jumpchargecon == 2) then
        local docharge = 0
        
        if (Input.down("confirm") or self.jumpchargetimer < 3) then
            docharge = 1;
        end
        
        if (Input.pressed("confirm")) then
            docharge = 2;
        end
        
        if (docharge == 1) then
            if (self.facing == "up" or self.facing == "down") then
                self:setSprite("climb/charge/up");
            elseif (self.facing == "right") then
                self:setSprite("climb/charge/right");
            else
                self:setSprite("climb/charge/left");
            end
            
            self.jumpchargetimer = self.jumpchargetimer + DTMULT;
            
            if (self.jumpchargetimer >= self.chargetime1) then
                self.sprite:setFrame(2);
                self.jumpchargesfx:setPitch(0.5)
                self.jumpchargeamount = 2;
                self.color = Utils.lerp(COLORS.white, COLORS.teal, 0.2 + (math.floor(math.sin(self.jumpchargetimer / 2)) * 0.2));
            end
            
            if (self.jumpchargetimer >= self.chargetime2) then
                self.sprite:setFrame(3)
                self.jumpchargeamount = 3;
                self.jumpchargesfx:setPitch(0.7)
                self.color = Utils.lerp(COLORS.white, COLORS.teal, 0.4 + (math.floor(math.sin(self.jumpchargetimer)) * 0.4));
                
                if ((self.jumpchargetimer % 8) == 0) then
                    local afterimage = AfterImage(self, 0.3, ((1 / (0.2)) / 30 * 0.3));
                    afterimage.alpha = 0.3;
                    afterimage.graphics.grow = 0.05
                    afterimage.physics.speed_y = 1
                    afterimage:setParent(self)
                    
                    -- TODO: ahaHAHHAHAHAHHAAHAHA
                    -- if (i_ex(obj_rotating_tower_controller_new) && i_ex(obj_climb_kris)) then
                    --     afterimage.x = obj_rotating_tower_controller_new.tower_x;
                    --     afterimage.depth = obj_rotating_tower_controller_new.depth - 4;
                    -- end
                end
            end
        end
        
        if (docharge == 0) then
            self.jumpchargecon = 0;
            self.climb_jumping = 1;
            self.climbcon = 1;
            self.color = COLORS.white
            self.jumpchargesfx:stop()
        end
        
        if (docharge == 2) then
            -- snd_play(182, 0.7, 0.4);
            -- snd_play(181, 0.7, 0.4);
            -- snd_play(401, 0.2, 1.8);
            -- button2buffer = 10;
            -- jumpchargecon = 0;
            -- jumpchargetimer = 0;
            -- neutralcon = 1;
            self.color = COLORS.white;
            -- snd_stop(jumpchargesfx);
        end
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
    direction = direction or self.facing
    self:setFacing(direction)
    
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
            self.sprite:setFrame(Utils.clampWrap(self.sprite.frame + 1, 1, #self.sprite.frames))
            self:slideTo(self.x + (dx*40*dist), self.y + (dy*40*dist), duration, "linear", function ()
                self.climb_delay = 2/30
                if self.sprite.sprite_options[2] ~= "climb/climb" then
                    self:setSprite("climb/climb")
                end
                if self.climb_callback then
                    self:climb_callback()
                    self.climb_callback = nil
                end
                if obj and obj.onClimbEnter then
                    obj:onClimbEnter(self)
                end
            end)
        elseif dist == 1 and not obj then
            Assets.playSound("bump")
            self.climb_delay = 4/30
        end
        if dist <= 1 and obj and obj.preClimbEnter then
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
        if self.jumpchargecon > 0 then
            self:processJumpCharge()
        end
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