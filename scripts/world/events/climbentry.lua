---@class Event.climbentry : Event
local event, super = Class(Event, "climbentry")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.up = properties.up or false
    self.yoffset = properties.yoff or (self.up and -5 or (self.height + 40))
	self.marker = properties["marker"] or nil
	self.exit_marker = properties["exitmarker"] or nil
	self.party_marker = properties["partymarker"] and TiledUtils.parsePropertyList("partymarker", properties) or nil
	self.party_facing = properties["partyfacing"] and TiledUtils.parsePropertyList("partyfacing", properties) or nil
	self.allow_exit = properties["exit"] or true
	self.need_climbclaws = properties["clawsneeded"] or true
	self.center_if_tower = properties["towercenter"] ~= false
    self.timer = self:addChild(Timer())
	self.true_x = self.x
end

function event:update()
    super.update(self)
	if self.center_if_tower and self.world.map.cyltower and self.world.player and not (self.world.player.onrotatingtower) then
		self.x = self.world.map.cyltower.tower_x - 20
	else
		self.x = self.true_x
	end
    if
        not Game.lock_movement
        and self.world:hasCutscene()
        and Input.pressed("confirm")
        and self.world.player.interact_collider[self.world.player.facing]:collidesWith(self)
    then
        self:onInteract(self.world.player, self.world.player.facing)
    end
end

---@param chara Character
local function jumpTo(chara, ...)
    chara:jumpTo(...)
    return function() return not chara.jumping end
end

local function co_wrap(func)
    local thread = coroutine.create(func)
    return function (...)
        local ok, msg = coroutine.resume(thread, ...)
        if not ok then
            COROUTINE_TRACEBACK = debug.traceback(thread)
            error(msg)
        end
    end
end

function event:startScript(func)
    local co co = co_wrap(function ()
        Game.lock_movement = true
        func({wait = function (t)
            if type(t) == "number" then
                self.timer:after(t, co)
            else
                self.timer:afterCond(t, co)
            end
            coroutine.yield()
        end})
        Game.lock_movement = false
    end)
    co()
end

---@param player Player
function event:onInteract(player, dir)
    if player.state_manager.state ~= "WALK" then return end
	if self.need_climbclaws and not Game.inventory:getDarkInventory():hasItem("claimbclaws") then
		Game.world:showText("* (It looks like you'd be able to climb this if you had the right tools.)")
		return true
	end
    if dir ~= "up" and dir ~= "down" and not self.marker then
        Kristal.Console:warn("climbentry interacted at a weird angle ("..dir..")! Assuming \"down\"...")
        dir = "down"
    end

    local id = "climb_fade"
    local id2 = "climb_color"
    for _,follower in ipairs(self.world.followers) do
        local colormask = follower:addFX(RecolorFX(1,1,1,1,1), id2)
        local mask = follower:addFX(AlphaFX(1), id)
        self.world.timer:tween(7/30, colormask, {color = {0.5,0.5,0.5,1}})
        self.world.timer:tween(7/30, mask, {alpha = 0})
		follower.shadow_force_off = true
		follower.highlight_force_off = true
    end
	player.highlight_force_off = true

    self:startScript(function (scr)
        -- TODO: Accurate camera movement
        self.world:setCameraAttached(false)
		if self.world.map.cyltower and self.center_if_tower then
			self.world.camera:panTo(self.world.map.cyltower.tower_x - SCREEN_WIDTH/2, self.world.camera.y, 8/30)
		end
        local tx = MathUtils.roundToMultiple(player.x-(self.x+20), 40)+(self.x+20)
        tx = MathUtils.clamp(tx, self.x+20, self.x+self.width-20)
        local ty = MathUtils.round(self.y, 40)
        if dir == "down" then
            ty = ty + 80
        else
            ty = ty
        end
		if self.marker then
			tx, ty = self.world.map:getMarker(self.marker)
		end
        
        Assets.playSound("wing")
        player.sprite:set("jump_ball")
        scr.wait(jumpTo(player,tx,ty,8,8/30))
        player:resetSprite()
        self.world:detachFollowers()
        Assets.playSound("noise")
        player:setState("CLIMB")
		if self.world.map.cyltower then
			if self.center_if_tower then
				player.x = self.true_x + 20
			end
			Kristal.Console:log(self.world.map.cyltower.tower_angle)
			player.onrotatingtower = true
			player.falseloop = true
			player.falseloopx = {}
			player.falseloopx[1] = 0
			player.falseloopx[2] = self.world.map.cyltower.tower_circumference
		end
    end)
end

---@param player Player
function event:preClimbEnter(player)
    if player.state_manager.state == "CLIMB" and self.allow_exit then
        player:setState("WALK")
        local tx, ty = player.x, self.y
        ty = ty + self.yoffset
		if self.world.map.cyltower then
			tx = self.world.map.cyltower.tower_x
			self.world.player.onrotatingtower = false
			self.world.player.x = tx
		end
		if self.exit_marker then
			tx, ty = self.world.map:getMarker(self.exit_marker)
		end
        local cx, cy = self.x + (self:getScaledWidth()/2), self.y+(self.up and -42 or 43)
		if self.world.map.cyltower then
			cx = self.world.camera.x
		end
		if self.exit_marker then
			cx, cy = self.world.map:getMarker(self.exit_marker)
		end
		self.world.camera:panTo(cx, cy, 16/30, nil, function()
			self.world.camera:setAttached(true)
		end)
        self:startScript(function (scr)
            Assets.stopAndPlaySound("wing")
            player.sprite:set("jump_ball")
			local jumpstrength = 8
			if player.facing == "up" then
				jumpstrength = 12
			end
            scr.wait(jumpTo(player,tx,ty,jumpstrength,16/30))
            player:resetSprite()
            Assets.playSound("noise")
			local id = "climb_fade"
			local id2 = "climb_color"
            for i,follower in ipairs(self.world.followers) do
                local mask = follower:getFX(id)
                if mask then
                    self.world.timer:tween(8/30, mask, {alpha = 1}, nil, function ()
                        follower:removeFX(mask)
                    end)
                end
                local colormask = follower:getFX(id2)
                if colormask then
                    self.world.timer:tween(8/30, colormask, {color = {1,1,1,1}}, nil, function ()
                        follower:removeFX(colormask)
                    end)
                end
				self.world.timer:after(8/30, function()
					follower.shadow_force_off = false
					follower.highlight_force_off = false
				end)
                -- TODO: Support parties > 3
				local fx, fy = tx + (i == 1 and -30 or 30), ty + (self.up and 10 or -10)
				if self.party_marker and type(self.party_marker) == "table" then
					fx, fy = self.world.map:getMarker(self.party_marker[i])
				end
                follower:setPosition(fx, fy)
                follower:setFacing(type(self.exit_facing) == "table" and self.exit_facing[i] or player.facing)
            end
			self.world.player.highlight_force_off = false
            self.world.player:interpolateFollowers()
            self.world:attachFollowers()
        end)
    end
end

return event
