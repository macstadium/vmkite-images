
headless := true

macos-10.12.2: installers/OSX_InstallESD_10.12.2_16C68.dmg
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.12.2_16C68.dmg \
		-var version=10.12.2 \
		-var packer_headless=$(headless) \
		macos.json

macos-10.12.1: installers/OSX_InstallESD_10.12.1_16B2659.dmg
	time PACKER_LOG=1 packer build \
		-var iso_url=installers/OSX_InstallESD_10.12.1_16B2659.dmg \
		-var version=10.12.1 \
		-var packer_headless=$(headless) \
		macos.json

macos-10.11.3: installers/OSX_InstallESD_10.11.3_15D21.dmg
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.11.3_15D21.dmg \
		-var version=10.11.3 \
		-var packer_headless=$(headless) \
		macos.json

installers/OSX_InstallESD_10.11.3_15D21.dmg: /Applications/Install\ OS\ X\ El\ Capitan.app
	mkdir -p installers/
	sudo SUDO_UID=$$UID SUDO_GID=$$GID \
		prepare_iso/prepare_iso.sh "/Applications/Install OS X El Capitan.app" installers

installers/OSX_InstallESD_10.12.1_16B2659.dmg: /Applications/Install\ macOS\ Sierra.app
	mkdir -p installers/
	sudo SUDO_UID=$$UID SUDO_GID=$$GID \
		prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers

installers/OSX_InstallESD_10.12.2_16C68.dmg: /Applications/Install\ macOS\ Sierra.app
	mkdir -p installers/
	sudo SUDO_UID=$$UID SUDO_GID=$$GID \
		prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers

clean:
	-rm -rf output/
	-rm -rf installers/
