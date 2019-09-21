.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-node -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-node -f runtime.dockerfile .
