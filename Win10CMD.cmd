@echo off
@cd /d "%~dp0"
Setlocal EnableDelayedExpansion

color 0a

title Restore "Open command prompt here" in Windows 10 Explorer Shell [Ivan_Alone]


Set /A line_length=80

Call :filled_line
Call :subempty_line
Echo * Restore "Open command prompt here" in Windows 10 Explorer Shell [Ivan_Alone] *
Call :subempty_line
Call :filled_line

Echo.


Echo Initialising TrustedInstaller enviroment...

Call :echo_on_line "Enviroment mode: x86"

If "%ProgramW6432%" Neq "" (
    Call :echo_on_line "-64"
    Set runas=bin\RunAsTI_x64.exe
) Else (
    Call :echo_on_line "-32"
    Set runas=bin\RunAsTI.exe
)
Echo.

If Exist "%runas%" (
    Echo Enviroment ready!
) Else (
    Echo [Error] TrustedInstaller enviroment not found, can't run Restoring Script
    Goto exit
)

Echo.


Echo Checking Administrator access level...

net session >Nul 2>&1

if %errorLevel% == 0 (
    Echo Ok! You have Administrator access!
) Else (
    Echo [Error] You doesn't have Administrator access level!
    Goto exit
)

Echo.


:select
    Call :draw_menu

    Set /P input="> "

    Echo.

    If "%input%" Neq "1" (
        If "%input%" Neq "2" (
            If "%input%" Neq "0" (
                Echo [Error] You selected not-existing menu item!
                Echo.
                Goto select
            ) Else (
                Echo Good bye!
                Goto exit
            )
        ) Else (
            Goto remove
        )
    ) Else (
        Goto install
    )

REM # Removing of "Open command prompt here" from explorer
:remove
    Echo Uninstalling components...

    %runas% REG ADD HKEY_CLASSES_ROOT\Directory\Background\shell\cmd /f /v HideBasedOnVelocityId /t REG_DWORD /d 0x00639bc8
    %runas% REG ADD HKEY_CLASSES_ROOT\Directory\shell\cmd /f /v HideBasedOnVelocityId /t REG_DWORD /d 0x00639bc8
    %runas% REG ADD HKEY_CLASSES_ROOT\Drive\shell\cmd /f /v HideBasedOnVelocityId /t REG_DWORD /d 0x00639bc8

    Goto done

REM # Adding "Open command prompt here" to explorer
:install
    Echo Installing components...

    %runas% REG DELETE HKEY_CLASSES_ROOT\Directory\Background\shell\cmd /f /v HideBasedOnVelocityId
    %runas% REG DELETE HKEY_CLASSES_ROOT\Directory\shell\cmd /f /v HideBasedOnVelocityId
    %runas% REG DELETE HKEY_CLASSES_ROOT\Drive\shell\cmd /f /v HideBasedOnVelocityId

    Goto done

:done
    Echo Done! 
    Goto exit

:exit 
    Echo.
    Pause
    Exit


REM # Functions

:draw_menu
    Echo Select option you want: 
    Echo     1 - Activate "Open command prompt here" in explorer 
    Echo     2 - Disable command promt in explorer 
    Echo.
    Echo     0 - Exit
    Echo.
Exit /B

:filled_line
    For /L %%i In (1,1,%line_length%) DO (
        Call :echo_on_line "*"
    )
    Echo.
Exit /B

:subempty_line
    Set a=*
    Set buf=0 0
    Set /A calc=%line_length% - 2
    For /L %%i In (1,1,%calc%) DO (
        Set a=!a!!buf:~1,1!
    )
    Set a=%a%*
    Echo %a%
Exit /B

:echo_on_line 
    <Nul Set /P _dev_null=%1
Exit /B