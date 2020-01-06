.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-lua -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-lua -f alpine-runtime.dockerfile .
