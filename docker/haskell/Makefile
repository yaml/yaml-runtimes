.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-haskell -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-haskell -f alpine-runtime.dockerfile .

