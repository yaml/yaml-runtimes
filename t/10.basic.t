#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Test::More;
use Data::Dumper;
use FindBin '$Bin';
use lib "$Bin/../local/lib/perl5";
use lib "$Bin/../lib";
use YAMLRuntimes;
use YAML::PP;


my $prefix = 'yamlio';
my $dist = 'alpine';

my $yp = YAML::PP->new( schema => [qw/ JSON Merge /] );
my ($libs) = $yp->load_file("$Bin/../list.yaml");

my $libraries = $libs->{libraries};
my $runtimes = $libs->{runtimes};


my $container_home = '/tmp/home';
my $testlibrary = $ENV{LIBRARY};
my $testruntime = $ENV{RUNTIME};

my %running = YAMLRuntimes::get_containers();

my @tests;
if ($testlibrary and $libraries->{ $testlibrary }) {
    push @tests, $testlibrary;
}
elsif ($testruntime and $testruntime eq 'all') {
    for my $library (sort keys %$libraries) {
        push @tests, $library;
    }
}
elsif ($testruntime and grep { $_->{runtime} eq $testruntime } @$runtimes) {
    my $runtime = $testruntime;
    for my $library (sort keys %$libraries) {
        my $lib = $libraries->{ $library };
        next unless $lib->{runtime} eq $runtime;
        push @tests, $library;
    }
}
else {
    for my $library (sort keys %$libraries) {
        push @tests, $library;
    }
}
for my $library (@tests) {
    test($library);
}

sub test {
    my ($library) = @_;
    my $lib = $libraries->{ $library }
        or die "Library $library not found";
    my $runtime = $lib->{'runtime'}
        or die "No runtime for $library";
    $runtime = $testruntime if $testruntime;
    my $tests = $lib->{tests} || [];
    my $testdir = "t/data";
    chdir "$Bin/..";
    for my $type (@$tests) {
        my $input = 'input.yaml';
        my $output = "output.$type";
        if ($type eq 'event') {
            if ($library eq 'cpp-yamlcpp') {
                # yamlcpp does not have information about implicit
                # document start or end
                $output = 'output.event.yamlcpp';
            }
        }
        my $name = "$dist-runtime-$runtime";
        my $cmd = sprintf
          qq,docker run -i --rm --user %s $prefix/%s %s-%s <$testdir/%s >$testdir/%s.%s,,
            $<, $name, $library, $type, $input, $library, $type;
        if ($running{ $name }) {
            $cmd = sprintf
              qq,docker exec -i %s %s-%s <$testdir/%s >$testdir/%s.%s,,
                $name, $library, $type, $input, $library, $type;
        }
        note $cmd;
        system $cmd;
        my $rc = $?;
        is($rc, 0, "$library-$type executed successfully");
        if ($type eq 'json') {
            my $cmd = "jq . <$testdir/$library.$type >$testdir/$library.$type.jq && mv $testdir/$library.$type.jq $testdir/$library.$type";
            system $cmd;
            if ($?) {
                diag "jq command '$cmd' failed";
                ok(0, "jq failed");
                next;
            }
        }
        system "diff $testdir/$output $testdir/$library.$type";
        $rc = $?;
        unlink "$testdir/$library.$type";
#        if ($library eq '...') {
#            TODO: {
#                local $TODO = "... not yet working correctly";
#                is($rc, 0, "$library-$type output like expected");
#            }
#        }
#        else {
            is($rc, 0, "$library-$type output like expected");
#        }
    }
}

done_testing;
