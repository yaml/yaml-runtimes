#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use YAML::PP;
use File::Path qw/ make_path /;
use Getopt::Long;
use FindBin '$Bin';

my $container_home = '/tmp/home';

GetOptions(
    'help|h' => \my $help,
);

if ($help) {
    usage();
    exit;
}


my ($task, $library) = @ARGV;

my $yp = YAML::PP->new( schema => [qw/ JSON Merge /] );
my ($libs) = $yp->load_file("$Bin/../list.yaml");

my $libraries = $libs->{libraries};
my $runtimes = $libs->{runtimes};

if ($task eq 'list') {
    my $format = '%-17s | %-10s | %-18s | %-5s';
        say sprintf $format,
            qw/ ID Language Name Version /;
    for my $id (sort keys %$libraries) {
        my $lib = $libraries->{ $id };
        say sprintf $format,
            $id, $lib->{lang}, $lib->{name}, $lib->{version};
    }
}
elsif ($task eq 'build') {
    if ($library) {
        my $lib = $libraries->{ $library }
            or die "Library $library not found";
        build($library);
    }
}
elsif ($task eq 'fetch-sources') {
    if ($library) {
        source($library);
    }
    else {
        for my $library (sort keys %$libraries) {
            source($library);
        }
    }
}

sub build {
    my ($library) = @_;
    say "Building $library";
    source($library);
    my $lib = $libraries->{ $library }
        or die "Library $library not found";
    my $buildscript = $lib->{'build-script'}
        or die "No build-script for $library";
    my $source = $lib->{'source'}
        or die "No source for $library";
    my ($filename) = $source =~ m{.*/(.*)\z};
    my $version = $lib->{'version'}
        or die "No version for $library";
    my $runtime = $lib->{'runtime'}
        or die "No runtime for $library";
    my $build_image = "builder-" . ($lib->{'build-image'} || $runtime);

    my $dir = "$Bin/../docker/$runtime";
    mkdir "$dir/build";

    my $cmd = sprintf
        'docker run -it --rm --user %s'
        . ' --env HOME=%s --env VERSION=%s --env SOURCE=%s --env LIBNAME=%s'
        . ' -v%s/build:/build -v%s/utils:/buildutils -v%s/sources:/sources'
        . ' yamlrun/%s /buildutils/%s',
        $<,
        $container_home, $version, "/sources/$filename", $library,
        ($dir) x 3,
        $build_image, $buildscript;

    warn __PACKAGE__.':'.__LINE__.": $cmd\n";
    {
        chdir "$Bin/../docker/$runtime";
        system $cmd;
    }
}

sub source {
    my ($library) = @_;
    say $library;
    my $lib = $libraries->{ $library }
        or die "Library $library not found";
    my $runtime = $lib->{runtime}
        or die "No runtime for $library";
    my $source = $lib->{source}
        or return;
    my ($filename) = $source =~ m{.*/(.*)\z};
    my $srcdir = "$Bin/../docker/$runtime/sources";
    make_path $srcdir;
    chdir $srcdir;
    if (-e $filename) {
        say "$filename exists, skip";
    }
    else {
        my $cmd = "wget --no-verbose --timestamping $source";
        say $cmd;
        system $cmd;
    }
}

sub usage {
    say <<"EOM";
Usage:
    $0 build
    $0 build c-libyaml
    $0 fetch-sources
    $0 fetch-sources c-libyaml
EOM
}
