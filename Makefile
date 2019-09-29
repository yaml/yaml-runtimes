
HASKELL = hs-hsyaml hs-reference
PERL5 = perl5-pp perl5-pplibyaml perl5-syck perl5-tiny perl5-xs perl5-yaml
STATIC = c-libfyaml c-libyaml cpp-yamlcpp
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml
PYTHON = py-pyyaml py-ruamel
RUBY = ruby-psych

build: $(HASKELL) $(NIM) $(NODE) $(PERL5) $(PYTHON) $(RUBY) $(STATIC)

haskell: $(HASKELL)
perl5: $(PERL5)
static: $(STATIC)
nim: $(NIM)
node: $(NODE)
python: $(PYTHON)
ruby: $(RUBY)

$(HASKELL):
	make -C docker/haskell builder
	perl bin/build.pl build $@
	make -C docker/haskell runtime

$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/perl5 runtime

$(PYTHON):
	make -C docker/python builder
	perl bin/build.pl build $@
	make -C docker/python runtime

$(RUBY):
	make -C docker/ruby runtime

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
	rm -rf docker/haskell/build
	rm -rf docker/perl5/build
	rm -rf docker/python/build
	rm -rf docker/static/build
	rm -rf docker/node/build

clean-sources:
	rm -rf docker/haskell/sources
	rm -rf docker/perl5/sources
	rm -rf docker/python/sources
	rm -rf docker/static/sources
	rm -rf docker/node/sources
