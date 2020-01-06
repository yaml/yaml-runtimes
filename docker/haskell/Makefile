.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-haskell -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-haskell -f alpine-runtime.dockerfile .

