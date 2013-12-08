package Gth::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use Gth::ShortURL;

__PACKAGE__->config->{namespace} = '';

sub redirect :Path :Args(1) {
  my $self = shift;
  my $c    = shift;

  my $short_url = shift;
  my $shortener = Gth::ShortURL->new();
  my $long_url = $shortener->lengthen(
    $short_url,
    { log_visit => 1 }
  );

  if ($long_url) {
    $c->response->redirect($long_url, 301);
    $c->detach();
  } else {
    # could not find long_url
    $c->forward('index');
  }

}

sub index :Path :Args(0) {
  my $self = shift;
  my $c    = shift;

  $c->response->body("Home");
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
    
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Hugh Hunter

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
