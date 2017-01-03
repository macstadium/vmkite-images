
macos-10.12.2: installers/OSX_InstallESD_10.12.2_16C68.dmg
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.12.2_16C68.dmg \
		-var version=10.12.2 \
		macos.json

macos-10.11.3: installers/OSX_InstallESD_10.11.3_15D21.dmg
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.11.3_15D21.dmg \
		-var version=10.11.3 \
		macos.json

installers/OSX_InstallESD_10.11.3_15D21.dmg: /Applications/Install\ OS\ X\ El\ Capitan.app
	prepare_iso/prepare_iso.sh "/Applications/Install OS X El Capitan.app" installers

installers/OSX_InstallESD_10.12.2_16C68.dmg: /Applications/Install\ macOS\ Sierra.app
	prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers
