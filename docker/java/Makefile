.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-java -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-java -f alpine-runtime.dockerfile .

