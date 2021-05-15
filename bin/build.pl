#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Data::Dumper;
use File::Path qw/ make_path /;
use Getopt::Long;
use Term::ANSIColor qw/ colored /;
use File::Basename qw/ dirname /;
use File::Glob ':bsd_glob';

use FindBin '$Bin';
use lib "$Bin/../local/lib/perl5";
use lib "$Bin/../lib";
use YAMLRuntimes;
use YAML::PP;

my $container_home = '/tmp/home';
my $var = "$Bin/../var";
my $cachedir = "$var/cache";
my $sourcedir = "$var/source";
my $prefix = 'yamlio';
my $dist = 'alpine';

GetOptions(
    'help|h' => \my $help,
);

if ($help) {
    usage();
    exit;
}


my ($task, $library, @args) = @ARGV;

my $yp = YAML::PP->new( schema => [qw/ JSON Merge /] );
my ($libs) = $yp->load_file("$Bin/../list.yaml");

my $yr = YAMLRuntimes->new(
    list => $libs,
    dist => $dist,
    prefix => $prefix,
);

my $libraries = $libs->{libraries};
my $runtimes = $libs->{runtimes};

if ($task eq 'list') {
    my $output = list_libraries();
    say $output;
}
elsif ($task eq 'update-readme') {
    my $output = list_libraries(markdown => 1);
    my $readme = "$Bin/../README.md";
    open my $fh, '<', $readme or die $!;
    my $lines = do { local $/; <$fh> };
    close $fh;
    $lines =~ s/^(\| ID).*\|\n\n/$output\n/sm;
    open $fh, '>', $readme or die $!;
    print $fh $lines;
    close $fh;
}
elsif ($task eq 'list-images') {
    list_images();
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
elsif ($task eq 'daemon-start') {
    my $runtime = $library;
    start_daemons($runtime);
}
elsif ($task eq 'daemon-stop') {
    my $runtime = $library;
    stop_daemons($runtime);
}
elsif ($task eq 'daemon-status') {
    status_daemons();
}
elsif ($task eq 'io') {
    my $dir = $library;
    run_io($dir, @args);
}

sub run_io {
    my ($dir, @views) = @_;
    my %running = YAMLRuntimes::get_containers();
    for my $view (@views) {
        my ($lib, $format) = split m/\./, $view;
        my $data = $libraries->{ $lib };
        my $runtime = $data->{runtime};
        my $program = "$lib-$format";
        my $cmd;
        my $args = qq{$program <$dir/input.yaml >$dir/$view 2>&1};
        if ($running{ "alpine-runtime-$runtime" }) {
            $cmd = qq{docker exec -i alpine-runtime-$runtime $args};
        }
        else {
            $cmd = qq{docker run --rm --user $< -i yamlio/alpine-runtime-$runtime $args};
        }
        say "$view";
        system $cmd;
    }
}

sub status_daemons {
    my %running = YAMLRuntimes::get_containers();
    unless (keys %running) {
        say "No daemons running";
        return;
    }
    say "Running:";
    say for sort keys %running;
}

sub start_daemons {
    my ($runtime) = @_;
    my %running = YAMLRuntimes::get_containers();
    my @runtimes;
    if ($runtime) {
        @runtimes = ($runtime);
    }
    else {
        @runtimes = map { $_->{runtime} } @$runtimes;
    }
    for my $runtime (@runtimes) {
        my $name = "$dist-runtime-$runtime";
        if ($running{ $name }) {
            say "$name already running";
        }
        else {
            my $cmd = sprintf q{docker run -d -it --user %d --name %s %s/%s},
                $<, $name, $prefix, $name;
            my $rc = system $cmd;
            if ($rc) {
                warn "Starting $runtime failed";
            }
        }
    }
}

sub stop_daemons {
    my ($runtime) = @_;
    my %running = YAMLRuntimes::get_containers();
    my @runtimes;
    if ($runtime) {
        @runtimes = ($runtime);
    }
    else {
        @runtimes = map { $_->{runtime} } @$runtimes;
    }
    for my $runtime (@runtimes) {
        my $name = "$dist-runtime-$runtime";
        if (not $running{ $name }) {
            say "$name not running";
        }
        else {
            say "Stopping $name";
            my $cmd = sprintf q{docker kill %s}, $name;
            my $rc = system $cmd;
            if ($rc) {
                warn "Killing $name failed";
            }
            $cmd = sprintf q{docker rm %s}, $name;
            $rc = system $cmd;
            if ($rc) {
                warn "Removing $name failed";
            }
        }
    }
}

sub list_libraries {
    my %args = @_;
    my $output = '';
    my $format = "| %-17s | %-10s | %-18s | %-8s | %-7s |\n";
    $output .= sprintf $format,
        qw/ ID Language Name Version Runtime /;
    $output .= sprintf $format, '-'x17, '-'x10, '-'x18, '-'x8, '-'x7;
    for my $id (sort keys %$libraries) {
        my $lib = $libraries->{ $id };
        my $name = $lib->{name};
        if ($args{markdown}) {
            $name = "[$name]($lib->{homepage})";
        }
        $output .= sprintf $format,
            $id, $lib->{lang}, $name, @$lib{qw/ version runtime /};
    }
    return $output;
}

sub list_images {
    make_path $cachedir;
    my $images = YAMLRuntimes::get_images("$prefix/$dist-runtime-*");
    my @image_fields = qw/ image tag id created size /;
    for my $item (@$runtimes) {
        my $runtime = $item->{runtime};
        my $name = "$dist-runtime-$runtime";
        my $image = "$prefix/$name";
        my $info = $images->{ $image };
        my $fmt_image = "%-29s:%-5s (%-12s) [%s] %6s";
        my $fmt = "%-20s %-10s %-7s | %-8s";
        if ($info) {
            say colored (['cyan bold'], sprintf $fmt_image, @$info{ @image_fields });
        }
        else {
            say colored (['cyan bold'], sprintf $fmt_image, $image, ('-') x 4);
            next;
        }

        my %installed = info_from_image($info->{id}, $info->{image});
        $info->{installed} = \%installed;

        my @libraries = keys %$libraries;
        $runtime ne 'all' and @libraries = grep {
            $info->{image} eq "$prefix/$dist-runtime-$libraries->{ $_ }->{runtime}"
        } @libraries;
        for my $name (sort { $a cmp $b } @libraries) {
            my $lib = $libraries->{ $name };
            my $installed = $info->{installed}->{ $name };
            say '  '
                . colored(['bold'], sprintf("%-17s ", $name))
                . sprintf $fmt,
                @$lib{qw/ name lang version /}, $installed->{VERSION} // '-';
        }
    }
    return;
}

sub info_from_image {
    my ($id, $image) = @_;
    my $infofile = "$cachedir/$id-info.yaml";
    my @docs;
    if (-e $infofile) {
        @docs = $yp->load_file($infofile);
    }
    else {
        my $cmd = "docker run -i --rm -v$Bin/../docker/global:/utils '$image' /utils/info.sh";
#        say "# $cmd";
        my $out = qx{$cmd};
        my $rc = $?;
        if ($rc) {
            warn "info.sh exited with $rc:\n$out";
            return;
        }
        @docs = $yp->load_string($out);
        $yp->dump_file($infofile, @docs);
    }
    my %installed;
    for my $doc (@docs) {
        next unless $doc;
        $installed{ $doc->{ID} } = $doc;
    }
    return %installed;
}

sub build {
    my ($library) = @_;
    say "Building $library";
    source($library);

    my $lib = $libraries->{ $library }
        or die "Library $library not found";
    my $buildscript = $lib->{'build-script'};
    unless ($buildscript) {
        warn "No build-script for $library";
    }
    my $name = $lib->{name}
        or die "No name for $library";
    my $version = $lib->{'version'}
        or die "No version for $library";
    my $runtime = $lib->{'runtime'}
        or die "No runtime for $library";
    my $build_image = "$dist-builder-" . ($lib->{'build-image'} || $runtime);

    my $builddir = "$var/build/$runtime";
    make_path $builddir;
    my @yaml_files = bsd_glob("$var/build/*/yaml/info/*.yaml");
    my %all_info;
    my %rt_info;
    for my $file (@yaml_files) {
        my $info = $yp->load_file($file);
        $all_info{ $info->{ID} } = $info;
        if ($file =~ m{/$runtime/}) {
            $rt_info{ $info->{ID} } = $info;
        }
    }
    if ($rt_info{ $library }) {
        my $info = $rt_info{ $library };

        if ($info->{VERSION} eq $version) {
            say "$library version $version is already installed";
            return;
        }
    }

    my $dir = "$Bin/../docker/$runtime";
    my $ok = 1;
    if ($buildscript) {
        my $source = $lib->{'source'}
            or die "No source for $library";
        my ($filename) = $source =~ m{.*/(.*)\z};
        my $build_dirs = $lib->{'build-dir'} || [];
        my @mounts = ("$dir/utils:/buildutils",  "$sourcedir/$runtime:/sources");
        for my $item (@$build_dirs) {
            my ($build_dir, $mount) = @$item;
            push @mounts, "$Bin/../$build_dir:$mount";
            make_path "$Bin/../$build_dir";
        }
        if (not @$build_dirs) {
            push @mounts, "$builddir:/build";
        }
        my $mount_options = join ' ', map { "-v$_" } @mounts;
        my $cmd = sprintf
            'docker run --rm --user %s'
            . ' --env HOME=%s --env VERSION=%s --env SOURCE=%s --env LIBNAME=%s '
            . $mount_options
            . " $prefix/%s /buildutils/%s",
            $<,
            $container_home, $version, "/sources/$filename", $library,
            $build_image, $buildscript;

        say "Building $library...";
        say "# $cmd";
        my $rc = system $cmd;
        $ok = $rc ? 0 : 1;
    }
    my $info_file = "$builddir/yaml/info/$library.yaml";
    make_path "$builddir/yaml/info";
    if ($ok) {
        say "ok, built $library $version";
        my $source = $lib->{source} // '';
        my $homepage = $lib->{homepage} // '-';
        my $lang = $lib->{lang} // '-';
        my $info = {
            ID => $library,
            NAME => $name,
            VERSION => $version,
            SOURCE => $source,
            HOMEPAGE => $homepage,
            LANG => $lang,
            TESTS => $lib->{tests} || [],
        };
        $yp->dump_file($info_file, $info);
        $rt_info{ $library } = $info;
        $all_info{ $library } = $info;

    }
    else {
        say "failed";
        unlink $info_file;
        delete $rt_info{ $library };
        delete $all_info{ $library };
    }
    my $rows = $yr->list_views(\%rt_info);
    my $csv = $yr->rows_to_csv($rows);
    my $csvfile = "$builddir/yaml/info/views.csv";
    open my $fh, '>', "$csvfile.$runtime" or die $!;
    print $fh $csv;
    close $fh;
    unlink $csvfile;
    symlink "views.csv.$runtime", $csvfile or die $!;

    {
        my $alldir = "$var/build/all";
        make_path "$alldir/yaml/info";
        my $rows = $yr->list_views(\%all_info);
        my $csv = $yr->rows_to_csv($rows);
        my $table = $yr->list_views_table($rows);
        my $csvfile = "$alldir/yaml/info/views.csv";
        open my $fh, '>', $csvfile or die $!;
        print $fh $csv;
        close $fh;
        my $tablefile = "$alldir/yaml/info/views.table";
        open $fh, '>', $tablefile or die $!;
        print $fh $table;
        close $fh;
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
    my $srcdir = "$sourcedir/$runtime";
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
