# Compatibilidad con la FlurioreLib original

La referencia adjunta tenía una API de forma general `MakeGui -> CreateTab -> AddSection -> AddButton/AddToggle/AddSlider/AddInput/AddDropdown`, más `MakeNotify`. El adaptador mantiene esos nombres habituales y los conecta al núcleo modular actual.

## Mapeo

| API anterior | Núcleo nuevo |
| --- | --- |
| `MakeGui` | `Framework.new` + `CreateWindow` |
| `CreateTab` | `Window:AddTab` |
| `AddSection` | `Tab:AddSection` |
| `AddParagraph` | `Paragraph` con `Title` y `Text` |
| `AddButton` | `Button` con icono y callback |
| `AddToggle` | `Toggle` (`Default` -> `Value`) |
| `AddSlider` | `Slider` (`Increment` -> `Step`) |
| `AddInput` | `TextInput` o `NumericInput` |
| `AddDropdown` | `Dropdown` o `MultiSelect` (`Multi = true`) |
| `MakeNotify` | `Framework:Notify` |
| `ToggleUI` | `Window:SetVisible` |
| `DestroyGui` | `Framework:Destroy` |

En el dropdown de selección única, los callbacks del adaptador reciben una tabla de un elemento (o una tabla vacía), siguiendo la forma anterior. La API moderna devuelve el valor individual para la selección única.

## Problemas del código antiguo evitados

- `UserInputService.InputChanged` se conectaba globalmente durante cada arrastre/redimensionamiento y no se desconectaba al destruir la ventana.
- El código escribía en `CoreGui` sin adaptador de entorno o soporte explícito de `PlayerGui`.
- `ToggleUI` simulaba la pulsación de una tecla a través de `VirtualInputManager`; ahora cambia el estado de visibilidad directamente.
- Las notificaciones asumían que `CoreGui.NotifyGui` existía y usaban tareas de espera para autocerrarse, dificultando el ciclo de vida.
- Varias dimensiones y tamaños de texto se calculaban antes de completar el layout, y podían producir recortes en pantallas distintas.
- Los controles usaban nombres de métodos diferentes para operaciones equivalentes.

No se copian APIs específicas de executor ni su comportamiento de forma literal. La compatibilidad cubre la forma común de uso y mantiene la implementación actual modular.
