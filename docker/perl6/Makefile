.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-perl6 -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-perl6 -f runtime.dockerfile .
	rm -rf ./rakudo-runtime
	mkdir -p rakudo-runtime
	docker run -it --rm --user $$(id -u) -v$(PWD)/rakudo-runtime:/rakudo-copy -v$(PWD)/utils:/buildutils yamlrun/runtime-perl6 /buildutils/copy-rakudo.sh
