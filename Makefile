
DOTNET = dotnet-yamldotnet
HASKELL = hs-hsyaml hs-reference
JAVA = java-snakeyaml
PERL5 = perl5-pp perl5-pplibyaml perl5-syck perl5-tiny perl5-xs perl5-yaml
PERL6 = perl6-yamlish
STATIC = c-libfyaml c-libyaml cpp-yamlcpp
LUA = lua-lyaml
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml
PYTHON = py-pyyaml py-ruamel
RUBY = ruby-psych

build: $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NIM) $(NODE) $(PERL5) $(PERL6) $(PYTHON) $(RUBY) $(STATIC)

dotnet: $(DOTNET)
haskell: $(HASKELL)
java: $(JAVA)
perl5: $(PERL5)
perl6: $(PERL6)
static: $(STATIC)
lua: $(LUA)
nim: $(NIM)
node: $(NODE)
python: $(PYTHON)
ruby: $(RUBY)

$(DOTNET):
	make -C docker/dotnet builder
	perl bin/build.pl build $@
	make -C docker/dotnet runtime

$(HASKELL):
	make -C docker/haskell builder
	perl bin/build.pl build $@
	make -C docker/haskell runtime

$(JAVA):
	make -C docker/java builder
	perl bin/build.pl build $@
	make -C docker/java runtime

$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/perl5 runtime

$(PERL6):
	make -C docker/perl6 builder
	perl bin/build.pl build $@
	make -C docker/perl6 runtime

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

$(LUA):
	make -C docker/lua builder
	perl bin/build.pl build $@
	make -C docker/lua runtime

$(NIM):
	make -C docker/static builder-nim
	perl bin/build.pl build $@
	make -C docker/static runtime

$(NODE):
	make -C docker/node builder
	perl bin/build.pl build $@
	make -C docker/node runtime

list:
	perl bin/build.pl list
test:
	perl bin/build.pl test

clean: clean-build clean-sources

clean-build:
	rm -rf docker/dotnet/build
	rm -rf docker/haskell/build
	rm -rf docker/java/build
	rm -rf docker/lua/build
	rm -rf docker/perl5/build
	rm -rf docker/perl6/build
	rm -rf docker/python/build
	rm -rf docker/static/build
	rm -rf docker/node/build

clean-sources:
	rm -rf docker/dotnet/sources
	rm -rf docker/haskell/sources
	rm -rf docker/java/sources
	rm -rf docker/lua/sources
	rm -rf docker/perl5/sources
	rm -rf docker/perl6/sources
	rm -rf docker/python/sources
	rm -rf docker/static/sources
	rm -rf docker/node/sources
