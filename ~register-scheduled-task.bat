@echo off
echo administrative permissions required, detecting permissions...
echo.

net session >nul 2>&1
if %errorLevel% == 0 (
    echo success - administrative permissions confirmed
    echo.
) else (
    echo failure - current permissions inadequate

    pause

    exit
)

set scriptPath=%~dp0scripts\register-scheduled-task.ps1

echo "%scriptPath%"

pwsh -noprofile -executionpolicy bypass -file "%scriptPath%"

exit