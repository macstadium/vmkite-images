
headless := true
packer_args := -force
packer_log := 1

macos-10.12:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var iso_url=https://s3.amazonaws.com/vmkite-osx-images/OSX_InstallESD_10.12.3_16D32.dmg \
		-var iso_checksum=d5fd77df525e5e8acf0ed6df52cf39e3f608067124f496a35d07cf99009d03b8 \
		-var iso_checksum_type=sha256 \
		-var version=10.12.3 \
		macos.json

macos-10.11:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var iso_url=https://s3.amazonaws.com/vmkite-osx-images/OSX_InstallESD_10.11.6_15G31.dmg \
		-var iso_checksum=910bb3072e643d137994105fd4856e17853b825b390a0d74b168cc640e5208a0 \
		-var iso_checksum_type=sha256 \
		-var version=10.11.6 \
		macos.json

macos-10.10:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var iso_url=https://s3.amazonaws.com/vmkite-osx-images/OSX_InstallESD_10.10.5_14F27.dmg \
		-var iso_checksum=afd272bd328915720dd694df99bfa720c0e4a610a5c24bd1de69e2e7bd69c048 \
		-var iso_checksum_type=sha256 \
		-var version=10.10.5 \
		macos.json

ubuntu-16.04:
	time env PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		ubuntu-16.04-amd64.json

clean:
	-rm -rf output/
	-rm -rf installers/
