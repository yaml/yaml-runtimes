RUNTIME :=
LIBRARY :=

DOTNET =  dotnet-yamldotnet
HASKELL = hs-hsyaml hs-reference
JAVA =    java-snakeyaml
LUA =     lua-lyaml
NIM =     nim-nimyaml
NODE =    js-jsyaml js-yaml
PERL =    perl-pp perl-pplibyaml perl-syck perl-tiny perl-xs perl-yaml
PYTHON =  py-pyyaml py-ruamel
RAKUDO =  raku-yamlish
RUBY =    ruby-psych
STATIC =  c-libfyaml c-libyaml cpp-yamlcpp

build: $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NIM) $(NODE) $(PERL) $(RAKUDO) $(PYTHON) $(RUBY) $(STATIC)

runtime-all:
	$(MAKE) -C docker runtime-all

dotnet:  $(DOTNET)
haskell: $(HASKELL)
java:    $(JAVA)
lua:     $(LUA)
nim:     $(NIM)
node:    $(NODE)
perl:    $(PERL)
python:  $(PYTHON)
rakudo:  $(RAKUDO)
ruby:    $(RUBY)
static:  $(STATIC)

COMMON = $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NODE) $(PERL) $(PYTHON) $(RAKUDO) $(STATIC)

$(DOTNET):  RUNTIME = dotnet
$(HASKELL): RUNTIME = haskell
$(JAVA):    RUNTIME = java
$(LUA):     RUNTIME = lua
$(NODE):    RUNTIME = node
$(PERL):    RUNTIME = perl
$(PYTHON):  RUNTIME = python
$(RAKUDO):  RUNTIME = rakudo
$(STATIC):  RUNTIME = static


.PRECIOUS: var/docker/builder-%.log
.PRECIOUS: var/docker/runtime-%.log

var/docker/builder-%.log: docker/%/alpine-builder.dockerfile
	mkdir -p var/docker
	docker build -t yamlio/alpine-builder-$* -f docker/$*/alpine-builder.dockerfile . | tee var/docker/builder-$*.log

var/docker/runtime-%.log: docker/%/alpine-runtime.dockerfile
	mkdir -p var/docker
	cd docker/$* && docker build -t yamlio/alpine-runtime-$* -f alpine-runtime.dockerfile . | tee ../../var/docker/runtime-$*.log

build-builder-%: var/docker/builder-%.log ;

build-library-%:
	perl bin/build.pl build $*

build-runtime-%: var/docker/runtime-%.log ;

$(COMMON):
	$(MAKE) build-builder-$(RUNTIME) build-library-$@ build-runtime-$(RUNTIME)

$(RUBY):
	$(MAKE) build-library-$@ build-runtime-ruby

$(NIM):
	$(MAKE) build-builder-nim build-library-$@ build-runtime-static

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
