.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-node -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-node -f alpine-runtime.dockerfile .
