local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Computed = Fusion.Computed

local Button = require(script.Parent.Button)
local Background = require(script.Parent.Background)

return function(target)
    local activeState = State(1)

    local element = Background {
        Parent = target,

            [Children] = {
                Button {
                    LayoutOrder = 0,
                    Size = UDim2.fromOffset(100, 32),
                    Text = "Button 1",
                    Selected = Computed(function()
                        return activeState:get() == 1
                    end),
                    OnActivated = function()
                        activeState:set(1)
                    end,
                    ZIndex = 3,
                }.Instance,
                Button {
                    LayoutOrder = 1,
                    Size = UDim2.fromOffset(100, 32),
                    Position = UDim2.fromOffset(0, 37),
                    Text = "Button 2",
                    Selected = Computed(function()
                        return activeState:get() == 2
                    end),
                    OnActivated = function()
                        activeState:set(2)
                    end,
                    ZIndex = 3,
                }.Instance,
                Button {
                    LayoutOrder = 2,
                    Size = UDim2.fromOffset(100, 32),
                    Position = UDim2.fromOffset(0, 74),
                    Text = "Button 3",
                    Selected = Computed(function()
                        return activeState:get() == 3
                    end),
                    OnActivated = function()
                        activeState:set(3)
                    end,
                    ZIndex = 3,
                }.Instance
            }
        }

    return function()
        element:Destroy()
    end
end