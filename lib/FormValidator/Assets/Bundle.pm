package FormValidator::Assets::Bundle;
use Moose;

use overload q{""} => sub { shift->bundle };

has 'bundle' => ( is => 'ro', required => 1 );
has 'names'  => ( is => 'rw', default => sub { [] } );

sub BUILD {
    my ($self, $args) = @_;

    
}

1;

