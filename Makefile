
headless := true
packer_args := -force
output_directory := "output"

# Base images - Minimal installs
# ------------------------------

macos-10.12:
	time env packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		macos-10.12.json

ubuntu-16.04:
	time env packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		ubuntu-16.04.json

# Buildkite images - Base images with buildkite and build tools
# -------------------------------------------------------------

macos-buildkite-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(output_directory)/macos-10.12.vmx" \
		-var output_directory="$(output_directory)"
		macos-buildkite.json

ubuntu-buildkite-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(output_directory)/ubuntu-16.04.vmx" \
		-var output_directory="$(output_directory)"
		macos-buildkite.json

# Other images
# -------------------------------------------------------------

vmkite:
	PACKER_LOG=$(packer_log) packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(output_directory)/ubuntu-16.04.vmx" \
		-var output_directory="$(output_directory)/vmkite" \
		vmkite.json

clean:
	-rm -rf output/
	-rm -rf installers/
