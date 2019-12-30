#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Test::More;
use Data::Dumper;
use YAML::PP;
use FindBin '$Bin';

my $yp = YAML::PP->new( schema => [qw/ JSON Merge /] );
my ($libs) = $yp->load_file("$Bin/../list.yaml");

my $libraries = $libs->{libraries};
my $runtimes = $libs->{runtimes};


my $container_home = '/tmp/home';
my $testlibrary = $ENV{LIBRARY};
my $testruntime = $ENV{RUNTIME};

my @tests;
if ($testlibrary and $libraries->{ $testlibrary }) {
    push @tests, $testlibrary;
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
    for my $type (@$tests) {
        my $output;
        my $input;
        if ($type eq 'event') {
            $input = 'input.yaml';
            $output = 'output.event';
            if ($library eq 'cpp-yamlcpp') {
                # yamlcpp does not have information about implicit
                # document start or end
                $output = 'output.event.yamlcpp';
            }
        }
        elsif ($type eq 'json') {
            $input = 'input.yaml';
            $output = 'output.json';
        }
        elsif ($type eq 'yeast') {
            $input = 'input.yaml';
            $output = 'output.yeast';
        }
        my $cmd = sprintf
          'docker run -i --rm --user %s yamlrun/runtime-%s /yaml/bin/%s-%s <tests/%s >tests/%s.%s',
            $<, $runtime, $library, $type, $input, $library, $type;
        chdir "$Bin/..";
        note $cmd;
        system $cmd;
        my $rc = $?;
        is($rc, 0, "$library-$type executed successfully");
        if ($type eq 'json') {
            my $cmd = "jq . <tests/$library.$type >tests/$library.$type.jq && mv tests/$library.$type.jq tests/$library.$type";
            system $cmd;
            if ($?) {
                diag "jq command '$cmd' failed";
                ok(0, "jq failed");
                next;
            }
        }
        system "diff tests/$output tests/$library.$type";
        $rc = $?;
        unlink "tests/$library.$type";
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
