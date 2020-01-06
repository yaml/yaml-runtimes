.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-python -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-python -f alpine-runtime.dockerfile .
