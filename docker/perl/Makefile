.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-perl -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-perl -f alpine-runtime.dockerfile .
