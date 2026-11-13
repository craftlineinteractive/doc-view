# Findings & Key Technical Discoveries

## System & Toolchain
- **Flutter SDK**: `C:\flutter\bin\flutter.bat` (Dart: `C:\flutter\bin\dart.bat`).
- **Android Platform Tools**: `$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe`.
- **Target Device**: `emulator-5554` (API 36).
- **Environment Execution**: BypassSandbox required for Flutter, Dart, ADB, and Git commands in PowerShell.

## Design System & Architecture Constraints
- **Strict 4-Tool Contract**: Tools tab contains Image to PDF, Scan to PDF, Merge PDF, Split PDF only.
- **Palette**: Dark `#1A1D29`, `#232838`, `#141722`, `#2A3042`. Light `#FFFFFF`, `#F3F5FA`, `#E6E9F0`, `#F1F3F8`.
- **Ad Configuration**: `AdConfig.showPlaceholders` collapses all placeholder ad widgets in release builds to zero size without leftover gaps.

## Accessibility Requirements
- All touch targets $\ge 48\times 48\text{pt}$.
- Contrast ratios: $\ge 4.5:1$ normal text, $\ge 3:1$ large text/icons.
- Complete semantic labels for screen readers.
