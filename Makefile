RUNTIME :=
LIBRARY :=

DOTNET =  dotnet-yamldotnet
HASKELL = hs-hsyaml hs-reference
JAVA =    java-snakeyaml
LUA =     lua-lyaml
NIM =     nim-nimyaml
NODE =    js-jsyaml js-yaml
PERL =    perl-pp perl-pplibyaml perl-syck perl-tiny perl-xs perl-yaml perl-refparser
PYTHON =  py-pyyaml py-ruamel
RAKUDO =  raku-yamlish
RUBY =    ruby-psych
STATIC =  c-libfyaml c-libyaml cpp-yamlcpp go-yaml

build: $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NIM) $(NODE) $(PERL) $(RAKUDO) $(PYTHON) $(RUBY) $(STATIC)

runtime-all:
	docker build -t yamlio/alpine-runtime-all  -f docker/Dockerfile .

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

COMMON = $(DOTNET) $(HASKELL) $(JAVA) $(LUA) $(NODE) $(PERL) $(PYTHON) $(RAKUDO) $(RUBY) $(STATIC)

$(DOTNET):  RUNTIME = dotnet
$(HASKELL): RUNTIME = haskell
$(JAVA):    RUNTIME = java
$(LUA):     RUNTIME = lua
$(NIM):     RUNTIME = static
$(NODE):    RUNTIME = node
$(PERL):    RUNTIME = perl
$(PYTHON):  RUNTIME = python
$(RAKUDO):  RUNTIME = rakudo
$(RUBY):    RUNTIME = ruby
$(STATIC):  RUNTIME = static


.PRECIOUS: var/docker/builder-%.log
.PRECIOUS: var/docker/runtime-%.log

var/docker/builder-%.log: docker/%/alpine-builder.dockerfile
	mkdir -p var/docker
	docker build -t yamlio/alpine-builder-$* -f docker/$*/alpine-builder.dockerfile . | tee var/docker/builder-$*.log

var/docker/runtime-%.log: docker/%/alpine-runtime.dockerfile
	mkdir -p var/docker
	docker build -t yamlio/alpine-runtime-$* -f docker/$*/alpine-runtime.dockerfile . | tee var/docker/runtime-$*.log

build-builder-%: var/docker/builder-%.log ;

build-library-%:
	perl bin/build.pl build $*
	rm -f var/docker/runtime-$(RUNTIME).log

build-runtime-%: var/docker/runtime-%.log ;

$(COMMON):
	$(MAKE) build-builder-$(RUNTIME) build-library-$@ build-runtime-$(RUNTIME) RUNTIME=$(RUNTIME)

$(NIM):
	$(MAKE) build-builder-nim build-library-$@ build-runtime-static RUNTIME=$(RUNTIME)

list:
	perl bin/build.pl list
list-images:
	perl bin/build.pl list-images
list-views-%:
	@docker run -i --rm yamlio/alpine-runtime-$* cat /yaml/info/views.csv | cut -d, -f1 | tail -n +2
test:
	prove t/10.basic.t
testv:
	prove -v t/10.basic.t

docker-push-%:
	docker push yamlio/alpine-runtime-$*
docker-pull-%:
	docker pull yamlio/alpine-runtime-$*

README.md: list.yaml
	perl bin/build.pl update-readme

clean: clean-build clean-sources clean-cache

clean-build:
	rm -rf var/build/*

clean-sources:
	rm -rf var/source

clean-cache:
	rm -rf var/cache
	rm -rf var/docker

clean-runtime-%:
	rm -rf var/source/$*
	rm -rf docker/$*/build
