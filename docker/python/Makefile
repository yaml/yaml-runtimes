.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-python -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-python -f runtime.dockerfile .
