OSNAME = deko_os
TARGET=target/x86_64-deko_os/debug/bootimage-deko_os.bin

build:
	bootimage build

run:
	docker-compose run deko_os make -C /tmp/ build
	qemu-system-x86_64 \
        -drive format=raw,file=$(TARGET) \
        -serial mon:stdio

test:
	cargo test
