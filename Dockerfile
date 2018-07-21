FROM rustlang/rust:nightly
RUN rustup component add rust-src
RUN cargo install cargo-xbuild
RUN cargo install bootimage --version "^0.5.0"
