build:
	cargo xbuild --target x86_64-deko_os.json

run:
	docker-compose run deko_os make -C /tmp/ build
