package FormValidator::Assets::Rule;
use Moose;

use overload q{""} => sub { shift->rule };

has 'rule'    => ( is => 'ro', required => 1 );
has 'process' => ( is => 'ro', required => 1 );

sub BUILD {
    my ($self, $args) = @_;

    
}

1;
