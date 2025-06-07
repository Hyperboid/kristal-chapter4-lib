---@class Event.climbentry : Event
local event, super = Class(Event, "climbentry")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.up = properties.up or false
end

---@param player Player
function event:onInteract(player, dir)
    if player.state_manager.state ~= "WALK" then return end
    if dir ~= "up" and dir ~= "down" then
        Kristal.Console:warn("climbentry interacted at a weird angle ("..dir..")! Assuming \"down\"...")
        dir = "down"
    end

    local id = "climb_fade"
    for _,follower in ipairs(self.world.followers) do
        if not follower:getFX(id) then
            local mask = follower:addFX(AlphaFX(1), id)
            self.world.timer:tween(10/30, mask, {alpha = 0})
        end
    end

    ---@param cutscene WorldCutscene
    ---@diagnostic disable-next-line: param-type-mismatch
    self.world:startCutscene(function (cutscene)
        cutscene:detachFollowers()
        local tx, ty = Utils.round(player.x-(self.x+20), 40)+(self.x+20), self.y
        if dir == "down" then
            ty = ty + 80
        else
            ty = ty - player.height
        end

        Assets.playSound("wing")
        player.sprite:set("jump_ball")
        cutscene:wait(cutscene:jumpTo(player,tx,ty,10,.5))
        player:resetSprite()
        Assets.playSound("noise")
        player:setState("CLIMB")
    end)
end

function event:onEnter(player)
    if self.world:hasCutscene() then return end
    if player.state_manager.state == "CLIMB" then
        player:setState("WALK")
        local tx, ty = player.x, self.y
        if not self.up then
            ty = ty + self.height + 40
        end
        ---@param cutscene WorldCutscene
        ---@diagnostic disable-next-line: param-type-mismatch
        self.world:startCutscene(function (cutscene)
            Assets.playSound("wing")
            player.sprite:set("jump_ball")
            cutscene:wait(cutscene:jumpTo(player,tx,ty,10,.5))
            player:resetSprite()
            Assets.playSound("noise")
            local id = "climb_fade"
            for _,follower in ipairs(self.world.followers) do
                local mask = follower:getFX(id)
                if mask then
                    self.world.timer:tween(10/30, mask, {alpha = 1}, nil, function ()
                        follower:removeFX(mask)
                    end)
                end
            end
        end)
    end
end

return event