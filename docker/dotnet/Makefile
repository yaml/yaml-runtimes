.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-dotnet -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-dotnet -f alpine-runtime.dockerfile .
