# Referencia original de FlurioreLib

`FlurioreLib-legacy-original.txt` conserva el código fuente que se proporcionó para la migración. Se incluye como referencia histórica y **no forma parte del bundle de Darklua**: el punto de entrada de compilación es `FlurioreLib/init.lua`.

El proyecto mantiene una capa de compatibilidad con los métodos más comunes del código antiguo (`MakeGui`, `CreateTab`, `AddSection`, `AddButton`, `AddToggle`, `AddSlider`, `AddInput`, `AddDropdown`, `MakeNotify`). Las implementaciones se apoyan en los servicios, controles y ciclo de vida del núcleo modular nuevo.
