local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local withTheme = require(script.Parent.withTheme)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children

type Props = {
    Size: UDim2?,
    Position: UDim2?,
    AnchorPoint: Vector2?,
    LayoutOrder: number?,
    ZIndex: number?,
    Parent: Instance,
}

local function Background(props: Props)

    return withTheme(function(themeProvider)
        return New "Frame" {
            Size = props.Size or UDim2.fromScale(1, 1),
            Position = props.Position or UDim2.fromScale(0, 0),
            AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
            LayoutOrder = props.LayoutOrder or 0,
            ZIndex = props.ZIndex or 0,
            BorderSizePixel = 0,
            BackgroundColor3 = Computed(function()
                return themeProvider.Theme:get():GetColor(Enum.StudioStyleGuideColor.MainBackground)
            end),
            Parent = props.Parent,

            [Children] = props[Children]
        }
    end)
end

return Background