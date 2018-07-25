OSNAME = deko_os
TARGET=target/x86_64-deko_os/debug/bootimage-deko_os.bin

build:
	bootimage build

run:
	docker-compose run deko_os make -C /tmp/ build
	bootimage run -- \
        -drive format=raw,file=$(TARGET) \
        -device isa-debug-exit,iobase=0xf4,iosize=0x04 \
        -serial mon:stdio

integration-test:
	bootimage test

unit-test:
	cargo test

test:
	$(MAKE) integration-test
	$(MAKE) unit-test
