.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-python -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-python -f alpine-runtime.dockerfile .
