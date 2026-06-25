@echo off
:: Enhanced Disk Cleanup Script
:: This script provides aggressive partition cleanup with retry logic
:: Used as a backup to the autounattend.xml disk configuration

echo ================================================
echo Disk Cleanup Script - Enhanced Partition Wipe
echo ================================================
echo.

set "LOG_FILE=X:\Windows\Temp\disk_cleanup.log"

:: Create log directory if needed
if not exist "X:\Windows\Temp" mkdir "X:\Windows\Temp"

echo [%date% %time%] Disk cleanup started >> "%LOG_FILE%"

:: Method 1: Standard DiskPart Clean
echo [Method 1] Attempting standard diskpart clean...
echo [%date% %time%] Method 1: Standard clean >> "%LOG_FILE%"

diskpart /s X:\scripts\diskpart_clean.txt >> "%LOG_FILE%" 2>&1

if %errorlevel% EQU 0 (
    echo [Method 1] SUCCESS - Partitions wiped
    echo [%date% %time%] Method 1: SUCCESS >> "%LOG_FILE%"
    goto :VERIFY
) else (
    echo [Method 1] FAILED - Trying alternative method
    echo [%date% %time%] Method 1: FAILED with error %errorlevel% >> "%LOG_FILE%"
)

:: Method 2: DiskPart Clean All (secure wipe - slower but more thorough)
echo.
echo [Method 2] Attempting diskpart clean all (secure wipe)...
echo [%date% %time%] Method 2: Clean all >> "%LOG_FILE%"

echo select disk 0 > X:\Windows\Temp\diskpart_cleanall.txt
echo clean all >> X:\Windows\Temp\diskpart_cleanall.txt
echo exit >> X:\Windows\Temp\diskpart_cleanall.txt

diskpart /s X:\Windows\Temp\diskpart_cleanall.txt >> "%LOG_FILE%" 2>&1

if %errorlevel% EQU 0 (
    echo [Method 2] SUCCESS - Partitions securely wiped
    echo [%date% %time%] Method 2: SUCCESS >> "%LOG_FILE%"
    goto :VERIFY
) else (
    echo [Method 2] FAILED - Disk may be in use or protected
    echo [%date% %time%] Method 2: FAILED with error %errorlevel% >> "%LOG_FILE%"
)

:: Method 3: Fallback - List disk status for troubleshooting
echo.
echo [Method 3] Fallback - Listing disk information for troubleshooting...
echo [%date% %time%] Method 3: Listing disk info >> "%LOG_FILE%"

echo list disk > X:\Windows\Temp\diskpart_list.txt
echo exit >> X:\Windows\Temp\diskpart_list.txt

diskpart /s X:\Windows\Temp\diskpart_list.txt >> "%LOG_FILE%" 2>&1

echo.
echo WARNING: All cleanup methods failed. Check log: %LOG_FILE%
echo [%date% %time%] All methods FAILED >> "%LOG_FILE%"
pause
exit /b 1

:VERIFY
echo.
echo ================================================
echo Disk cleanup completed successfully
echo ================================================
echo [%date% %time%] Cleanup completed successfully >> "%LOG_FILE%"

:: Verify disk is clean
echo.
echo Verifying disk is clean...
echo list disk > X:\Windows\Temp\diskpart_verify.txt
echo select disk 0 >> X:\Windows\Temp\diskpart_verify.txt
echo detail disk >> X:\Windows\Temp\diskpart_verify.txt
echo exit >> X:\Windows\Temp\diskpart_verify.txt

diskpart /s X:\Windows\Temp\diskpart_verify.txt >> "%LOG_FILE%" 2>&1

echo Verification complete. Proceeding with installation...
echo [%date% %time%] Verification complete >> "%LOG_FILE%"

exit /b 0
