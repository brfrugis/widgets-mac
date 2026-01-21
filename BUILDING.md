# Building World Clock for macOS

This guide explains how to build and package the World Clock application for macOS.

## Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later
- Command Line Tools for Xcode
- Swift 5.9 or later

## Building the Application

### Option 1: Using Make (Recommended)

The simplest way to build the application:

```bash
# Build the release version
make build

# Run the app directly (for testing)
make run

# Create an app bundle
make bundle

# Create a DMG installer
make dmg

# Install to /Applications
sudo make install
```

### Option 2: Using Swift Package Manager

```bash
# Build release version
swift build -c release

# Run the app
swift run
```

### Option 3: Using Xcode

1. Generate Xcode project:
```bash
swift package generate-xcodeproj
```

2. Open `WorldClock.xcodeproj` in Xcode
3. Select the WorldClock scheme
4. Build and run (⌘R)

## Creating a DMG Installer

To create a distributable DMG file:

```bash
make dmg
```

This will:
1. Build the release version
2. Create an app bundle
3. Package it into a DMG file named `WorldClock-Installer.dmg`

Users can then:
1. Download the DMG
2. Open it
3. Drag the World Clock app to Applications
4. Launch from Applications

## Distribution Checklist

Before distributing the DMG:

- [ ] Test on a clean macOS installation
- [ ] Verify app launches correctly
- [ ] Test timezone selection
- [ ] Test menu bar integration
- [ ] Check that preferences persist after restart
- [ ] Sign the application (for wider distribution)
- [ ] Notarize with Apple (for Gatekeeper)

## Code Signing (Optional but Recommended)

For distribution outside the Mac App Store, you should sign your application:

```bash
# Sign the app bundle
codesign --deep --force --verify --verbose --sign "Developer ID Application: YOUR_NAME" WorldClock.app

# Verify the signature
codesign --verify --deep --verbose=2 WorldClock.app
spctl --assess --verbose=2 WorldClock.app
```

## Notarization (Optional but Recommended)

To avoid Gatekeeper warnings:

```bash
# Create a ZIP of the app
ditto -c -k --keepParent WorldClock.app WorldClock.zip

# Submit for notarization
xcrun notarytool submit WorldClock.zip --apple-id YOUR_APPLE_ID --team-id YOUR_TEAM_ID --password YOUR_APP_SPECIFIC_PASSWORD --wait

# Staple the notarization ticket
xcrun stapler staple WorldClock.app
```

## Troubleshooting

### Build Fails

- Ensure you have the latest Xcode and Command Line Tools
- Run `xcode-select --install` to install/update Command Line Tools
- Clean build: `make clean && make build`

### App Won't Launch

- Check Console.app for error messages
- Verify Info.plist is correctly formatted
- Ensure minimum system version matches your target

### DMG Creation Fails

- Ensure you have write permissions in the project directory
- Check that you have enough disk space
- Try `make clean` before `make dmg`

## Development Tips

### Hot Reload

During development, use:
```bash
make run
```

This compiles and runs quickly for testing.

### Debugging

Use Xcode for debugging:
```bash
swift package generate-xcodeproj
open WorldClock.xcodeproj
```

Then use Xcode's debugging tools (breakpoints, LLDB, etc.)

### Performance Profiling

Use Instruments to profile the app:
1. Build release version
2. Open Instruments
3. Select Time Profiler or other instruments
4. Profile the WorldClock binary
