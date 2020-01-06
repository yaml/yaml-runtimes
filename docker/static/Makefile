.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-static -f alpine-builder.dockerfile .

builder-nim:
	docker build -t yamlrun/alpine-builder-nim -f alpine-builder-nim.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-static -f alpine-runtime.dockerfile .

