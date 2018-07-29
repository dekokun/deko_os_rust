OSNAME = deko_os
TARGET=target/x86_64-deko_os/debug/bootimage-deko_os.bin
WORKDIR=/tmp

build:
	docker-compose run deko_os bash -c "cd $(WORKDIR); bootimage build"

run:
	$(MAKE) build
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

local-run:
	bootimage build
	qemu-system-x86_64 \
		-drive format=raw,file=/Users/dekokun/src/github.com/dekokun/deko_os_rust/target/x86_64-deko_os/debug/bootimage-deko_os.bin \
		-device isa-debug-exit,iobase=0xf4,iosize=0x04 \
		-serial mon:stdio
