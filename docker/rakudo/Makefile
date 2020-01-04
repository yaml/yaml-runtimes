.PHONY: builder runtime

builder:
	docker build -t yamlrun/builder-rakudo -f builder.dockerfile .

runtime:
	docker build -t yamlrun/runtime-rakudo -f runtime.dockerfile .
	rm -rf ./rakudo-runtime
	mkdir -p rakudo-runtime
	docker run -it --rm --user $$(id -u) -v$$(pwd)/rakudo-runtime:/rakudo-copy -v$$(pwd)/utils:/buildutils yamlrun/runtime-rakudo /buildutils/copy-rakudo.sh
