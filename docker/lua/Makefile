.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-lua -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-lua -f runtime.dockerfile .
