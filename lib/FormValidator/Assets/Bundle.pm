package FormValidator::Assets::Bundle;
use Moose;

extends 'FormValidator::Assets::Component';

use overload q{""} => sub { shift->bundle };

has 'bundle' => ( is => 'ro', required => 1 );
has 'fields' => ( is => 'rw', default => sub { [] } );

1;

