
headless := true
packer_args := -force

macos-10.12:
	time packer build $(packer_args) \
		-var headless=$(headless) \
		macos-10.12.json

ubuntu-16.04:
	time packer build $(packer_args) \
		-var headless=$(headless) \
		ubuntu-16.04-amd64.json

clean:
	-rm -rf output/
	-rm -rf installers/
