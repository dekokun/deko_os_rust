OSNAME = deko_os
TARGET=target/x86_64-deko_os/debug/bootimage-deko_os.bin
WORKDIR=/tmp

build:
	docker-compose run deko_os bootimage build --manifest-path $(WORKDIR)/Cargo.toml

run:
	$(MAKE) build
	docker-compose run deko_os bootimage run -- -drive format=raw,file=$(TARGET) -device isa-debug-exit,iobase=0xf4,iosize=0x04 -serial mon:stdio --manifest-path $(WORKDIR)/Cargo.toml

integration-test:
	docker-compose run deko_os bootimage test --manifest-path $(WORKDIR)/Cargo.toml


unit-test:
	docker-compose run deko_os cargo test --manifest-path $(WORKDIR)/Cargo.toml

test:
	$(MAKE) integration-test
	$(MAKE) unit-test
