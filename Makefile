
build: installers/OSX_InstallESD_10.11.3_15D21.dmg
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.11.3_15D21.dmg \
		-var version=10.11.3 \
		macos.json

installers/OSX_InstallESD_10.11.3_15D21.dmg: /Applications/Install\ OS\ X\ El\ Capitan.app
	prepare_iso/prepare_iso.sh "/Applications/Install OS X El Capitan.app" installers

installers/OSX_InstallESD_10.12.1_16B2659.dmg: /Applications/Install\ macOS\ Sierra.app
	prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers
