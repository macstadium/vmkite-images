
headless := true

macos-10.12:
	time packer build \
		-var iso_url=installers/OSX_InstallESD_10.12.3_16D32.dmg \
		-var iso_checksum=4b0d2b79ee351bcc28cff597d7a3c13c3ebf10fb0cf10133e53ff980a3920cc3 \
		-var version=10.12.2 \
		-var headless=$(headless) \
		macos-10.12.json

clean:
	-rm -rf output/
	-rm -rf installers/
