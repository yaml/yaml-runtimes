.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-lua -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-lua -f alpine-runtime.dockerfile .
