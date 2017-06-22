
headless := true
packer_args := -force
output_directory := output
source_path := false
cpus := $(shell expr $(shell sysctl -n hw.ncpu) / 2)
memory := $(shell expr $(shell sysctl hw.memsize | cut -f2 -d' ') / 4 / 1024 / 1024)

validate:
	packer version
	packer validate -syntax-only macos-10.12.json
	packer validate -syntax-only ubuntu-16.04.json
	packer validate -syntax-only macos-xcode-10.12.json
	packer validate -syntax-only macos-buildkite-10.12.json
	packer validate -syntax-only ubuntu-buildkite-16.04.json
	packer validate -syntax-only vmkite.json

clean:
	-rm -rf output/
	-rm -rf installers/

# macOS images
# -------------------------------------------------------------

macos-10.12:
	packer build $(packer_args) \
		-var headless=$(headless) \
		-var cpus="$(cpus)" \
		-var memory="$(memory)" \
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
		-var cpus="$(cpus)" \
		-var memory="$(memory)" \
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

# windows images
# -------------------------------------------------------------

windows-2016:
	PACKER_LOG=1 packer build $(packer_args) \
		-var headless=$(headless) \
		-var output_directory="$(output_directory)" \
		-var cpus="$(cpus)" \
		-var memory="$(memory)" \
		windows-2016.json
