--[=[
    FlurioreLib legacy-compatible API sample.
    Put dist/FlurioreLib.lua into ReplicatedStorage as a ModuleScript named FlurioreLib,
    then run this file as a LocalScript in StarterPlayerScripts.
]=]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FlurioreLib = require(ReplicatedStorage:WaitForChild("FlurioreLib"))

-- This keeps the familiar FlurioreLib:MakeGui / CreateTab / AddSection pattern,
-- but the visuals, lifecycle, and components are now powered by the modular core.
local app = FlurioreLib:MakeGui({
    NameHub = "FLURIORE",
    Description = "BLACK / PINK UI FRAMEWORK",
    Color = Color3.fromRGB(255, 56, 164),
    ["Tab Width"] = 150,
    Size = UDim2.fromOffset(760, 500),
    WatermarkStyle = "Compact",
    WatermarkPosition = "TopRight",
})

local main = app:CreateTab({ Name = "Principal", Icon = "home", Selected = true })
local general = main:AddSection({ Title = "Controles", Description = "API de compatibilidad", Icon = "sliders" })

general:AddParagraph({
    Title = "FlurioreLib",
    Content = "Este ejemplo conserva los nombres más comunes de la API anterior, pero cada control reutiliza el componente del framework modular.",
})

general:AddButton({
    Title = "Mostrar notificación",
    Content = "Toast rosa con autocierre",
    Icon = "bell",
    Callback = function()
        FlurioreLib:MakeNotify({
            Title = "FlurioreLib",
            Description = "SUCCESS",
            Content = "La notificación se creó desde la API compatible.",
            Delay = 3,
            Color = Color3.fromRGB(255, 56, 164),
        })
    end,
})

local toggle = general:AddToggle({
    Title = "Activar función",
    Content = "La propiedad Value permanece accesible.",
    Default = false,
    Callback = function(value) print("Toggle Value:", value) end,
})

general:AddButton({
    Title = "Invertir toggle por código",
    Content = "Usa Set() con el comportamiento anterior.",
    Icon = "refresh",
    Callback = function() toggle:Set(not toggle.Value) end,
})

local slider = general:AddSlider({
    Title = "Intensidad",
    Content = "Min / Max / Increment / Default",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 45,
    Callback = function(value) print("Intensidad:", value) end,
})

general:AddButton({
    Title = "Establecer intensidad",
    Callback = function() slider:Set(75) end,
})

local inputSection = main:AddSection({
    Title = "Entradas",
    Description = "Texto y selecciones",
    Icon = "edit",
})

inputSection:AddInput({
    Title = "Nombre del proyecto",
    Content = "El callback se dispara al confirmar el campo.",
    Placeholder = "Mi proyecto",
    Default = "Fluriore",
    Callback = function(value) print("Proyecto:", value) end,
})

local dropdown = inputSection:AddDropdown({
    Title = "Tema secundario",
    Content = "Selección única con callback en formato de tabla por compatibilidad.",
    Options = { "Pink", "Rose", "Magenta", "Mono" },
    Default = { "Pink" },
    Callback = function(values) print("Tema seleccionado:", table.concat(values, ", ")) end,
})

inputSection:AddButton({
    Title = "Actualizar dropdown",
    Callback = function()
        dropdown:Refresh({ "Pink", "Rose", "Magenta", "Mono", "Black Cherry" }, { "Black Cherry" })
    end,
})

local multiSection = main:AddSection({ Title = "Selección múltiple", Description = "Dropdown Multi = true", Icon = "check" })
local multi = multiSection:AddDropdown({
    Title = "Componentes favoritos",
    Multi = true,
    Options = { "Button", "Toggle", "Catalog", "Modal", "Notification" },
    Default = { "Button", "Catalog" },
    Callback = function(values) print("Favoritos:", table.concat(values, ", ")) end,
})
multiSection:AddButton({ Title = "Limpiar selección", Icon = "trash", Callback = function() multi:Clear() end })

-- Tip: app:ToggleUI() hides/shows the window. app:DestroyGui() removes the entire UI and connections.
