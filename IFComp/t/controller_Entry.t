use strict;
use warnings;
use Test::More;
use Path::Class;

unless ( eval q{use Test::WWW::Mechanize::Catalyst 0.55; 1} ) {
    plan skip_all => 'Test::WWW::Mechanize::Catalyst >= 0.55 required';
    exit 0;
}

use FindBin;
use lib ("$FindBin::Bin/lib");

use IFCompTest;
use IFComp::Model::IFCompDB;

my $schema = IFCompTest->init_schema();

IFComp::Schema->entry_directory(
    Path::Class::Dir->new("$FindBin::Bin/entries") );
ok( my $mech =
        Test::WWW::Mechanize::Catalyst->new( catalyst_app => 'IFComp' ),
    'Created mech object'
);

foreach ( $schema->entry_directory->children ) {
    $_->rmtree;
}

IFCompTest::log_in_as_author($mech);

$mech->get_ok('http://localhost/entry');
$mech->content_like( qr/You have not declared/,
    'At the entry-management page' );

my $comp_dir = $schema->entry_directory;

$mech->get_ok('http://localhost/entry/create');

is( $comp_dir->children, 0, "Entry directory ($comp_dir) is still empty." );

$mech->submit_form_ok(
    {   form_number => 2,
        fields      => { 'entry.title' => 'Fun Game', },
    },
    'Submitted a declaration'
);

my $entry = $schema->resultset('Entry')->find(1);
is( $entry->title, 'Fun Game', 'New entry is in the DB.' );

$mech->get_ok('http://localhost/entry/1/update');
$mech->submit_form_ok(
    {   form_number => 2,
        fields      => { 'entry.title' => 'Super-Fun Game', },
    },
);
$entry->discard_changes;
is( $entry->title, 'Super-Fun Game' );

is( $comp_dir->children, 1, "Entry directory contains 1 child." );
done_testing();

