---@type table<string, fun(cutscene:WorldCutscene)>
local test = {
    async = function(cutscene)
        cutscene:enableMovement()
        for i = 1,6 do
            cutscene:text("* Yo yo yo this is test fucking dialogue <- epic [PROJECT TITLE] reference[noskip:off][wait:2s]", {auto = true, skip = false})
        end
    end
}

return test