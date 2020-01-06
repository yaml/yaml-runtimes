.PHONY: builder runtime

builder:
	docker build -t yamlrun/alpine-builder-dotnet -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlrun/alpine-runtime-dotnet -f alpine-runtime.dockerfile .
