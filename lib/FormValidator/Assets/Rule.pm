package FormValidator::Assets::Rule;
use Moose;

extends 'FormValidator::Assets::Component';

use overload q{""} => sub { shift->rule };

has 'rule'    => ( is => 'ro', required => 1 );
has 'process' => ( is => 'ro', required => 1 );
has 'message' => ( is => 'rw' );

__PACKAGE__->meta->make_immutable;

1;
