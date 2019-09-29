.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-haskell -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-haskell -f runtime.dockerfile .

