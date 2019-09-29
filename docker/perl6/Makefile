.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-perl6 -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-perl6 -f runtime.dockerfile .
