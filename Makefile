
headless := true
packer_args := -force
output_directory := output
source_path := false
xcode_cache_directory := /tmp/xcode_cache
xcode_version := 8.3.2
xcode_tar_file := $(xcode_cache_directory)/xcode-$(xcode_version).tar

validate:
	packer version
	packer validate -syntax-only macos-10.12.json
	packer validate -syntax-only ubuntu-16.04.json
	packer validate -syntax-only macos-buildkite-10.12.json
	packer validate -syntax-only ubuntu-buildkite-16.04.json
	packer validate -syntax-only vmkite.json

# Base images - Minimal installs
# ------------------------------

macos-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		macos-10.12.json

ubuntu-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		ubuntu-16.04.json

# Buildkite images - Base images with buildkite and build tools
# -------------------------------------------------------------

macos-buildkite-10.12: $(xcode_tar_file)
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		-var xcode_version="$(xcode_version)" \
		-var xcode_tar_file="$(xcode_tar_file)" \
		macos-buildkite-10.12.json

ubuntu-buildkite-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		ubuntu-buildkite-16.04.json

# Other images
# -------------------------------------------------------------

vmkite:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		vmkite.json

clean:
	-rm -rf output/
	-rm -rf installers/

# XCode versions
# -------------------------------------------------------------

$(xcode_tar_file):
	scripts/macos/support/install-xcode.sh "$(xcode_version)" "$(xcode_tar_file)"
