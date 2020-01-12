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

sub get_images {
    my ($pattern) = @_;
    my $cmd = qq,docker images --format "{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}" "$pattern",;
    my @lines = qx{$cmd};
    my @image_fields = qw/ image tag id created size /;
    my %images;
    for my $line (@lines) {
        chomp $line;
        my %info;
        @info{ @image_fields } = split m/\t/, $line;
        $images{ $info{image} } = \%info;
    }
    return \%images;
}


1;
