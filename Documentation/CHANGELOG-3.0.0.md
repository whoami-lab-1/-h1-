# FlurioreLib 3.0.0

## Identidad visual

- Tema predeterminado negro/antracita con rosa y fucsia.
- Marca de agua y nombres de ventana predeterminados con identidad Fluriore.
- Los ejemplos ahora cargan el ModuleScript `FlurioreLib` y demuestran el esquema rosa/negro.

## Proyecto

- Se conserva el núcleo modular: ventanas, pestañas, secciones, componentes, temas, entradas, tweens y limpieza.
- Se añadió una API compatible con las llamadas habituales de la referencia antigua: `MakeGui`, `CreateTab`, `AddSection` y los controles más comunes.
- `MakeNotify` se conecta al sistema de notificaciones actual y administra el host temporal.
- Darklua compila directamente `FlurioreLib/init.lua` a `dist/FlurioreLib.lua`.
- Se agregaron documentación de mapeo y un ejemplo de migración.

## Validación pendiente

Este paquete no fue ejecutado dentro del motor Roblox Studio desde el entorno de preparación. Ejecuta `build.bat`, prueba ambos ejemplos (moderno y compatible) y recorre `Documentation/TESTING.md` antes de publicarlo.
