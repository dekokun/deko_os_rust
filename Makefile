run:
	cargo rustc -- -Z pre-link-arg=-lSystem
	./target/debug/deko_os
