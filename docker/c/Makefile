.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-c -f builder.dockerfile .

builder-nim:
	docker build -t yamlrun/builder-nim -f builder-nim.dockerfile .

runtime:
	docker build -t yamlrun/runtime-c -f runtime.dockerfile .

