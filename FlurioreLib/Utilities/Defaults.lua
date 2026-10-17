-- Defaults are pure data/helpers; they do not validate or create Instances.
local Defaults = {}

local function clone(value)
	if type(value) ~= "table" then return value end
	local result = {}
	for key, child in pairs(value) do result[key] = clone(child) end
	return result
end

function Defaults.Merge(defaults, supplied)
	assert(type(defaults) == "table", "Defaults.Merge: defaults debe ser una tabla")
	if supplied ~= nil then assert(type(supplied) == "table", "Defaults.Merge: options debe ser una tabla") end
	supplied = supplied or {}
	local result = {}
	for key, defaultValue in pairs(defaults) do
		local suppliedValue = supplied[key]
		if type(defaultValue) == "table" and (suppliedValue == nil or type(suppliedValue) == "table") then
			result[key] = Defaults.Merge(defaultValue, suppliedValue)
		elseif suppliedValue ~= nil then
			-- No usar `suppliedValue or defaultValue`: eso destruye false y otros valores falsy.
			result[key] = clone(suppliedValue)
		else
			result[key] = clone(defaultValue)
		end
	end
	-- Preserve extension keys so themes/components can add their own options.
	for key, suppliedValue in pairs(supplied) do
		if defaults[key] == nil then result[key] = clone(suppliedValue) end
	end
	return result
end

function Defaults.Clone(value)
	return clone(value)
end

Defaults.Framework = {
	Name = "FlurioreLib",
	Parent = nil,
	ResetOnSpawn = false,
	DisplayOrder = 50,
	Theme = {},
	Animation = true,
	Debug = false,
    Watermark = {
        Enabled = true, Title = "FLURIORE LIB", LogoText = "F", ShowLogo = true, ShowGameName = true,
        ShowGameIcon = true, ShowFPS = true, ShowClock = false, ShowStatus = true,
        Position = "TopRight", Style = "Compact", Status = "RUNNING", BackgroundTransparency = 0.12, Width = 300,
    },
}

Defaults.Window = {
	Id = nil,
	Title = "FlurioreLib",
	Description = "",
	Icon = nil,
	Size = UDim2.fromOffset(780, 520),
	Position = UDim2.fromScale(0.5, 0.5),
	MinSize = Vector2.new(420, 300),
	MaxSize = Vector2.new(1400, 960),
	AdaptiveSize = true,
	Draggable = true,
	Resizable = true,
	Minimizable = true,
	Maximizable = true,
	Closable = true,
	CloseBehavior = "Hide", -- Hide | Destroy
	Animation = true,
	SidebarWidth = 168,
}

Defaults.Theme = {
	-- Fluriore identity: near-black surfaces with confident pink/fuchsia accents.
	Background = Color3.fromRGB(10, 9, 13),
	Surface = Color3.fromRGB(16, 13, 19),
	SurfaceRaised = Color3.fromRGB(27, 20, 30),
	SurfaceHover = Color3.fromRGB(40, 25, 42),
	SurfaceInset = Color3.fromRGB(7, 7, 10),
	SurfaceSelected = Color3.fromRGB(55, 20, 47),
	Border = Color3.fromRGB(63, 42, 59),
	BorderSubtle = Color3.fromRGB(40, 28, 39),
	BorderFocus = Color3.fromRGB(255, 72, 180),
	Text = Color3.fromRGB(250, 244, 249),
	MutedText = Color3.fromRGB(171, 151, 169),
	Accent = Color3.fromRGB(255, 56, 164),
	AccentSecondary = Color3.fromRGB(255, 105, 210),
	AccentSoft = Color3.fromRGB(65, 23, 49),
	AccentText = Color3.fromRGB(255, 250, 253),
	Danger = Color3.fromRGB(255, 80, 112),
    Warning = Color3.fromRGB(255, 186, 86),
	Success = Color3.fromRGB(85, 207, 147),
	Info = Color3.fromRGB(170, 116, 255),
	Disabled = Color3.fromRGB(107, 91, 105),
	Shadow = Color3.fromRGB(0, 0, 0),
	CornerRadius = 12,
}

return Defaults
