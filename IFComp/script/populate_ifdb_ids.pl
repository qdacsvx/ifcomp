#!/usr/env perl

# This script does its best to update the IFDB ID field for every game in the
# current year's comp.

use warnings;
use strict;
use FindBin;
use Path::Class;
use LWP;
use Readonly;

use lib "$FindBin::Bin/../lib";
use IFComp::Schema;

Readonly my $PAUSE_BETWEEN_QUERIES => 1;

my $schema = IFComp::Schema->connect( 'dbi:mysql:ifcomp', 'root', '' );
$schema->entry_directory( Path::Class::Dir->new("$FindBin::Bin/../entries") );

my $current_comp = $schema->resultset('Comp')->current_comp;

my $ua = LWP::UserAgent->new;

for my $entry ( $current_comp->entries ) {

    next unless $entry->is_qualified;

    my $title = $entry->title;
    my $year  = $current_comp->year;

    my $query_string = "$title published:$year";
    $query_string =~ s/ /+/g;
    my $uri = "http://ifdb.tads.org/search?xml&game&searchfor=$query_string";

    print "$uri\n\n";

    my $response = $ua->get($uri);

    my ($ifdb_id) = $response->content
        =~ m{<tuid>([\w\d]+?)</tuid><title>\s*$title\s*</title>}i;
    if ($ifdb_id) {
        $entry->ifdb_id($ifdb_id);
        $entry->update;
        warn "$title has the IFDB $ifdb_id\n";
    }
    else {
        warn "WARNING: Couldn't find an IFDB ID for $title.\n";
    }

    sleep($PAUSE_BETWEEN_QUERIES);
}

