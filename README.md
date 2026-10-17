# FlurioreLib 3.0.0

**FlurioreLib** es una biblioteca de interfaz para Roblox Luau inspirada en la API y la estética de la FlurioreLib antigua adjunta: superficies negras, detalles rosa/fucsia, iconos, ventanas flotantes y controles compactos. En esta edición, la UI se apoya en el núcleo modular que ya desarrollamos, en lugar de mantener la antigua implementación gigante basada en eventos globales.

## Inicio rápido

1. Instala [Darklua](https://darklua.com/docs/getting-started/) mediante Rokit o con el ejecutable oficial.
2. Ejecuta `build.bat` en Windows o `bash build/build.sh` en Linux/macOS.
3. Darklua generará `dist/FlurioreLib.lua`.
4. Copia su contenido en un `ModuleScript` llamado `FlurioreLib` dentro de `ReplicatedStorage`.
5. Ejecuta uno de los ejemplos de `FlurioreLib/Examples` como `LocalScript` dentro de `StarterPlayerScripts`.

La UI se ejecuta en el cliente y monta de forma predeterminada en `PlayerGui`; no necesita escribir directamente en `CoreGui`.

## API moderna

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FlurioreLib = require(ReplicatedStorage:WaitForChild("FlurioreLib"))

local ui = FlurioreLib.new({
    Name = "MyFlurioreProject",
    Animation = true,
    Theme = {
        Accent = Color3.fromRGB(255, 56, 164),
        AccentSecondary = Color3.fromRGB(255, 105, 210),
    },
    Watermark = {
        Enabled = true,
        Title = "MY PROJECT",
        LogoText = "F",
        Position = "TopRight",
        Style = "Compact",
    },
})

local window = ui:CreateWindow({
    Id = "main",
    Title = "Fluriore",
    Description = "Black / Pink interface",
    Icon = "heart",
    Size = UDim2.fromOffset(760, 500),
})

local tab = window:AddTab({ Title = "General", Icon = "home" })
local section = tab:AddSection({
    Title = "Options",
    Description = "Reusable controls",
    Icon = "sliders",
})

section:AddButton({
    Title = "Notify",
    Description = "Show a toast",
    Icon = "bell",
    Variant = "Primary",
    Callback = function()
        ui:Notify({ Title = "Fluriore", Description = "It works!", Type = "Success" })
    end,
})

section:AddToggle({ Title = "Enabled", Value = true, Callback = print })
section:AddSlider({ Title = "Intensity", Min = 0, Max = 100, Step = 5, Value = 45, Callback = print })
section:AddDropdown({ Title = "Mode", Options = { "Quiet", "Normal", "Fast" }, Value = "Normal", Callback = print })
```

## API compatible con el código antiguo

También se incluye un adaptador para los métodos más utilizados de la referencia original. Esto permite migrar gradualmente sin tener que reconstruir cada pantalla el mismo día.

```lua
local tabs = FlurioreLib:MakeGui({
    NameHub = "FLURIORE",
    Description = "BLACK / PINK",
    Color = Color3.fromRGB(255, 56, 164),
})

local tab = tabs:CreateTab({ Name = "Principal", Icon = "home" })
local section = tab:AddSection("General")
section:AddParagraph({ Title = "Hola", Content = "FlurioreLib usa el núcleo modular." })
section:AddButton({ Title = "Ejecutar", Icon = "sparkles", Callback = function() print("OK") end })
section:AddToggle({ Title = "Modo", Default = false, Callback = print })
section:AddSlider({ Title = "Velocidad", Min = 0, Max = 100, Increment = 5, Default = 50, Callback = print })
section:AddDropdown({ Title = "Selección", Options = { "Pink", "Rose" }, Default = { "Pink" }, Callback = print })

-- API compatible:
-- tabs:ToggleUI()
-- tabs:DestroyGui()
-- FlurioreLib:MakeNotify({ Title = "Saved", Content = "Settings saved", Delay = 3 })
```

El adaptador mantiene `MakeGui`, `CreateTab`, `AddSection`, `AddParagraph`, `AddButton`, `AddToggle`, `AddSlider`, `AddInput` y `AddDropdown`. Algunas implementaciones antiguas tenían comportamientos inconsistentes; el adaptador traduce sus configuraciones a controles modernos. Las funciones poco claras o dependientes de APIs de executor no se reproducen tal cual.

## Componentes

El núcleo incluye botones con variantes e iconos, toggles, checkbox, sliders, range sliders, dropdown y selección múltiple, campos de texto y numéricos, color picker, keybind, botones segmentados, labels, párrafos, divisores, tarjetas con controles anidados, progreso, imágenes, formularios, badges, indicadores de estado, tarjetas de métricas, listas clave/valor, tablas de datos, catálogo de objetos, árboles, carruseles, logs, diálogos, popups y notificaciones.

Los iconos aceptan nombres semánticos como `"heart"`, `"home"`, `"settings"`, `"search"`, `"sword"` o `"bell"`; IDs numéricos; cadenas `rbxassetid://...`; y los nombres antiguos definidos en `FlurioreLib.Icons`.

## Marca de agua

Se crea automáticamente al inicializar `FlurioreLib.new()` si `Watermark.Enabled` no es `false`. Admite `Title`, `LogoText`, `LogoImage`, `ShowLogo`, `ShowGameName`, `ShowGameIcon`, `ShowFPS`, `ShowClock`, `ShowStatus`, `Position` (`TopLeft`, `TopRight`, `BottomLeft`, `BottomRight`, `TopCenter`, `BottomCenter`) y `Style` (`Compact`, `Expanded`).

```lua
ui:SetWatermarkVisible(false)
ui:UpdateWatermark({ Title = "PROJECT ROSE", Style = "Expanded", ShowClock = true })
ui:SetStatus("READY")
```

## Estructura

- `FlurioreLib/Core`: framework, ciclo de vida y gestión de ventanas.
- `FlurioreLib/Components`: controles y componentes compuestos.
- `FlurioreLib/Services`: entorno de ejecución, entradas, temas, tweens y marca de agua.
- `FlurioreLib/Utilities`: iconos, validación, creación de instancias y limpieza.
- `FlurioreLib/Examples`: ejemplos modernos y adaptador compatible.
- `Documentation`: API, notas de compatibilidad, auditoría y pruebas.
- `build`: configuración de Darklua y script de compilación Unix.

## Ejemplos

- `Basic.client.lua`: ventanas, controles fundamentales, modal y composición.
- `Showcase.client.lua`: muestra amplia de la API.
- `Advanced.client.lua`: catálogo, datos, árbol, tabla y marca de agua.
- `VisualRefresh.client.lua`: estilo, iconos, estados y catálogo.
- `LegacyCompatibility.client.lua`: API compatible con `MakeGui` de la referencia antigua.

## Notas de verificación

Las rutas relativas de `require` y la estructura del paquete están preparadas para Darklua. El bundle final debe generarse localmente y probarse en Roblox Studio; la interfaz y sus interacciones no se han ejecutado en el motor desde este entorno de preparación. Consulta `Documentation/TESTING.md` antes de publicar.

## Referencia de la versión antigua

La carpeta `Reference/` conserva el archivo original proporcionado para que puedas comparar la API previa con el adaptador de compatibilidad. Este archivo es solo documental: Darklua compila desde `FlurioreLib/init.lua`, no incluye ni ejecuta el código histórico.
