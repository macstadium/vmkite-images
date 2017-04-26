
headless := true
packer_args := -force
packer_log := 0
output_directory := "output"

macos-base:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var iso_url=https://s3.amazonaws.com/vmkite-osx-images/OSX_InstallESD_10.12.3_16D32.dmg \
		-var iso_checksum=d5fd77df525e5e8acf0ed6df52cf39e3f608067124f496a35d07cf99009d03b8 \
		-var iso_checksum_type=sha256 \
		-var output_directory="$(output_directory)/macos-base" \
		-var version=10.12.3 \
		macos.json

ubuntu-base:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)/ubuntu-base" \
		ubuntu-16.04-amd64.json

vmkite:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)/vmkite" \
		vmkite.json

clean:
	-rm -rf output/
	-rm -rf installers/
