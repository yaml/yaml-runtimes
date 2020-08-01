package YAMLRuntimes;
use strict;
use warnings;
use 5.010;

sub new {
    my ($class, %args) = @_;
    my $list = $args{list};
    my $dist = $args{dist};
    my $self = bless {
        list => $list,
        dist => $dist,
    }, $class;
    return $self;
}

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
    my $cmd = qq,docker images --format "{{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}" "$pattern" | grep -v '<none>',;
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

sub list_views {
    my ($self, $all) = @_;
    my @rows;
    my @header = join ',', qw/ view format lang id name version homepage format-name /;
    for my $id (sort keys %$all) {
        my $info = $all->{ $id };
        my $tests = $info->{TESTS};
        for my $test (@$tests) {
            my $view = "$id.$test";
            my $format_name = $self->{list}->{formats}->{ $test } || '?';
            my @row = ($view, $test, @$info{qw/ LANG ID NAME VERSION HOMEPAGE /}, $format_name);
            push @rows, \@row;
        }
    }
    @rows = sort { $a->[0] cmp $b->[0] } @rows;
    unshift @rows, \@header;
    return \@rows;
}

sub rows_to_csv {
    my ($self, $rows) = @_;
    my $csv;
    for my $row (@$rows) {
        $csv .= join(',', @$row) . "\n";
    }
    return $csv;
}

sub list_views_table {
    my ($self, $rows) = @_;
    my $fmt = "| %2s | %-23s | %-23s | %-13s |\n";
    my $line = ('-' x 74) . "\n";
    my $table;
    $table .= sprintf $fmt, '#', 'View Name', 'YAML Processor', 'Output Format';
    $table .= $line;
    my $num = 1;
    for my $row (@$rows[1..$#$rows]) {
        my ($view, $format, $lang, $id, $name, $version, $homepage, $format_name) = @$row;
        my $processor = "$lang $name";
        $table .= sprintf $fmt, $num, $view, $processor, $format_name;
        $num++;
    }
    return $table;
}


1;
