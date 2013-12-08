package Gth::Controller::Shorten;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Gth::Controller::Shorten - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Gth::Controller::Shorten in Shorten.');
}


=head1 AUTHOR

Hugh Hunter

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
