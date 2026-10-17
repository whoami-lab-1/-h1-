# Compilación de un solo archivo con Darklua

FlurioreLib está organizado en módulos dentro de `FlurioreLib/`, pero el código fuente usa rutas de archivo en los `require`, igual que el flujo de build de WindUI. Darklua sigue esas rutas y empaqueta los módulos referenciados desde `FlurioreLib/init.lua` en un único archivo.

## Compilar en Windows

1. Instala Rokit, ejecuta `rokit add seaofvoices/darklua` en la carpeta del proyecto, o instala el binario de Darklua y asegúrate de que esté en el `PATH`. La versión de la herramienta está fijada en `rokit.toml` (0.19.0).
2. Ejecuta `build.bat`.
3. El resultado estará en `dist/FlurioreLib.lua`.
4. Copia el contenido de ese archivo a un `ModuleScript` llamado `FlurioreLib` y úsalo con `require(...)`.

## Compilar en Linux/macOS

Ejecuta `bash build/build.sh` desde la carpeta del proyecto.

## Cómo funciona

- No existe una etapa de reescritura de `require` ni una copia temporal preparada por Python.
- Los módulos fuente usan imports relativos como `require("./Core/Framework")` y `require("../Utilities/Cleanup")`.
- `build/darklua.config.json` declara `bundle.require_mode = "path"`.
- El script ejecuta directamente `darklua process FlurioreLib/init.lua dist/FlurioreLib.lua --config build/darklua.config.json`.
- Edita los módulos en `FlurioreLib/`; no edites `dist/FlurioreLib.lua` a mano porque se vuelve a generar.

## Nota sobre Roblox Studio

Los `require("./ruta")` relativos son entradas del proceso de compilación, no requieren módulos desde Roblox en tiempo de ejecución. El archivo que debes usar dentro de Roblox es el bundle generado `dist/FlurioreLib.lua`. El código fuente está organizado para desarrollo y empaquetado, siguiendo el modelo de bibliotecas como WindUI.

La compilación no se pudo ejecutar automáticamente en este entorno porque el binario de Darklua no está instalado aquí. El paquete incluye la configuración y los comandos de build para ejecutarla localmente.
