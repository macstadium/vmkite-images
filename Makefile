
headless := true
packer_args := -force
output_directory := "output"
source_path := false

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
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		macos-buildkite-10.12.json

ubuntu-buildkite-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		macos-buildkite-16.04.json

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
