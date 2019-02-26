FROM rustlang/rust:nightly
RUN rustup component add rust-src
RUN cargo install cargo-xbuild
RUN cargo install bootimage --version "^0.5.0"
RUN apt-get update && apt-get -y install qemu

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./x86_64-deko_os.json ./x86_64-deko_os.json
RUN mkdir -p ./src && echo '#![no_std]\n#![no_main]\n #[panic_handler]\npub fn panic(_info: &core::panic::PanicInfo) -> ! {loop{};}\n#[no_mangle]\n pub extern "C" fn  _start() {}' > ./src/main.rs && bootimage build


COPY ./ ./
RUN bootimage build
