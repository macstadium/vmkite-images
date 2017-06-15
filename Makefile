
headless := true
packer_args := -force
output_directory := output
source_path := false

validate:
	packer version
	find . -name '*.json' -exec packer validate -syntax-only {} \;

clean:
	-rm -rf output/
	-rm -rf installers/

# macOS images
# -------------------------------------------------------------

macos-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		macos-10.12.json

macos-xcode-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		macos-xcode-10.12.json

macos-buildkite-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		macos-buildkite-10.12.json

# ubuntu images
# -------------------------------------------------------------

ubuntu-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		ubuntu-16.04.json

vmkite:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		vmkite.json

ubuntu-buildkite-16.04:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var source_path="$(source_path)" \
		-var output_directory="$(output_directory)" \
		ubuntu-buildkite-16.04.json
