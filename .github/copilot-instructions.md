# Windows 10 USB Builder - Copilot Instructions

## Project Overview
This project automates the configuration of Windows 10 installation USB drives for hands-free deployment with automatic partition cleanup and customizable options.

## Project Structure
```
Windows10_USB_Builder/
├── ConfigureWindowsUSB.bat          # Main configuration script
├── README.txt                        # User documentation
└── templates/
    ├── autounattend_mbr.xml         # MBR partition, manual user creation
    ├── autounattend_mbr_with_user.xml   # MBR partition, auto-create Admin
    ├── autounattend_gpt.xml         # GPT/UEFI partition, manual user creation
    ├── autounattend_gpt_with_user.xml   # GPT/UEFI partition, auto-create Admin
    └── scripts/
        ├── DiskCleanup.cmd          # Disk cleanup utility
        └── diskpart_clean.txt       # Diskpart script for partition wiping
```

## Key Technologies
- **Batch Scripts**: Windows CMD batch file scripting
- **XML Configuration**: Windows unattend.xml format for automated installation
- **Diskpart**: Windows disk partitioning utility

## Configuration Options

### Partition Styles
- **MBR (Default)**: Legacy BIOS/CSM mode, max 2TB drives
  - System Reserved Partition (500 MB, NTFS)
  - Windows Partition (remaining space, NTFS)
- **GPT**: UEFI mode, supports larger drives
  - EFI System Partition (100 MB, FAT32)
  - MSR Partition (128 MB, no format)
  - Windows Partition (remaining space, NTFS)

### User Account Options
- **Manual Creation (Default)**: User prompted during Windows setup
- **Auto-Create Admin**: Creates "Admin" account with no password and auto-login

## Template Naming Convention
Templates follow the pattern: `autounattend_{partition}_{usermode}.xml`
- `{partition}`: `mbr` or `gpt`
- `{usermode}`: omitted for manual creation, `with_user` for auto-creation

## Batch Script Behavior
1. Prompts for USB drive letter
2. Validates Windows 10 installation media
3. Asks for partition style (default: MBR)
4. Asks about user account creation (default: manual)
5. Copies appropriate template as `autounattend.xml`
6. Copies cleanup scripts to USB
7. Verifies configuration

## Coding Conventions

### Batch Files
- Use delayed expansion: `setlocal enabledelayedexpansion`
- Variable naming: UPPERCASE with underscores
- Always validate user input
- Provide clear error messages
- Use `/Y` for copy operations to suppress prompts

### XML Templates (autounattend.xml)
- Follow Microsoft's Windows System Image Manager schema
- Include comments for major sections
- Use `WillWipeDisk=true` for automatic partition cleanup
- Set `AcceptEula=true` to skip license prompt
- Namespace: `xmlns="urn:schemas-microsoft-com:unattend"`

### Important Settings
- **Offline Installation**: Windows Update disabled during setup
- **Partition Wipe**: Always enabled via `WillWipeDisk`
- **Locale**: en-US (hardcoded)
- **TimeZone**: Pacific Standard Time (hardcoded)
- **Edition**: Windows 10 Home (can be changed in templates)

## Default Behaviors
- **Partition Style**: MBR (user must explicitly choose GPT)
- **User Account**: Manual creation (user must explicitly enable auto-creation)
- **Empty Input**: Pressing Enter accepts defaults (N for both prompts)

## File Formats
- Batch files: Windows line endings (CRLF)
- XML files: UTF-8 encoding with BOM
- Template scripts: Windows line endings (CRLF)

## Testing Considerations
- Always test on actual hardware or VM
- Verify BIOS/UEFI mode matches partition style:
  - MBR requires Legacy BIOS/CSM mode
  - GPT requires UEFI mode
- Backup important data before testing (WillWipeDisk=true)

## Common Modifications
When modifying templates, common customizations include:
- Windows edition (change `/IMAGE/NAME` value)
- TimeZone (change `<TimeZone>` value)
- Locale/Language settings
- Partition sizes (change `<Size>` in CreatePartition)
- Computer name (currently uses `*` for random)
