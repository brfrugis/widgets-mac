.PHONY: build clean run dmg

APP_NAME = World Clock
BUNDLE_NAME = WorldClock.app
BUILD_DIR = .build/release
DMG_NAME = WorldClock-Installer.dmg
DMG_DIR = dmg_temp

build:
	@echo "Building World Clock..."
	swift build -c release --arch arm64 --arch x86_64

run:
	@echo "Running World Clock..."
	swift run

clean:
	@echo "Cleaning build artifacts..."
	rm -rf .build
	rm -rf $(DMG_DIR)
	rm -f $(DMG_NAME)

bundle: build
	@echo "Creating macOS app bundle..."
	@mkdir -p "$(BUNDLE_NAME)/Contents/MacOS"
	@mkdir -p "$(BUNDLE_NAME)/Contents/Resources"
	@cp $(BUILD_DIR)/WorldClock "$(BUNDLE_NAME)/Contents/MacOS/"
	@cp Sources/WorldClock/Info.plist "$(BUNDLE_NAME)/Contents/"
	@echo "App bundle created: $(BUNDLE_NAME)"

dmg: bundle
	@echo "Creating DMG installer..."
	@mkdir -p $(DMG_DIR)
	@cp -r "$(BUNDLE_NAME)" "$(DMG_DIR)/"
	@ln -sf /Applications "$(DMG_DIR)/Applications"
	@hdiutil create -volname "$(APP_NAME)" -srcfolder $(DMG_DIR) -ov -format UDZO $(DMG_NAME)
	@rm -rf $(DMG_DIR)
	@echo "DMG created: $(DMG_NAME)"

install: bundle
	@echo "Installing to /Applications..."
	@rm -rf "/Applications/$(BUNDLE_NAME)"
	@cp -r "$(BUNDLE_NAME)" /Applications/
	@echo "Installed to /Applications/$(BUNDLE_NAME)"
