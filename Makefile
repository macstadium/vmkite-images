
installers: installers/OSX_InstallESD_10.11.3_15D21.dmg installers/OSX_InstallESD_10.12.1_16B2659.dmg

installers/OSX_InstallESD_10.11.3_15D21.dmg: "/Applications/Install OS X El Capitan.app"
	prepare_iso/prepare_iso.sh "/Applications/Install OS X El Capitan.app" installers

installers/OSX_InstallESD_10.12.1_16B2659.dmg: "/Applications/Install macOS Sierra.app"
	prepare_iso/prepare_iso.sh "/Applications/Install macOS Sierra.app" installers

# packer build \
#   -var iso_url=../out/OSX_InstallESD_10.8.4_12E55.dmg \
#   -var username=youruser \
#   -var password=yourpassword \
#   -var install_vagrant_keys=false \
#   template.json