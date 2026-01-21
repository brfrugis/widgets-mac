#!/bin/bash

# Script to create a simple app icon using SF Symbols
# Creates a 1024x1024 globe icon

ICON_DIR="icon_temp"
ICONSET_DIR="AppIcon.iconset"

# Clean up any existing files
rm -rf "$ICON_DIR" "$ICONSET_DIR" AppIcon.icns

# Create directories
mkdir -p "$ICON_DIR"
mkdir -p "$ICONSET_DIR"

# Create a simple AppleScript to generate icon from SF Symbol
cat > "$ICON_DIR/create_icon.swift" << 'EOF'
import AppKit
import Foundation

let size: CGFloat = 1024
let image = NSImage(size: NSSize(width: size, height: size))

image.lockFocus()

// Background gradient (blue to light blue)
let gradient = NSGradient(colors: [
    NSColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0),
    NSColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0)
])
gradient?.draw(in: NSRect(x: 0, y: 0, width: size, height: size), angle: 270)

// Draw globe symbol
if let globeImage = NSImage(systemSymbolName: "globe.americas.fill", accessibilityDescription: nil) {
    let config = NSImage.SymbolConfiguration(pointSize: size * 0.6, weight: .regular)
    let configured = globeImage.withSymbolConfiguration(config)
    
    let imageRect = NSRect(x: size * 0.2, y: size * 0.2, width: size * 0.6, height: size * 0.6)
    
    // Draw white globe
    NSColor.white.set()
    configured?.draw(in: imageRect)
}

image.unlockFocus()

// Save as PNG
if let tiffData = image.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiffData),
   let pngData = bitmap.representation(using: .png, properties: [:]) {
    try? pngData.write(to: URL(fileURLWithPath: "icon_temp/icon_1024.png"))
}

print("Icon created successfully")
EOF

# Compile and run the Swift script
swift "$ICON_DIR/create_icon.swift"

# Check if icon was created
if [ ! -f "$ICON_DIR/icon_1024.png" ]; then
    echo "Error: Could not create icon"
    exit 1
fi

# Create all required icon sizes
sips -z 16 16     "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_16x16.png" > /dev/null 2>&1
sips -z 32 32     "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_16x16@2x.png" > /dev/null 2>&1
sips -z 32 32     "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_32x32.png" > /dev/null 2>&1
sips -z 64 64     "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_32x32@2x.png" > /dev/null 2>&1
sips -z 128 128   "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_128x128.png" > /dev/null 2>&1
sips -z 256 256   "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_128x128@2x.png" > /dev/null 2>&1
sips -z 256 256   "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_256x256.png" > /dev/null 2>&1
sips -z 512 512   "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_256x256@2x.png" > /dev/null 2>&1
sips -z 512 512   "$ICON_DIR/icon_1024.png" --out "$ICONSET_DIR/icon_512x512.png" > /dev/null 2>&1
cp "$ICON_DIR/icon_1024.png" "$ICONSET_DIR/icon_512x512@2x.png"

# Create .icns file
iconutil -c icns "$ICONSET_DIR" -o AppIcon.icns

# Clean up
rm -rf "$ICON_DIR" "$ICONSET_DIR"

echo "✅ AppIcon.icns created successfully!"
EOF

chmod +x create-icon.sh
