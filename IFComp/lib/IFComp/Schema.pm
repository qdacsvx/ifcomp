use utf8;
package IFComp::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-15 17:49:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ky9maeBYyy5mD//QSeUGBQ

use MooseX::ClassAttribute;

class_has 'email_template_basedir' => (
    is => 'rw',
    isa => 'Path::Class::Dir',
);

class_has 'entry_directory' => (
    is => 'rw',
    isa => 'Path::Class::Dir',
    default => sub { Path::Class::Dir->new( '', 'tmp', 'comp_entries' ) },
);

sub test_titles_for_oversimilarity {
    my $self = shift;
    my ( $proposed_title, $current_title ) = @_;

    my $proposed_dirname = $self->directory_name_from( $proposed_title );
    my $current_dirname = $current_title
                          ? $self->directory_name_from( $current_title )
                          : '';

    unless ( $proposed_dirname eq $current_dirname ) {
        for my $entry_dir ( $self->entry_directory->children ) {
            if ( $proposed_dirname eq $entry_dir->basename ) {
                die "Proposed dir $proposed_dirname matches existing dir $entry_dir.\n";
            }
        }
    }
}

sub directory_name_from {
    my $self = shift;
    my ( $name ) = @_;

    $name =~ s/\s+/_/g;
    $name =~ s/[^\w\d]//g;

    return $name;
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
