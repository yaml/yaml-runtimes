
PERL5 = perl5-pp perl5-xs perl5-tiny
STATIC = c-libfyaml c-libyaml
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml

build: $(STATIC) $(PERL5) $(NIM) $(NODE)

perl5: $(PERL5)
static: $(STATIC)
nim: $(NIM)
node: $(NODE)

$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/perl5 runtime

$(STATIC):
	make -C docker/static builder
	perl bin/build.pl build $@
	make -C docker/static runtime

$(NIM):
	make -C docker/static builder-nim
	perl bin/build.pl build $@
	make -C docker/static runtime

$(NODE):
	make -C docker/node builder
	perl bin/build.pl build $@
	make -C docker/node runtime

test:
	perl bin/build.pl test

clean: clean-build clean-sources

clean-build:
	rm -rf docker/perl5/build
	rm -rf docker/c/build
	rm -rf docker/node/build

clean-sources:
	rm -rf docker/perl5/sources
	rm -rf docker/c/sources
	rm -rf docker/node/sources
