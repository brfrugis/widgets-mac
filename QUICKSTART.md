# Quick Start Guide

## Running the App Immediately

To test the app right away:

```bash
swift run
```

The app will launch with:
- A main window showing your selected timezones (starts with 4 default zones)
- A menu bar icon (clock icon) for quick access

## Building for Distribution

### Step 1: Build the Release Version

```bash
make build
```

Or manually:
```bash
swift build -c release
```

### Step 2: Create DMG Installer

```bash
make dmg
```

This creates `WorldClock-Installer.dmg` which users can:
1. Download
2. Double-click to open
3. Drag "World Clock" to Applications folder
4. Launch from Applications

## Using the App

### Desktop Widget
- **Always Visible**: The widget appears at the bottom-right of your screen
- **Stays on Desktop**: Visible across all spaces and applications
- **Drag to Move**: Click and drag anywhere to reposition
- **Hover for Controls**: Hover to show settings gear and quit button
- **Add Timezone**: Hover and click "+" or gear icon, then search for cities
- **Remove Timezone**: Hover over any clock card and click the trash icon
- **Search Brazil**: Type "Brazil" to see São Paulo, Manaus, Fortaleza, etc.

### Menu Bar
- Click the clock icon in your menu bar
- See all your timezones at a glance
- Quick access without opening the widget
- Click "Quit" to close the app

## Features

✅ Beautiful, clean interface
✅ Real-time clock updates
✅ Search from 400+ timezones worldwide
✅ Persistent timezone selections
✅ Menu bar quick access
✅ Native macOS design
✅ Compatible with macOS 13.0+

## Development Commands

```bash
# Run for testing
make run

# Build release
make build

# Create app bundle
make bundle

# Create DMG installer
make dmg

# Clean build artifacts
make clean

# Install to /Applications
sudo make install
```

## Troubleshooting

**App won't start?**
- Make sure you're on macOS 13.0 or later
- Try: `make clean && make run`

**Menu bar icon not showing?**
- Restart the app
- Check System Settings > Control Center

**Timezones not saving?**
- Check app has permission to write to ~/Library/Preferences

## Next Steps

For more details on building and distribution, see `BUILDING.md`.
