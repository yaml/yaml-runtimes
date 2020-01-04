.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-perl -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-perl -f runtime.dockerfile .
