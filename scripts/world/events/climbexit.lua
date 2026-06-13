---@class Event.climbentry : Event
local event, super = Class(Event, "climbentry")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.up = properties.up or false
    self.yoffset = properties.yoff or (self.up and -5 or (self.height + 40))
	self.exit_marker = properties["marker"] or nil
	self.party_marker = TiledUtils.parsePropertyList("partymarker", properties) or nil
	self.party_facing = TiledUtils.parsePropertyList("partyfacing", properties) or properties["partyfacing"] or nil
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
function event:preClimbEnter(player)
    if player.state_manager.state == "CLIMB" then
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
