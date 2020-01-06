.PHONY: builder runtime

builder:
	docker build -t yamlio/alpine-builder-rakudo -f alpine-builder.dockerfile .

runtime:
	docker build -t yamlio/alpine-runtime-rakudo -f alpine-runtime.dockerfile .
	rm -rf ./rakudo-runtime
	mkdir -p rakudo-runtime
	docker run -it --rm --user $$(id -u) -v$$(pwd)/rakudo-runtime:/rakudo-copy -v$$(pwd)/utils:/buildutils yamlio/alpine-runtime-rakudo /buildutils/copy-rakudo.sh
