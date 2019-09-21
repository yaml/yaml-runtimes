.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-perl5 -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-perl5 -f runtime.dockerfile .
