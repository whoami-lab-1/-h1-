# Checklist de pruebas para FlurioreLib

Estas comprobaciones deben ejecutarse dentro de Roblox Studio; la revisión estática de archivos no sustituye el motor de Roblox.

## Compilación

- [ ] Ejecutar `build.bat` y comprobar que se crea `dist/FlurioreLib.lua`.
- [ ] Copiar el resultado a `ReplicatedStorage/FlurioreLib`.
- [ ] Ejecutar `Basic.client.lua` desde un LocalScript en `StarterPlayerScripts`.
- [ ] Ejecutar `Advanced.client.lua` y comprobar que el catálogo y los datos de muestra funcionan.
- [ ] Ejecutar `LegacyCompatibility.client.lua` para verificar `MakeGui`, `CreateTab`, `AddSection`, botones, toggle, slider, input y dropdown.

## Apariencia y navegación

- [ ] Comprobar la ventana en resoluciones grandes y pequeñas.
- [ ] Arrastrar, redimensionar, minimizar, maximizar, ocultar y restaurar la ventana.
- [ ] Cambiar entre pestañas con y sin icono.
- [ ] Abrir y cerrar una segunda ventana.
- [ ] Revisar esquinas, sombra, espaciado, texto largo, iconos semánticos y asset IDs.

## Controles y callback

- [ ] Confirmar que callbacks iniciales no se disparan inesperadamente al crear los controles.
- [ ] Cambiar Toggle, Slider, Dropdown y MultiSelect con ratón.
- [ ] Actualizar valores mediante `SetValue`/`Set` y verificar el parámetro de callback.
- [ ] Escribir texto y números válidos/invalidos.
- [ ] Probar keybind y selector de color.
- [ ] Buscar, filtrar, ordenar, cambiar grid/list y abrir detalles del catálogo.
- [ ] Probar diálogos, popups y notificaciones simultáneas.

## Ciclo de vida

- [ ] Destruir la UI y comprobar que no quedan ScreenGuis del framework ni ventanas de notificación.
- [ ] Crear la UI de nuevo con el mismo nombre y comprobar que no aparecen duplicados.
- [ ] Destruir controles dentro de listas y verificar que no quedan callbacks conectados.
- [ ] Llamar `FlurioreLib.CloseNotifications()` después de dejar una notificación persistente (`Delay = 0`).

## Entorno

- [ ] Verificar que se ejecuta desde `LocalScript`.
- [ ] Confirmar que la GUI se monta por defecto en `PlayerGui`.
- [ ] Probar entradas de ratón y táctiles en un dispositivo compatible.
