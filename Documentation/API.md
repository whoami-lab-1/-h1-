# API pública de FlurioreLib 3.0.0

## Crear el framework

`local ui = FlurioreLib.new(options)` devuelve la instancia del framework. También se admite `FlurioreLib:new(options)`.

Opciones clave: `Name`, `Parent`, `ResetOnSpawn`, `DisplayOrder`, `Animation`, `Debug`, `Theme` y `Watermark`.

## Ventanas

- `ui:CreateWindow(options)`
- `ui:GetWindow(id)` / `ui:GetWindows()`
- `ui:ShowWindow(id)` / `ui:HideWindow(id)` / `ui:DestroyWindow(id)`
- `window:AddTab(options)`
- `window:ShowTab(tabOrTitleOrId)`
- `window:Show()` / `Hide()` / `SetVisible(bool)` / `SetMinimized(bool)` / `SetMaximized(bool)` / `Destroy()`

Cada pestaña admite `tab:AddSection(options)`; cada sección admite `section:Add(kind, options)` y métodos como `AddButton`, `AddToggle`, `AddSlider`, `AddDropdown`, `AddItemCatalog`, etc.

## Componentes

El catálogo de tipos se obtiene con `ui:GetAvailableComponents()`. Los módulos disponibles incluyen Button, Checkbox, Toggle, Slider, Dropdown, MultiSelect, TextInput, NumericInput, Label, Paragraph, Divider, Card, Progress, Image, Keybind, Segmented, Collapsible, Form, Badge, StatusIndicator, MetricCard, KeyValueList, DataTable, ItemCatalog, RadioGroup, RangeSlider, TextArea, ColorPicker, EmptyState, LogViewer, TreeView y Carousel.

Los componentes interactivos normalmente exponen `GetValue`, `SetValue`, `SetEnabled`, `SetVisible` y `Destroy` según tenga sentido para su función.

## Notificaciones, modales y popups

- `ui:Notify({Title, Description, Type, Duration, Icon, Color})`
- `ui:CreateModal({Title, Description, ConfirmText, CancelText, OnConfirm, OnCancel})`
- `ui:CreatePopup({Title, ...})`

`Type` en notificaciones acepta `Default`, `Success`, `Error`, `Warning` e `Info`.

## Tema

- `ui:SetTheme(themeTable)`
- `ui:GetTheme()`

El tema predeterminado es negro/antracita con acentos rosa/fucsia. Componentes ya montados no necesariamente reconstruyen automáticamente todas sus propiedades después de un cambio de tema; aplica cambios de tema antes de crear componentes para obtener la misma paleta en toda la UI.

## Watermark

La marca de agua se crea automáticamente si no se desactiva mediante `Watermark = false` o `Watermark = {Enabled = false}`.

- `ui:SetWatermarkVisible(bool)`
- `ui:UpdateWatermark(options)`
- `ui:GetWatermark()`
- `ui:SetStatus(status)`

## API compatible

Consulta `LEGACY-COMPATIBILITY.md` para `FlurioreLib:MakeGui`, el adaptador de pestañas/secciones, los controles antiguos y `FlurioreLib:MakeNotify`.
