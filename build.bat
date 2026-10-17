@echo off
setlocal
cd /d "%~dp0"

set "DARKLUA_CMD="
where darklua >nul 2>nul
if not errorlevel 1 set "DARKLUA_CMD=darklua"
if not defined DARKLUA_CMD (
  where rokit >nul 2>nul
  if not errorlevel 1 set "DARKLUA_CMD=rokit run darklua"
)
if not defined DARKLUA_CMD (
  echo [ERROR] Darklua no esta instalado o no esta disponible en PATH.
  echo Instala Darklua: https://darklua.com/docs/getting-started/
  echo Si usas Rokit, instala el paquete seaofvoices/darklua y vuelve a ejecutar.
  exit /b 1
)

if not exist dist mkdir dist

echo.
echo [FlurioreLib] Compilando modulos con Darklua...
call %DARKLUA_CMD% process "FlurioreLib\init.lua" "dist\FlurioreLib.lua" --config "build\darklua.config.json"
if errorlevel 1 (
  echo.
  echo [ERROR] Darklua no pudo generar el bundle.
  exit /b 1
)

echo.
echo [OK] Archivo generado: dist\FlurioreLib.lua
echo Copia su contenido a un ModuleScript llamado FlurioreLib.
exit /b 0
