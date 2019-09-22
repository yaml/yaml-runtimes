
PERL5 = perl5-pp perl5-xs perl5-tiny
STATIC = c-libfyaml c-libyaml cpp-yamlcpp
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml
PYTHON = py-pyyaml py-ruamel

build: $(STATIC) $(PERL5) $(NIM) $(NODE)

perl5: $(PERL5)
static: $(STATIC)
nim: $(NIM)
node: $(NODE)
python: $(PYTHON)

$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/PYTHON runtime

$(PYTHON):
	make -C docker/python builder
	perl bin/build.pl build $@
	make -C docker/python runtime

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
	rm -rf docker/python/build
	rm -rf docker/static/build
	rm -rf docker/node/build

clean-sources:
	rm -rf docker/perl5/sources
	rm -rf docker/python/sources
	rm -rf docker/static/sources
	rm -rf docker/node/sources
