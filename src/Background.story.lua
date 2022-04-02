local Background = require(script.Parent.Background)

return function(target)
    local element = Background {
        Parent = target,
    }

    return function()
        element:Destroy()
    end
end