.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-dotnet -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-dotnet -f runtime.dockerfile .
