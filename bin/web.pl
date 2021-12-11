#!/usr/bin/env perl
use strict;
use warnings;
use Mojolicious::Lite -signatures;
use Time::HiRes qw/ sleep /;

my @views = (
    'c-libfyaml.event',
    'c-libfyaml.json',
    'c-libfyaml.yaml',
    'c-libyaml.event',
    'c-libyaml.yaml',
    'cpp-yamlcpp.event',
    'dotnet-yamldotnet.event',
    'dotnet-yamldotnet.json',
    'go-yaml.json',
    'hs-hsyaml.event',
    'hs-hsyaml.json',
    'hs-reference.yeast',
    'java-snakeyaml.event',
    'java-snakeyaml.json',
    'js-jsyaml.json',
    'js-yaml.event',
    'js-yaml.json',
    'js-yaml.yaml',
    'lua-lyaml.json',
    'nim-nimyaml.event',
    'perl-pp.event',
    'perl-pp.json',
    'perl-pp.perl',
    'perl-pp.yaml',
    'perl-pplibyaml.event',
    'perl-pplibyaml.json',
    'perl-pplibyaml.perl',
    'perl-pplibyaml.yaml',
    'perl-refparser.event',
    'perl-syck.json',
    'perl-syck.perl',
    'perl-tiny.json',
    'perl-tiny.perl',
    'perl-xs.json',
    'perl-xs.perl',
    'perl-yaml.json',
    'perl-yaml.perl',
    'py-pyyaml.event',
    'py-pyyaml.json',
    'py-pyyaml.py',
    'py-pyyaml.yaml',
    'py-ruamel.event',
    'py-ruamel.json',
    'py-ruamel.py',
    'py-ruamel.yaml',
    'raku-yamlish.json',
    'raku-yamlish.raku',
    'ruby-psych.json',
);
my %views;
@views{ @views } = ();

#get '/' => sub ($c) {
#    $c->render(template => 'index');
#};

any '/' => sub ($c) {
    my $in = $c->param('in.yaml');
    my $checked_views = $c->every_param('views');
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$checked_views], ['checked_views']);
    @views{ @views } = ();
    for my $check (@$checked_views) {
        $views{ $check } = 1 if exists $views{ $check };
    }
    my $list = [];
    my $shared = "$ENV{YAML_RUNTIMES_ROOT}/shared";
    chdir $shared;
    # Cleanup any leftover input/output files from previous runs
    system "rm *.*";

#   # Tell the daemons which views we want to have processed
    for my $v (grep { $views{ $_ } } @$checked_views) {
        system "touch $v.request";
    }
#   # Creating the input file will trigger the daemom
    open my $fh, ">:encoding(UTF-8)", 'input.yaml' or die $!;
    print $fh $in;
    close $fh;

#   # Wait until all views are processed and no *.view files are left
    for my $i (1 .. 40) {
        my @leftover = glob "*.request";
        my @seen = glob "*.view";
        if (not @leftover and not @seen) {
            last;
        }
        if (not @seen and @leftover and $i > 20) {
            warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\@leftover], ['leftover']);
            for my $l (@leftover) {
                system "echo 'View not available' >$l";
            }
            last;
        }
        sleep 0.1;
    }
#   # Get the results
    for my $v (grep { $views{ $_ } } @$checked_views) {
        if (-e $v) {
            warn __PACKAGE__.':'.__LINE__.": !!!!!!!!!!!!!!!!!!!!!!!!! $v\n";
            open my $fh, '<:encoding(UTF-8)', $v or die $!;
            local $/;
            my $out = <$fh>;
            close $fh;
            push @$list, { name => $v => out => $out };
            unlink $v;
        }
    }
#    warn __PACKAGE__.':'.__LINE__.$".Data::Dumper->Dump([\$list], ['list']);
#   # Cleanup any input/output files
    system "rm *.*";
# 


    $c->stash(input => $in);
    $c->stash(list => $list);
    $c->stash(views => \@views);
    $c->stash(checked_views => \%views);
    $c->render(template => 'test');
};

# WebSocket service used by the template to extract the title from a web site
#websocket '/title' => sub ($c) {
#    $c->on(message => sub ($c, $msg) {
#        my $title = $c->ua->get($msg)->result->dom->at('title')->text;
#        $c->send($title);
#    });
#};

app->start;
__DATA__
@@ index.html.ep
<html>
<head>
<title>Test</title>
</head>
<body>
index
</body></html>

@@ test.html.ep
<html>
<head>
<title>Test</title>
<link rel="stylesheet" type="text/css" href="yaml.css">
</head>
<body>
<table><tr>
<td>
<form action="/" method="post">
<textarea rows="10" cols="30" name="in.yaml"><%= $input %></textarea>
<input type="submit" value="Send!">
<br>
% for my $name (@$views) {
<input type="checkbox" name="views" value="<%= $name %>" <%= $checked_views->{ $name } ? 'checked="checked"' : '' %> >
<%= $name %><br>
% }
</form>
</td>
<td valign="top">
<div id="results">
    % for my $view (@$list) {
    <div class="item">
    <b><%= $view->{name} %></b>
    <div class="view">
    <div class="output"><pre><%= $view->{out} %></pre></div>
    </div>
    </div>
    % }
</div>
</tr></table>
</body></html>

@@ ws.html.ep
% my $url = url_for 'title';
<script>
  var ws = new WebSocket('<%= $url->to_abs %>');
  ws.onmessage = function (event) { document.body.innerHTML += event.data };
  ws.onopen    = function (event) { ws.send('https://mojolicious.org') };
</script>
@@ yaml.css
body {
    font-family: Verdana, Arial;
}
#results div.item {
  float: left;
  box-shadow: 2px 2px 4px 1px #ddd;
  background-color: white;
  margin: 0.3em;
}
#results div.last {
}
#results div.view {
  max-height: 10em;
  min-height: 10em;
  max-width: 12em;
  min-width: 12em;
  overflow-y: scroll;
  border: 1px solid grey;
}
#results div.output {
  padding: 0.0em 0.3em 0.0em 0.3em;
  /*
  max-height: 20em;
  overflow-y: scroll;
  */
}
