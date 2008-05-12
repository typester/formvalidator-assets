package FormValidator::Assets::Result;
use Moose;

has 'input' => ( is => 'ro' );

has 'valid_fields'   => ( is => 'rw', default => sub { {} } );
has 'invalid_fields' => ( is => 'rw', default => sub { {} } );

sub has_error {
    my ($self) = @_;
    scalar keys %{ $self->invalid_fields };
}

sub valid {
    my ($self, $k) = @_;

    if ($k) {
        my $valid = $self->valid_fields->{$k};
        return defined($valid) ? $self->input->param($k) : ();
    }
    else {
        my $res;
        my @valid = keys %{ $self->valid_fields };
        for my $v (@valid) {
            $res->{ $v } = $self->input->param($v);
        }
        return $res;
    }
};

1;


