
PERL5 = perl5-pp perl5-xs perl5-tiny
C = c-libfyaml c-libyaml
NIM = nim-nimyaml
NODE = js-jsyaml js-yaml

build: $(C) $(PERL5) $(NIM) $(NODE)

perl5: $(PERL5)
c: $(C)
nim: $(NIM)
node: $(NODE)

$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/perl5 runtime

$(C):
	make -C docker/c builder
	perl bin/build.pl build $@
	make -C docker/c runtime

$(NIM):
	make -C docker/c builder-nim
	perl bin/build.pl build $@
	make -C docker/c runtime

$(NODE):
	make -C docker/node builder
	perl bin/build.pl build $@
	make -C docker/node runtime

test:
	perl bin/build.pl test

clean:
	rm -rf docker/perl5/build
	rm -rf docker/c/build
	rm -rf docker/node/build
