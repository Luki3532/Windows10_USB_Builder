================================================
Windows 10 USB Auto-Configuration Tool
================================================

PURPOSE:
This tool configures any standard Windows 10 installation USB for completely
automated (hands-free) installation with automatic partition cleanup.

================================================
QUICK START GUIDE
================================================

STEP 1: CREATE WINDOWS 10 INSTALLATION USB
-------------------------------------------
1. Download Windows 10 Media Creation Tool from Microsoft
   https://www.microsoft.com/software-download/windows10

2. Run Media Creation Tool and select:
   - "Create installation media (USB flash drive, DVD, or ISO file)"
   - Choose your language, edition, and architecture
   - Select "USB flash drive"
   - Choose your USB drive (minimum 8GB recommended)

3. Wait for Media Creation Tool to complete


STEP 2: CONFIGURE USB FOR HANDS-FREE INSTALLATION
-------------------------------------------------
1. Double-click: ConfigureWindowsUSB.bat

2. When prompted, enter your USB drive letter (e.g., E:)

3. Script will automatically:
   - Copy autounattend.xml to USB root
   - Copy cleanup scripts to \scripts folder
   - Verify all files are in place

4. When you see "CONFIGURATION COMPLETE!", your USB is ready


STEP 3: USE THE CONFIGURED USB
-------------------------------
1. Safely eject the USB drive

2. Boot target computer from USB
   - Insert USB into computer
   - Power on and press boot menu key (F12, F2, ESC, or DEL depending on manufacturer)
   - Select USB drive from boot menu

3. Installation proceeds automatically:
   - All existing partitions are wiped
   - New partitions are created
   - Windows 10 installs without prompts
   - System boots to desktop automatically

4. After installation:
   - Default username: Admin (no password)
   - You can change computer name manually
   - Configure Windows Update when connected to internet

================================================
WHAT THIS TOOL DOES
================================================

PARTITION CLEANUP:
- Uses DiskPart "clean" command to wipe all partitions
- Creates fresh GPT partition structure for UEFI systems
- Includes retry logic for stubborn/protected partitions
- Works offline (no internet required)

AUTOMATED INSTALLATION:
- Accepts EULA automatically
- Skips all OOBE (Out of Box Experience) prompts
- Creates local administrator account: "Admin" (no password)
- Disables Windows Update during installation
- Auto-logon enabled for first boot

WHAT IT DOESN'T DO:
- Driver installation (Windows uses default drivers)
- Software/application installation
- Network configuration (uses DHCP)
- Automatic computer naming (prompts for manual entry)

================================================
TROUBLESHOOTING
================================================

USB NOT RECOGNIZED AS WINDOWS 10 INSTALLATION:
- Ensure \sources\install.wim or \sources\install.esd exists
- Recreate USB using official Media Creation Tool
- Script will prompt to continue anyway if files are missing

PARTITION WIPE FAILS DURING INSTALLATION:
- Check log file: C:\Windows\Panther\setupact.log (after failed install)
- Disk may have hardware write protection
- Try removing disk in BIOS/UEFI settings before installation
- Some OEM systems require disabling Secure Boot temporarily

INSTALLATION HANGS OR PROMPTS FOR INPUT:
- Ensure autounattend.xml is at USB root (not in subfolder)
- USB must be inserted before powering on computer
- Verify BIOS/UEFI is set to boot from USB
- Try recreating USB and running script again

COMPUTER NAME NOT SET:
- This is intentional - computer name is left for manual configuration
- After installation, right-click "This PC" > Properties > Change settings

================================================
FILES IN THIS PACKAGE
================================================

ConfigureWindowsUSB.bat
    Main script - run this to configure any Windows 10 USB

templates\
    autounattend.xml
        Answer file with all automation settings
    
    scripts\
        DiskCleanup.cmd
            Enhanced partition cleanup with retry logic
        
        diskpart_clean.txt
            DiskPart commands for partition wipe

README.txt
    This file

================================================
REBUILDING A USB
================================================

If your USB fails or needs reconfiguration:

1. Format USB (optional - can reuse existing Windows 10 USB)
2. Recreate Windows 10 installation USB with Media Creation Tool
3. Run ConfigureWindowsUSB.bat again
4. Enter USB drive letter
5. USB is reconfigured and ready to use

================================================
SYSTEM REQUIREMENTS
================================================

USB DRIVE:
- Minimum 8GB (16GB recommended)
- USB 2.0 or higher
- FAT32 format (handled by Media Creation Tool)

TARGET COMPUTER:
- Windows 10 compatible hardware
- UEFI firmware (for GPT partition scheme)
- Minimum 20GB free disk space
- No internet connection required

HOST COMPUTER (for configuration):
- Windows 7 or later
- Administrator privileges

================================================
NOTES & WARNINGS
================================================

DATA LOSS WARNING:
This tool configures USB to automatically WIPE ALL PARTITIONS
on the target computer's disk 0 (first drive). ALL DATA WILL
BE PERMANENTLY DELETED. Use only on computers where data loss
is acceptable or data has been backed up.

OFFLINE INSTALLATION:
This configuration is optimized for offline use. Windows Update
is disabled during installation to prevent hangs waiting for
internet connection. Re-enable Windows Update after installation
when connected to internet.

UEFI vs LEGACY:
The partition scheme is configured for UEFI systems (GPT).
For Legacy BIOS systems, you may need to modify autounattend.xml
to use MBR partition scheme instead.

TIME ZONE:
Default time zone is "Pacific Standard Time". To change, edit
autounattend.xml and replace "Pacific Standard Time" with your
preferred time zone.

================================================
SUPPORT
================================================

For issues or questions:
1. Check setupact.log at C:\Windows\Panther\ on target computer
2. Review autounattend.xml for syntax errors
3. Ensure USB was created with official Microsoft Media Creation Tool
4. Test in virtual machine (Hyper-V, VirtualBox) before physical deployment

================================================
VERSION INFORMATION
================================================

Version: 1.0
Created: June 2026
Tested on: Windows 10 (all editions)
License: Free to use and modify

================================================
