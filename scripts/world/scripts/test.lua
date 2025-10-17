return function (event)
    local text = Text("Test FUCKING text\nim a "..Utils.getClassName(event))
    text:setParallax(0)
    text.alpha = 0
    text.physics.speed_x = 2
    text.physics.speed_y = 2
    text:fadeTo(1,1, function ()
        text:fadeOutAndRemove(1)
    end)
    text.graphics.grow_x = 0.01
    text.graphics.grow_y = 0.01
    Game.world:spawnObject(text)
end
