
DOTNET = dotnet-yamldotnet
HASKELL = hs-hsyaml hs-reference
JAVA = java-snakeyaml
PERL = perl-pp perl-pplibyaml perl-syck perl-tiny perl-xs perl-yaml
RAKUDO = raku-yamlish
STATIC = c-libfyaml c-libyaml cpp-yamlcpp
LUA = lua-lyaml
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml
PYTHON = py-pyyaml py-ruamel
RUBY = ruby-psych

RUNTIME :=
LIBRARY :=

build: $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NIM) $(NODE) $(PERL) $(RAKUDO) $(PYTHON) $(RUBY) $(STATIC)

runtime-all:
	$(MAKE) -C docker runtime-all

dotnet: $(DOTNET)
haskell: $(HASKELL)
java: $(JAVA)
perl: $(PERL)
rakudo: $(RAKUDO)
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

$(PERL):
	make -C docker/perl builder
	perl bin/build.pl build $@
	make -C docker/perl runtime

$(RAKUDO):
	make -C docker/rakudo builder
	perl bin/build.pl build $@
	make -C docker/rakudo runtime

$(PYTHON):
	make -C docker/python builder
	perl bin/build.pl build $@
	make -C docker/python runtime

$(RUBY):
	perl bin/build.pl build $@
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
list-images:
	perl bin/build.pl list-images
test:
	prove t/10.basic.t
testv:
	prove -v t/10.basic.t

README.md: list.yaml
	perl bin/build.pl update-readme

clean: clean-build clean-sources

clean-build:
	rm -rf docker/dotnet/build
	rm -rf docker/haskell/build
	rm -rf docker/java/build
	rm -rf docker/lua/build
	rm -rf docker/perl/build
	rm -rf docker/rakudo/build
	rm -rf docker/rakudo/rakudo-runtime
	rm -rf docker/python/build
	rm -rf docker/static/build
	rm -rf docker/node/build

clean-sources:
	rm -rf docker/dotnet/sources
	rm -rf docker/haskell/sources
	rm -rf docker/java/sources
	rm -rf docker/lua/sources
	rm -rf docker/perl/sources
	rm -rf docker/rakudo/sources
	rm -rf docker/python/sources
	rm -rf docker/static/sources
	rm -rf docker/node/sources
