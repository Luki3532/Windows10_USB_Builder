@echo off
setlocal enabledelayedexpansion

:: Windows 10 USB Auto-Configuration Script
:: Configures any Windows 10 bootable USB for hands-free installation with automatic partition cleanup

echo ============================================
echo Windows 10 USB Auto-Configuration Tool
echo ============================================
echo.
echo This tool will configure a Windows 10 installation USB
echo for completely automated installation with partition wipe.
echo.

:: Get the script's directory
set "SCRIPT_DIR=%~dp0"
set "TEMPLATE_DIR=%SCRIPT_DIR%templates"

:: Check if templates folder exists
if not exist "%TEMPLATE_DIR%" (
    echo ERROR: Templates folder not found at: %TEMPLATE_DIR%
    echo Please ensure the templates folder is in the same directory as this script.
    pause
    exit /b 1
)

:: Prompt for USB drive letter
:GET_DRIVE
echo.
set /p USB_DRIVE="Enter the USB drive letter (e.g., E): "

:: Remove colon if user included it
set "USB_DRIVE=%USB_DRIVE::=%"

:: Add colon for validation
set "USB_PATH=%USB_DRIVE%:"

:: Check if drive exists
if not exist "%USB_PATH%\" (
    echo.
    echo ERROR: Drive %USB_PATH% does not exist.
    echo Please check the drive letter and try again.
    goto GET_DRIVE
)

:: Validate this is a Windows 10 installation USB
if not exist "%USB_PATH%\sources\install.wim" (
    if not exist "%USB_PATH%\sources\install.esd" (
        echo.
        echo ERROR: This does not appear to be a Windows 10 installation USB.
        echo Missing: \sources\install.wim or \sources\install.esd
        echo.
        set /p CONTINUE="Continue anyway? (Y/N): "
        if /i not "!CONTINUE!"=="Y" goto GET_DRIVE
    )
)

:: Ask user about partition style
echo.
echo ============================================
echo Partition Style Configuration
echo ============================================
echo.
echo Select partition style:
echo   - MBR: Legacy BIOS / CSM mode (older systems, max 2TB drives)
echo   - GPT: UEFI mode (modern systems, larger drives supported)
echo.
set /p PARTITION_STYLE="Use GPT partitions? (Y/N) [Default: N (MBR)]: "

:: Default to N (MBR) if user just presses Enter
if "!PARTITION_STYLE!"=="" set "PARTITION_STYLE=N"

if /i "!PARTITION_STYLE!"=="Y" (
    set "PART_TYPE=gpt"
    echo.
    echo Selected: GPT partition style (UEFI)
) else (
    set "PART_TYPE=mbr"
    echo.
    echo Selected: MBR partition style (Legacy BIOS)
)

:: Ask user about auto-creating admin account
echo.
echo ============================================
echo User Account Configuration
echo ============================================
echo.
echo Do you want to automatically create an admin account?
echo   - YES: Creates "Admin" account with no password and auto-login
echo   - NO:  You will be prompted to create an account after installation
echo.
set /p CREATE_USER="Auto-create admin account? (Y/N) [Default: N]: "

:: Default to N if user just presses Enter
if "!CREATE_USER!"=="" set "CREATE_USER=N"

:: Determine which template to use based on partition style and user account choice
if /i "!CREATE_USER!"=="Y" (
    set "XML_TEMPLATE=autounattend_!PART_TYPE!_with_user.xml"
    echo.
    echo Selected: Auto-create admin account
) else (
    set "XML_TEMPLATE=autounattend_!PART_TYPE!.xml"
    echo.
    echo Selected: Manual account setup after installation
)

echo.
echo Configuring USB drive %USB_PATH% for hands-free installation...
echo.

:: Copy autounattend.xml to USB root
echo [1/3] Copying autounattend.xml to USB root...
copy /Y "%TEMPLATE_DIR%\%XML_TEMPLATE%" "%USB_PATH%\autounattend.xml" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy %XML_TEMPLATE%
    pause
    exit /b 1
)
echo       SUCCESS

:: Create scripts folder if it doesn't exist
if not exist "%USB_PATH%\scripts" (
    mkdir "%USB_PATH%\scripts"
)

:: Copy cleanup scripts
echo [2/3] Copying cleanup scripts to \scripts folder...
copy /Y "%TEMPLATE_DIR%\scripts\DiskCleanup.cmd" "%USB_PATH%\scripts\DiskCleanup.cmd" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy DiskCleanup.cmd
    pause
    exit /b 1
)
copy /Y "%TEMPLATE_DIR%\scripts\diskpart_clean.txt" "%USB_PATH%\scripts\diskpart_clean.txt" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy diskpart_clean.txt
    pause
    exit /b 1
)
echo       SUCCESS

:: Verify files
echo [3/3] Verifying configuration...
set "ERROR_COUNT=0"

if not exist "%USB_PATH%\autounattend.xml" (
    echo       FAILED: autounattend.xml not found
    set /a ERROR_COUNT+=1
) else (
    echo       OK: autounattend.xml
)

if not exist "%USB_PATH%\scripts\DiskCleanup.cmd" (
    echo       FAILED: DiskCleanup.cmd not found
    set /a ERROR_COUNT+=1
) else (
    echo       OK: DiskCleanup.cmd
)

if not exist "%USB_PATH%\scripts\diskpart_clean.txt" (
    echo       FAILED: diskpart_clean.txt not found
    set /a ERROR_COUNT+=1
) else (
    echo       OK: diskpart_clean.txt
)

echo.
if %ERROR_COUNT% EQU 0 (
    echo ============================================
    echo CONFIGURATION COMPLETE!
    echo ============================================
    echo.
    echo USB drive %USB_PATH% is now configured for:
    echo   - Automatic partition cleanup and wipe
    if /i "!PARTITION_STYLE!"=="Y" (
        echo   - GPT partition style ^(UEFI mode^)
    ) else (
        echo   - MBR partition style ^(Legacy BIOS^)
    )
    echo   - Hands-free Windows 10 installation
    echo   - Offline installation ^(no internet required^)
    if /i "!CREATE_USER!"=="Y" (
        echo   - Auto-create Admin account ^(no password^)
    ) else (
        echo   - Manual user account creation required
    )
    echo.
    echo NEXT STEPS:
    echo 1. Safely eject the USB drive
    echo 2. Boot target computer from USB
    echo 3. Installation will proceed automatically
    if /i "!CREATE_USER!"=="Y" (
        echo 4. Computer will auto-login as Admin after install
    ) else (
        echo 4. You will be prompted to create a user account
        echo 5. Computer name will need manual entry after install
    )
    echo.
) else (
    echo ============================================
    echo CONFIGURATION FAILED
    echo ============================================
    echo %ERROR_COUNT% file(s) failed to copy. Please check permissions and try again.
    echo.
)

pause
