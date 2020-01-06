.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-static -f alpine-builder.dockerfile .

builder-nim:
	docker build -t yamlio/alpine-builder-nim -f alpine-builder-nim.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-static -f alpine-runtime.dockerfile .

