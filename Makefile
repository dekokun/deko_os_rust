OSNAME = deko_os
TARGET=target/x86_64-deko_os/debug/bootimage-deko_os.bin
WORKDIR=/tmp
SOURCE_FILES = $(shell test -e src/ && find src -type f)
DOCKER_IMAGE_TAG = deko_os:latest

$(TARGET): $(SOURCE_FILES) Cargo.lock Cargo.toml x86_64-deko_os.json
	$(MAKE) build-image
	$(eval CID := $(shell docker create $(DOCKER_IMAGE_TAG)))
	docker cp $(CID):/target/x86_64-deko_os/debug/bootimage-deko_os.bin $(TARGET)

build-image:
	docker build . -t $(DOCKER_IMAGE_TAG)

build:
	$(MAKE) $(TARGET)

run:
	$(MAKE) $(TARGET)
	qemu-system-x86_64 \
     -drive format=raw,file=$(TARGET) \
     -device isa-debug-exit,iobase=0xf4,iosize=0x04 \
     -serial mon:stdio


integration-test:
	docker-compose run deko_os bash -c "cd $(WORKDIR); bootimage test"


unit-test:
	docker-compose run deko_os bash -c "cd $(WORKDIR); cargo test"

test:
	docker-compose build
	$(MAKE) integration-test
	$(MAKE) unit-test

local-build:
	bootimage build

local-run:
	$(MAKE) local-build
	qemu-system-x86_64 \
		-drive format=raw,file=/Users/dekokun/src/github.com/dekokun/deko_os_rust/target/x86_64-deko_os/debug/bootimage-deko_os.bin \
		-device isa-debug-exit,iobase=0xf4,iosize=0x04 \
		-serial mon:stdio

local-unit-test:
	cargo test

local-integration-test:
	bootimage test

local-test:
	$(MAKE) local-unit-test
	$(MAKE) local-integration-test
