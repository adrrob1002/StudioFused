local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local State = Fusion.State

local studioSettings = settings().Studio

local function withTheme(createFunction)
    local self = {}

    self.Theme =State(studioSettings.Theme)
    self._changed = studioSettings.ThemeChanged:Connect(function()
        self.Theme:set(studioSettings.Theme)
    end)

    return createFunction(self)
end

return withTheme