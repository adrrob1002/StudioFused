local Packages = script.Parent.Parent
local Fusion = require(Packages.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent

local withTheme = require(script.Parent.withTheme)

local Constants = require(script.Parent.Constants)

local function BaseButton(props)
    local self = {}

    self.props = {
        LayoutOrder = State(0),
        Disabled = State(false),
        Selected = State(false),
        Position = State(UDim2.fromScale(0, 0)),
        AnchorPoint = State(Vector2.new(0, 0)),
        Size = State(UDim2.fromScale(1, 1)),
        Text = State("Button.defaultProps.Text"),
        TextColorStyle = State(Enum.StudioStyleGuideColor.ButtonText),
        BackgroundColorStyle = State(Enum.StudioStyleGuideColor.Button),
        BorderColorStyle = State(Enum.StudioStyleGuideColor.ButtonBorder),
    }

    for key, value in pairs(props) do
        if self.props[key] then
            if type(value) == "table" and value["get"] then
                self.props[key] = value
            else
                self.props[key]:set(value)
            end
        else
            self.props[key] = value
        end
    end

    if not self.props.OnActivated then
        self.props.OnActivated = function() end
    end

    self._hover = State(false)
    self._press = State(false)

    self._mouseEnter = function()
        if self.props.Disabled:get() then return end
        self._hover:set(true)
    end

    self._mouseLeave = function()
        if self.props.Disabled:get() then return end
        self._hover:set(false)
        self._press:set(false)
    end

    self._mouseDown = function()
        if self.props.Disabled:get() then return end
        self._press:set(true)
    end

    self._mouseUp = function()
        if self.props.Disabled:get() then return end
        self._press:set(false)
    end

    self._onActivated = function()
        if self.props.Disabled:get() then return end
        self.props.OnActivated()
    end

    self._modifier = Computed(function()
        if self.props.Disabled:get() then
            return Enum.StudioStyleGuideModifier.Disabled
        elseif self.props.Selected:get() then
            return Enum.StudioStyleGuideModifier.Selected
        elseif self._press:get() then
            return Enum.StudioStyleGuideModifier.Pressed
        elseif self._hover:get() then
            return Enum.StudioStyleGuideModifier.Hover
        end

        return Enum.StudioStyleGuideModifier.Default
    end)

    self.Instance = withTheme(function(themeProvider)
        return New "TextButton" {
            Size = self.props.Size,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            LayoutOrder = self.props.LayoutOrder,
            Text = self.props.Text,
            Font = Constants.Font,
			TextSize = Constants.TextSize,
			TextColor3 = Computed(function()
                return themeProvider.Theme:get():GetColor(self.props.TextColorStyle:get(), self._modifier:get())
            end),
			BackgroundColor3 = Computed(function()
                return themeProvider.Theme:get():GetColor(self.props.BackgroundColorStyle:get(), self._modifier:get())
            end),
			BorderColor3 = Computed(function()
                return themeProvider.Theme:get():GetColor(self.props.BorderColorStyle:get(), self._modifier:get())
            end),
			BorderMode = Enum.BorderMode.Inset,
			AutoButtonColor = false,
			[OnEvent "MouseEnter"] = self._mouseEnter,
			[OnEvent "MouseLeave"] = self._mouseLeave,
            [OnEvent "MouseButton1Down"] = self._mouseDown,
            [OnEvent "MouseButton1Up"] = self._mouseUp,
			[OnEvent "Activated"] = self._onActivated,

            [Children] = self.props[Children]
        }
    end)

    return self
end

return BaseButton