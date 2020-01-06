.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-java -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-java -f alpine-runtime.dockerfile .

