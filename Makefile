
PERL5 = perl5-pp perl5-xs perl5-tiny
C = c-libfyaml c-libyaml

build: $(C) $(PERL5)

perl5: $(PERL5)
$(PERL5):
	make -C docker/perl5 builder
	perl bin/build.pl build $@
	make -C docker/perl5 runtime

c: $(C)
$(C):
	make -C docker/c builder
	perl bin/build.pl build $@
	make -C docker/c runtime

test:
	perl bin/build.pl test

clean:
	rm -rf docker/perl5/build
	rm -rf docker/c/build
