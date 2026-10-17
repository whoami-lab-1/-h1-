--[=[
    FlurioreLib v3.0.0
    A modular black-and-pink Roblox UI framework, bundled with Darklua.

    Modern API:
        local ui = FlurioreLib.new({ Name = "MyProject" })
        local window = ui:CreateWindow({ Title = "My panel" })

    Legacy-compatible API, adapted from the supplied FlurioreLib reference:
        local tabs = FlurioreLib:MakeGui({ NameHub = "My project" })
        local tab = tabs:CreateTab({ Name = "Main", Icon = "home" })
        local section = tab:AddSection("General")
        section:AddButton({ Title = "Run", Callback = function() end })

    The original implementation was not copied verbatim. Its public shape is kept
    where useful while input, lifecycle, layout, and service handling use the shared core.
]=]
local Framework = require("./Core/Framework")
local Defaults = require("./Utilities/Defaults")
local Icons = require("./Utilities/Icons")

local FlurioreLib = {
    Version = Framework.Version,
    Name = "FlurioreLib",
    Icons = Icons,
    Colors = Defaults.Theme,
}

local PINK = Color3.fromRGB(255, 56, 164)
local PINK_LIGHT = Color3.fromRGB(255, 105, 210)

local function cloneOptions(options)
    local result = {}
    for key, value in pairs(options or {}) do result[key] = value end
    return result
end

function FlurioreLib.new(selfOrOptions, maybeOptions)
    local options
    if selfOrOptions == FlurioreLib then options = maybeOptions else options = selfOrOptions end
    options = cloneOptions(options)
    if options.Name == nil then options.Name = "FlurioreLib" end
    options.Theme = cloneOptions(options.Theme)
    -- Defaults are applied centrally by ThemeManager; preserve the caller's overrides.
    if options.Theme.Accent == nil then options.Theme.Accent = PINK end
    if options.Theme.AccentSecondary == nil then options.Theme.AccentSecondary = PINK_LIGHT end
    if options.Theme.AccentSoft == nil then options.Theme.AccentSoft = Color3.fromRGB(65, 23, 49) end
    if options.Theme.BorderFocus == nil then options.Theme.BorderFocus = PINK end
    if options.Watermark == nil then
        options.Watermark = {
            Enabled = true,
            Title = "FLURIORE LIB",
            LogoText = "F",
            ShowLogo = true,
            ShowGameName = true,
            ShowGameIcon = true,
            ShowFPS = true,
            ShowClock = false,
            ShowStatus = true,
            Position = "TopRight",
            Style = "Compact",
            Status = "READY",
        }
    elseif type(options.Watermark) == "table" then
        options.Watermark = cloneOptions(options.Watermark)
        if options.Watermark.Title == nil then options.Watermark.Title = "FLURIORE LIB" end
        if options.Watermark.LogoText == nil then options.Watermark.LogoText = "F" end
    end
    return Framework.new(options)
end

FlurioreLib.Create = FlurioreLib.new
FlurioreLib.Crear = FlurioreLib.new

local function makeControlProxy(component, kind, options)
    local proxy = {
        _component = component,
        _kind = kind,
        _options = options and options.Options or {},
        _multiple = options and options.Multi == true,
    }

    local function legacyValue(value)
        if kind ~= "Dropdown" then return value end
        if proxy._multiple then return type(value) == "table" and table.clone(value) or {} end
        if value == nil then return {} end
        if type(value) == "table" then return value end
        return { value }
    end

    local function setValue(value, fireCallback)
        if kind == "Dropdown" then
            if proxy._multiple then
                if type(value) ~= "table" then value = { value } end
            else
                if type(value) == "table" then value = value[1] end
            end
        end
        if component.SetValue then return component:SetValue(value, fireCallback ~= false) end
        if component.SetText then return component:SetText(tostring(value or "")) end
    end

    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Value" then
                if component.GetValue then return legacyValue(component:GetValue()) end
                return rawget(self, "_value")
            elseif key == "Options" and kind == "Dropdown" then
                return rawget(self, "_options")
            elseif key == "Set" or key == "SetValue" then
                return function(_, value, fireCallback) return setValue(value, fireCallback) end
            elseif key == "Get" or key == "GetValue" then
                return function()
                    if component.GetValue then return legacyValue(component:GetValue()) end
                    return rawget(self, "_value")
                end
            elseif key == "Clear" and kind == "Dropdown" then
                return function()
                    if component.ClearOptions then component:ClearOptions() end
                    rawset(self, "_options", {})
                end
            elseif key == "AddOption" and kind == "Dropdown" then
                return function(_, option)
                    if component.AddOption then
                        component:AddOption(option)
                        table.insert(rawget(self, "_options"), option)
                    end
                end
            elseif key == "Refresh" and kind == "Dropdown" then
                return function(_, newOptions, selecting)
                    newOptions = newOptions or {}
                    if component.SetOptions then component:SetOptions(newOptions) end
                    rawset(self, "_options", table.clone(newOptions))
                    if selecting ~= nil then setValue(selecting, true) end
                end
            end

            local member = component[key]
            if type(member) == "function" then
                return function(_, ...) return member(component, ...) end
            end
            if member ~= nil then return member end
            return nil
        end,
        __newindex = function(self, key, value)
            if key == "Value" then
                setValue(value, true)
            else
                rawset(self, key, value)
            end
        end,
    })
end

local function makeLegacyItems(section)
    local items = { Section = section }

    function items:AddParagraph(config)
        config = cloneOptions(config)
        local component = section:AddParagraph({
            Title = config.Title or "Title",
            Text = config.Content or config.Text or "",
            Description = config.Description,
        })
        local proxy = { _component = component }
        function proxy:Set(nextConfig)
            if type(nextConfig) == "string" then component:SetText(nextConfig); return end
            nextConfig = nextConfig or {}
            if nextConfig.Title ~= nil then component:SetTitle(tostring(nextConfig.Title)) end
            if nextConfig.Content ~= nil or nextConfig.Text ~= nil then component:SetText(tostring(nextConfig.Content or nextConfig.Text or "")) end
        end
        function proxy:Destroy() component:Destroy() end
        return proxy
    end

    function items:AddButton(config)
        config = cloneOptions(config)
        return makeControlProxy(section:AddButton({
            Title = config.Title or "Button",
            Description = config.Content or config.Description or "",
            Icon = config.Icon or "sparkles",
            Variant = config.Variant or "Secondary",
            Callback = type(config.Callback) == "function" and config.Callback or function() end,
            Enabled = config.Enabled ~= false,
        }), "Button", config)
    end

    function items:AddToggle(config)
        config = cloneOptions(config)
        local initial = config.Default
        if initial == nil then initial = false end
        return makeControlProxy(section:AddToggle({
            Title = config.Title or "Toggle",
            Description = config.Content or config.Description or "",
            Value = initial == true,
            Callback = type(config.Callback) == "function" and config.Callback or function() end,
            Enabled = config.Enabled ~= false,
        }), "Toggle", config)
    end

    function items:AddSlider(config)
        config = cloneOptions(config)
        local minimum = tonumber(config.Min) or 0
        local maximum = tonumber(config.Max) or 100
        local default = config.Default
        if default == nil then default = minimum end
        return makeControlProxy(section:AddSlider({
            Title = config.Title or "Slider",
            Description = config.Content or config.Description or "",
            Min = minimum,
            Max = maximum,
            Step = tonumber(config.Increment or config.Step) or 1,
            Value = default,
            Callback = type(config.Callback) == "function" and config.Callback or function() end,
            Enabled = config.Enabled ~= false,
        }), "Slider", config)
    end

    function items:AddInput(config)
        config = cloneOptions(config)
        local isNumeric = string.lower(tostring(config.Type or config.InputType or "text")) == "number"
            or string.lower(tostring(config.Type or config.InputType or "text")) == "numeric"
        local kind = isNumeric and "NumericInput" or "TextInput"
        local initialValue = config.Default
        if initialValue == nil then
            -- NumericInput must receive a number even when the legacy caller omitted Default.
            initialValue = isNumeric and (tonumber(config.Min) or 0) or ""
        end
        local componentOptions = {
            Title = config.Title or "Input",
            Description = config.Content or config.Description or "",
            Placeholder = config.Placeholder or "Enter a value…",
            Value = initialValue,
            Callback = type(config.Callback) == "function" and config.Callback or function() end,
            Enabled = config.Enabled ~= false,
        }
        if isNumeric then
            componentOptions.Min = config.Min
            componentOptions.Max = config.Max
            componentOptions.Integer = config.Integer == true
        end
        return makeControlProxy(section:Add(kind, componentOptions), kind, config)
    end

    function items:AddDropdown(config)
        config = cloneOptions(config)
        local multiple = config.Multi == true
        local default = config.Default
        if default == nil then default = multiple and {} or nil end
        if not multiple and type(default) == "table" then default = default[1] end
        local callback = type(config.Callback) == "function" and config.Callback or function() end
        local component = section:Add(multiple and "MultiSelect" or "Dropdown", {
            Title = config.Title or "Dropdown",
            Description = config.Content or config.Description or "",
            Options = config.Options or {},
            Value = default,
            Searchable = config.Searchable == true,
            Multiple = multiple,
            MinSelected = tonumber(config.MinSelected) or 0,
            MaxSelected = config.MaxSelected,
            Callback = function(value, control)
                if multiple then callback(value, control)
                else callback(value == nil and {} or { value }, control) end
            end,
            Enabled = config.Enabled ~= false,
        })
        return makeControlProxy(component, "Dropdown", config)
    end

    function items:AddCheckbox(config)
        config = cloneOptions(config)
        return makeControlProxy(section:AddCheckbox({
            Title = config.Title or "Checkbox", Description = config.Content or config.Description or "",
            Value = config.Default == true, Callback = config.Callback,
        }), "Checkbox", config)
    end

    function items:AddColorPicker(config)
        config = cloneOptions(config)
        return makeControlProxy(section:AddColorPicker({
            Title = config.Title or "Color", Value = config.Default or config.Value or PINK,
            Callback = config.Callback,
        }), "ColorPicker", config)
    end

    function items:AddKeybind(config)
        config = cloneOptions(config)
        return makeControlProxy(section:AddKeybind({
            Title = config.Title or "Keybind", Value = config.Default or config.Value or Enum.KeyCode.RightShift,
            Callback = config.Callback,
        }), "Keybind", config)
    end

    function items:AddMultiSelect(config)
        config = cloneOptions(config)
        config.Multi = true
        return items:AddDropdown(config)
    end

    function items:AddLabel(config)
        if type(config) == "string" then config = { Text = config } end
        config = cloneOptions(config)
        return section:AddLabel({ Text = config.Text or config.Title or "", Icon = config.Icon })
    end

    function items:AddDivider(config)
        return section:AddDivider(type(config) == "table" and config or {})
    end

    function items:AddCard(config)
        config = cloneOptions(config)
        return section:AddCard(config)
    end

    function items:AddProgress(config)
        config = cloneOptions(config)
        return section:AddProgress(config)
    end

    function items:AddImage(config)
        config = cloneOptions(config)
        return section:AddImage(config)
    end

    return items
end

local function configFromLegacy(config)
    config = cloneOptions(config)
    local accent = config.Color or PINK
    local watermarkOptions
    if config.Watermark == false then
        watermarkOptions = false
    else
        watermarkOptions = {
            Enabled = config.ShowWatermark ~= false,
            Title = config.WatermarkTitle or config.NameHub or "FLURIORE LIB",
            LogoText = "F",
            LogoImage = config.WatermarkLogo,
            ShowLogo = config.ShowWatermarkLogo ~= false,
            ShowGameName = config.ShowGameName ~= false,
            ShowGameIcon = config.ShowGameIcon ~= false,
            ShowFPS = config.ShowFPS ~= false,
            ShowClock = config.ShowClock == true,
            ShowStatus = true,
            Position = config.WatermarkPosition or "TopRight",
            Style = config.WatermarkStyle or "Compact",
            Status = "READY",
        }
    end
    local themeOptions = {
        Accent = accent,
        AccentSecondary = config.AccentSecondary or PINK_LIGHT,
        AccentSoft = config.AccentSoft or Color3.fromRGB(65, 23, 49),
        BorderFocus = accent,
        Background = config.Background,
        Surface = config.Surface,
        SurfaceRaised = config.SurfaceRaised,
    }
    -- Allow explicit theme tokens without forcing legacy callers to migrate first.
    if type(config.Theme) == "table" then
        for key, value in pairs(config.Theme) do themeOptions[key] = value end
    end
    -- A full watermark table takes precedence over the shorthand legacy flags.
    if type(config.Watermark) == "table" then
        watermarkOptions = cloneOptions(watermarkOptions or {})
        for key, value in pairs(config.Watermark) do watermarkOptions[key] = value end
    end
    return {
        Name = config.InstanceName or config.GuiName or "FlurioreLib",
        Animation = config.Animation ~= false,
        ResetOnSpawn = false,
        DisplayOrder = config.DisplayOrder or 50,
        Theme = themeOptions,
        Watermark = watermarkOptions,
    }
end

local function makeGuiFacade(config)
    config = config or {}
    local options = configFromLegacy(config)
    local framework = FlurioreLib.new(options)
    local window = framework:CreateWindow({
        Id = "main",
        Title = tostring(config.NameHub or config.Title or "FlurioreLib"),
        Description = tostring(config.Description or "Black / Pink UI Framework"),
        Icon = config.WindowIcon or "heart",
        Size = typeof(config.Size) == "UDim2" and config.Size or UDim2.fromOffset(760, 490),
        Position = typeof(config.Position) == "UDim2" and config.Position or UDim2.fromScale(0.5, 0.5),
        SidebarWidth = math.clamp(tonumber(config["Tab Width"]) or 156, 120, 210),
        Draggable = config.Draggable ~= false,
        Resizable = config.Resizable ~= false,
        Minimizable = config.Minimizable ~= false,
        Maximizable = config.Maximizable ~= false,
        Closable = true,
        CloseBehavior = config.CloseBehavior == "Destroy" and "Destroy" or "Hide",
    })

    local facade = {
        Framework = framework,
        Window = window,
        Gui = framework.Gui,
        Tabs = {},
        _destroyed = false,
    }

    function facade:CreateTab(tabConfig)
        if self._destroyed then return nil end
        if type(tabConfig) == "string" then tabConfig = { Name = tabConfig } end
        tabConfig = tabConfig or {}
        local tab = window:AddTab({
            Title = tostring(tabConfig.Name or tabConfig.Title or "Tab"),
            Id = tabConfig.Id or tabConfig.Name or tabConfig.Title,
            Icon = tabConfig.Icon or "layers",
            Description = tabConfig.Description or "",
            Badge = tabConfig.Badge,
            Selected = tabConfig.Selected == true,
        })
        local tabFacade = { Tab = tab, Name = tab.Title, Sections = {} }
        function tabFacade:AddSection(sectionConfig)
            if type(sectionConfig) == "string" then sectionConfig = { Title = sectionConfig } end
            sectionConfig = sectionConfig or {}
            local section = tab:AddSection({
                Title = tostring(sectionConfig.Title or sectionConfig.Name or "Section"),
                Description = sectionConfig.Description or "",
                Icon = sectionConfig.Icon,
                Collapsible = sectionConfig.Collapsible == true,
                Expanded = sectionConfig.Expanded ~= false,
                Accent = sectionConfig.Accent == true,
                Spacing = sectionConfig.Spacing,
            })
            local items = makeLegacyItems(section)
            table.insert(self.Sections, items)
            return items
        end
        function tabFacade:Show() window:ShowTab(tab) end
        function tabFacade:Destroy() tab:Destroy() end
        table.insert(self.Tabs, tabFacade)
        return tabFacade
    end

    function facade:DestroyGui()
        if self._destroyed then return end
        self._destroyed = true
        framework:Destroy()
    end
    facade.Destroy = facade.DestroyGui
    function facade:ToggleUI()
        if self._destroyed then return end
        window:SetVisible(not window.Visible)
    end
    function facade:SetVisible(visible)
        if self._destroyed then return end
        window:SetVisible(visible == true)
    end
    function facade:Notify(notificationOptions)
        return framework:Notify(notificationOptions or {})
    end
    function facade:CreateWindow(windowOptions)
        return framework:CreateWindow(windowOptions or {})
    end
    function facade:GetFramework() return framework end
    return facade
end

function FlurioreLib.MakeGui(selfOrConfig, maybeConfig)
    local config = maybeConfig ~= nil and maybeConfig or selfOrConfig
    if config == FlurioreLib then config = {} end
    return makeGuiFacade(config)
end
FlurioreLib.MakeGUI = FlurioreLib.MakeGui

local notificationHost
local notificationHostCleanupToken = 0
function FlurioreLib.MakeNotify(selfOrConfig, maybeConfig)
    local config = maybeConfig ~= nil and maybeConfig or selfOrConfig
    if config == FlurioreLib or type(config) ~= "table" then config = {} end
    if not notificationHost or notificationHost._destroyed then
        notificationHost = FlurioreLib.new({
            Name = "FlurioreNotifications",
            Animation = true,
            Watermark = false,
        })
    end
    local duration = tonumber(config.Delay)
    if duration == nil then duration = 5 end
    local notification = notificationHost:Notify({
        Title = config.Title or "FlurioreLib",
        Label = config.Description or config.Label or "NOTIFICATION",
        Description = config.Content or config.Message or "",
        Type = config.Type or "Default",
        Color = config.Color,
        Icon = config.Icon or "bell",
        Duration = duration,
        Width = config.Width or 330,
    })

    -- Reclaim the lightweight host once all timed toasts are gone. Duration <= 0
    -- means persistent and intentionally requires CloseNotifications() for cleanup.
    if duration > 0 then
        notificationHostCleanupToken += 1
        local token = notificationHostCleanupToken
        task.delay(duration + 1, function()
            if token ~= notificationHostCleanupToken then return end
            if notificationHost and not notificationHost._destroyed and #notificationHost._notifications == 0 then
                notificationHost:Destroy()
                notificationHost = nil
            end
        end)
    end
    return notification
end

function FlurioreLib.CloseNotifications()
    if notificationHost and not notificationHost._destroyed then
        notificationHost:Destroy()
    end
    notificationHost = nil
    notificationHostCleanupToken += 1
end

return FlurioreLib
