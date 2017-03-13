
ESXI_HOST ?= 10.92.157.11
ESXI_USERNAME ?= root

headless := true
packer_args := -force

macos-10.12:
	time packer build $(packer_args) \
		-var version=10.12.2 \
		-var headless=$(headless) \
		-var esxi_host='$(ESXI_HOST)' \
		-var esxi_username='$(ESXI_USERNAME)' \
		-var esxi_password='$(ESXI_PASSWORD)' \
		-var esxi_datastore='$(ESXI_DATASTORE)' \
		macos-10.12.json

ubuntu-16.04:
	time packer build $(packer_args) \
		-var headless=$(headless) \
		-var esxi_host='$(ESXI_HOST)' \
		-var esxi_username='$(ESXI_USERNAME)' \
		-var esxi_password='$(ESXI_PASSWORD)' \
		-var esxi_datastore='$(ESXI_DATASTORE)' \
		ubuntu-16.04-amd64.json

clean:
	-rm -rf output/
	-rm -rf installers/
