.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-node -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-node -f alpine-runtime.dockerfile .
