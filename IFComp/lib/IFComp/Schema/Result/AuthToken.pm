use utf8;

package IFComp::Schema::Result::AuthToken;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IFComp::Schema::Result::AuthToken

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<auth_token>

=cut

__PACKAGE__->table("auth_token");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 token

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
    "id",
    {   data_type         => "integer",
        extra             => { unsigned => 1 },
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "user",
    {   data_type      => "integer",
        extra          => { unsigned => 1 },
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "token",
    { data_type => "varchar", is_nullable => 1, size => 64 },
    "updated",
    {   data_type                 => "timestamp",
        datetime_undef_if_invalid => 1,
        is_nullable               => 1,
    },
    "created",
    {   data_type                 => "datetime",
        datetime_undef_if_invalid => 1,
        is_nullable               => 1,
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<IFComp::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    "user",
    "IFComp::Schema::Result::User",
    { id => "user" },
    {   is_deferrable => 1,
        join_type     => "LEFT",
        on_delete     => "RESTRICT",
        on_update     => "RESTRICT",
    },
);

# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-26 21:48:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f8OfZrOIxQKK8OmUBVuk6Q

__PACKAGE__->meta->make_immutable;
1;
