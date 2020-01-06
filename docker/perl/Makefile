.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-perl -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-perl -f alpine-runtime.dockerfile .
