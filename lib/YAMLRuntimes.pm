package YAMLRuntimes;
use strict;
use warnings;
use 5.010;

sub get_containers {
    my %running;
    my $cmd = q,docker ps -a --filter name=runtime- --format="{{.ID}}\t{{.Image}}\t{{.Names}}",;
    chomp(my @lines = qx{$cmd});
    for my $line (@lines) {
        my ($cid, $image, $name) = split m/\t/, $line;
        $running{ $name } = 1;
    }
    return %running;
}


1;
