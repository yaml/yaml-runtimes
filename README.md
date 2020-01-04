# Docker images for YAML Runtimes

* [Usage](#Usage)
* [Build](#Build)
* [Test](#Test)
* [Play](#Play)
* [Example](#Example)
* [Architecture](#Architecture)
* [List of Libraries](#List-of-Libraries)

This repository provides Dockerfiles for several YAML processors. The goal is
to be able to compare the behaviour of the most common processors.

Providing runtime environments makes it easier to test and compare, and
eventually create bugreports.

This repo is built after the idea of the [YAML
Editor](https://github.com/yaml/yaml-editor). The difference to YAML Editor is
that the docker images are split up into several ones by language/type to create
smaller images and allow to only build or download the containers you need.

Each library has one or more programs to process YAML input and output parsing
events or JSON. In the docker images they can be found under the `/yaml`
directory.

There is also a `runtime-all` image which contains all processors (as long as
we can build all processors on Alpine Linux).

## Usage

Requirements:
* perl
* YAML::PP perl module
* jq

To install YAML::PP, first install the `cpanm` client (debian example):

    apt-get install cpanminus

Then install the module with `cpanm`:

    # Install YAML::PP into the local/ directory
    cpanm -l local --notest YAML::PP

The scripts will automatically use the `local/` directory to search for
modules. You could also do this manually by setting `PERL5LIB`:

    export PERL5LIB=$PWD/local/lib/perl5

To list all libraries:

    make list

### Build

To build all images, do

    make build

You can also just build a single environment or library:

    # build all javascript libraries
    make node
    # build C libyaml
    make c-libyaml
    # build perl5 YAML::PP
    make perl5-pp

To list all images, do

    make list-images

### Test

To see if the build was successful and all programs work, run

    make test
    # or verbose:
    make testv

This will test each program with a simple YAML file.

To test only one runtime or library:

    make test LIBRARY=c-libyaml
    make testv RUNTIME=perl5
    make testv RUNTIME=all LIBRARY=hs-hsyaml
    # Test all libraries in runtime-all image
    make testv RUNTIME=all

### Play

To play around with the several processors, call them like this:

    docker run -i --rm yamlrun/runtime-static c-libfyaml-event <t/data/input.yaml

### Example

If you want to test a certain library, for example `c-libfyaml`, the steps would
be:

    make c-libfyaml
    make list-images
    make testv LIBRARY=c-libfyaml
    docker run -i --rm yamlrun/runtime-static c-libfyaml-event <t/data/input.yaml
    docker run -i --rm yamlrun/runtime-static c-libfyaml-json <t/data/input.yaml


## Architecture

So far all docker images are based on Alpine Linux.

For each environment there is a builder image and a runtime image.
The libraries are built in the builder containers, and all necessary
files are then copied into the runtime images.

## List of Libraries

Currently only official releases of the libraries are build. Allowing to
build from sources like git might be added at some point.

The list of libraries and their configuration can be found in
[list.yaml](list.yaml).

Type `make list` to see the following list:

| ID                | Language   | Name               | Version  | Runtime |
| ----------------- | ---------- | ------------------ | -------- | ------- |
| c-libfyaml        | C          | [libfyaml](https://github.com/pantoniou/libfyaml) | 0.2      | static  |
| c-libyaml         | C          | [libyaml](https://github.com/yaml/libyaml) | 0.2.2    | static  |
| cpp-yamlcpp       | C++        | [yaml-cpp](https://github.com/jbeder/yaml-cpp) | 0.6.2    | static  |
| dotnet-yamldotnet | C#         | [YamlDotNet](https://github.com/aaubry/YamlDotNet) | 6.1.2    | dotnet  |
| hs-hsyaml         | Haskell    | [HsYAML](https://github.com/haskell-hvr/HsYAML) | 0.2      | haskell |
| hs-reference      | Haskell    | [YAMLReference](https://github.com/orenbenkiki/yamlreference) | master   | haskell |
| java-snakeyaml    | Java       | [SnakeYAML](https://bitbucket.org/asomov/snakeyaml) | 1.25     | java    |
| js-jsyaml         | Javascript | [js-yaml](https://github.com/nodeca/js-yaml) | 3.13.1   | node    |
| js-yaml           | Javascript | [yaml](https://github.com/eemeli/yaml) | 1.6.0    | node    |
| lua-lyaml         | Lua        | [lyaml](https://github.com/gvvaughan/lyaml) | 6.2.4-1  | lua     |
| nim-nimyaml       | Nim        | [NimYAML](https://github.com/flyx/NimYAML) | 0.12.0   | static  |
| perl5-pp          | Perl5      | [YAML::PP](https://metacpan.org/release/YAML-PP) | 0.018    | perl5   |
| perl5-pplibyaml   | Perl5      | [YAML::PP::LibYAML](https://metacpan.org/release/YAML-PP-LibYAML) | 0.003    | perl5   |
| perl5-syck        | Perl5      | [YAML::Syck](https://metacpan.org/release/YAML-Syck) | 1.31     | perl5   |
| perl5-tiny        | Perl5      | [YAML::Tiny](https://metacpan.org/release/YAML-Tiny) | 1.73     | perl5   |
| perl5-xs          | Perl5      | [YAML::XS (libyaml)](https://metacpan.org/release/YAML-LibYAML) | 0.80     | perl5   |
| perl5-yaml        | Perl5      | [YAML.pm](https://metacpan.org/release/YAML) | 1.29     | perl5   |
| py-pyyaml         | Python     | [PyYAML](https://github.com/yaml/pyyaml) | 5.2      | python  |
| py-ruamel         | Python     | [ruamel.yaml](https://bitbucket.org/ruamel/yaml) | 0.16.5   | python  |
| raku-yamlish      | Raku       | [YAMLish](https://github.com/Leont/yamlish) | 0.0.5    | rakudo  |
| ruby-psych        | Ruby       | [psych](https://github.com/ruby/psych) | builtin  | ruby    |


