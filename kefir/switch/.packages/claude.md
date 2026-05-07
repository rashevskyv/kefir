# Project Context: Kefir to Ultrahand Overlay Migration

## Overview
This document summarizes the ongoing effort to port the legacy Kefir system and utility scripts to the **Ultrahand Overlay** package format. This migration aims to move away from the older `config.ini` / `uberhand` interpreter and leverage the modern, high-performance features of Ultrahand.

## Core Goals
1.  **Migration**: Port all `switch/.packages/` scripts to the new Ultrahand syntax.
2.  **Optimization**: Replace static file swapping (copying `.ini` backups) with dynamic INI editing.
3.  **Enhanced UX**: Use native Ultrahand features like Toast Notifications, Hold-to-Confirm, and Metadata Headers.
4.  **Safety**: Implement hardware-aware guards and confirmation prompts for dangerous operations.

---

## Working Directories
- **Source (Legacy)**: `d:\git\dev\_kefir\kefir\switch\.packages\`
- **Target (Ported)**: `d:\git\dev\_kefir\kefir\switch\.packages\port\`
- **System Configs**: `/atmosphere/config/system_settings.ini`, `/bootloader/hekate_ipl.ini`, `/emummc/emummc.ini`.

---

## Technical Documentation & Syntax Rules

### 1. Basic Structure
- Every directory in `.packages/` represents a menu entry.
- The main script file is `config.ini` (or `package.ini`).
- **Headers**: Use `;title`, `;creator`, `;version`, `;color` (e.g., `green`, `#6600FF`) at the top of the file for a premium UI.

### 2. Command Syntax & Logic
- **Error Handling**: Use `try:` prefix for commands that might fail (e.g., `try: delete /path/`).
- **Toggles**: Use `;mode=toggle`. Logic is split into `on:` and `off:` blocks.
    - **Default State**: Use `;mode=toggle?on` or `;mode=toggle?off` to set initial state.
- **Safety**: Use `;hold=true` to require a ~3-second hold of the `A` button.
- **Notifications**: 
    - `notify-now 'Message'`: Immediate toast notification.
    - `notify 'Message'`: Queued notification.
- **Information/Subtitle**: Use `;footer=Some text` to show a subtitle under the menu entry.
- **Conditional Visibility**:
    - `;state=docked`: Show entry only when console is docked.
    - `;state=handheld`: Show entry only when in handheld mode.
    - Hardware Guards: `;system=mariko` or `;system=erista` (also supports `erista:` / `mariko:` prefixes for command blocks).

### 3. Hidden UI & Polling Properties
- `;polling=true`: Automatically refreshes the entry/table data periodically.
- `;mini=true`: Uses a more compact UI layout for the entry.
- `;background=false`: Disables the background box for tables or specific entries.
- `;gap=17`: Sets custom spacing after the entry.
- `;spacing=1`: Sets custom internal spacing (e.g., in tables).
- `;header_indent=true`: Adds visual indentation to headers for better hierarchy.
- `;unlocked=true`: Used for trackbars to allow values outside the defined steps.
- `;on_every_tick=true`: Runs the logic every frame (use with caution for performance).

### 4. Advanced Placeholder Variables
Beyond the basics, these variables can be used in commands:
- **System**: `{ams_version}`, `{hos_version}`, `{package_version}`, `{title_id}`, `{build_id}`, `{local_ip}`.
- **Hardware Info**: `{ram_vendor}`, `{ram_model}`, `{cpu_speedo}`, `{gpu_speedo}`, `{soc_speedo}`, `{cpu_iddq}`, `{gpu_iddq}`, `{soc_iddq}`.
- **Environment**: `{volume}` (0-150), `{backlight}` (0-255).
- **Functions**:
    - `{random(min,max)}`: Generates a random integer.
    - `{timestamp(format)}`: Returns current time (default format: `%Y-%m-%d %H:%M:%S`).
    - `{base64_decode(str)}`: Decodes base64 string.
    - `{ascii_to_hex(str)}`: Converts ASCII text to hex string.
    - `{hex_to_decimal(hex)}`: Converts hex to decimal.
    - `{decimal_to_hex(dec,order)}`: Converts decimal to hex (order: 0 for LE, 1 for BE).
    - `{hex_to_rhex(hex)}`: Reverses hex byte order.

### 5. File & System Operations (Undocumented)
- `set-footer 'text'`: Dynamically updates the entry's subtitle/footer from a script.
- `reboot UMS`: Reboots directly to Hekate USB Mass Storage mode.
- `reboot boot 'Entry'`: Reboots to a specific Hekate boot entry by name.
- `!path_exists /path/`: Executes only if the path does NOT exist.
- `compare /file1 /file2`: Internal file comparison.
- `flag /file`: Sets file flags (e.g., Archive bit).
- `logging on/off`: Toggles internal overlay logging.
- `download-no-retry URL PATH`: Single-attempt download.
- **Path Translation**: All legacy `/config/uberhand/packages/` paths have been updated to `/config/ultrahand/packages/` or `/config/ultrahand/downloads/`.

### 4. INI Manipulation (Dynamic Editing)
- `set-ini-val FILE SECTION KEY VALUE`
- `remove-ini-section FILE SECTION`
- `remove-ini-key FILE SECTION KEY`
- *Note*: Use these to modify system behavior without replacing the entire file.

---

## Key Implementations (Ported Features)

### 1. Dynamic Semi-Stock Mode
- **Legacy**: Swapped `hekate_ipl.ini` with `hekate_ipl_semi.ini` and replaced the entire `config.ini` with `emu.ini`.
- **New**: A single toggle in the root `config.ini`.
    - **ON**: Sets `enabled 0` in `emummc.ini`, `blank_prodinfo_sysmmc 0` in `exosphere.ini`, and `autoboot_list 0` in `hekate_ipl.ini`.
    - **OFF**: Reverts these values to `1`.
- **Benefit**: No need to maintain static backup files on the SD card.

### 2. 8GB DRAM Mode
- **Relocated**: Moved from deep nesting (`Advanced/ONLY FOR 8GB...`) to the main **Settings** menu.
- **Safety**: Protected by `;hold=true` and `;info=` warning text.
- **Auto-Uninstall**: The `off:` block now triggers the `Remove_8GB-RAM_config.te` script via TegraExplorer automatically.

### 3. Hold-to-Confirm
Applied to:
- Reboot / Shutdown
- DBI Config Reset
- Translation Removal
- Fan Control Reset
- 8GB DRAM Toggle

---

## Reference Patterns & Documentation

### [Ultra-Tuner](file:///d:/git/dev/Ultra-Tuner)
**Status**: Recommended Reference Repository
- **Instruction**: Use this project as the primary example for advanced implementations. It is powerful, works well, and utilizes a wide range of Ultrahand-Overlay's best features.
- **Key Patterns to Adopt**:
    - **Table Mode**: `;mode=table` for structured grid layouts.
    - **Forwarders**: `;mode=forwarder` with `package_source './path.ini'` to modularize complex menus.
    - **JSON Integration**: Heavy use of `json_file_source` for dynamic option lists.
    - **Hardware Guards**: Precise use of `;system=mariko` or `;system=erista` to show/hide entries based on console model.
    - **Advanced Formatting**: Efficient use of gaps, headers, and polling.

### [Ultrahand-Overlay Documentation](file:///d:/git/dev/Ultrahand-Overlay/README.md)
Refer to the official README for the complete list of commands, placeholders, and syntax rules.

## Current State for Claude
The porting of main scripts is 90% complete. We are currently polishing the UI and ensuring all dynamic edits are safe and robust. The next phase involves hardware verification and release preparation. Use Ultra-Tuner as the standard for any further porting or refactoring.
