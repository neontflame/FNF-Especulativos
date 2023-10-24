@echo off
echo vamo q vamo
:start
lime test windows
set choice=
set /p choice="moar build? (Y/N): "
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='y' goto start