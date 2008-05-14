package FormValidator::Assets::Result;
use Moose;

use Array::Diff;

extends 'FormValidator::Assets::Component';

has input => ( is => 'ro' );

has params => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { {} },
);

has errors => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { {} },
);

sub BUILD {
    my ($self, $args) = @_;

    my @params;
    if ($self->context->{bundle}) {
        @params = @{ $self->context->{bundle}->fields };
    }
    else {
        @params = $self->input->param;
    }

    my %params = map { $_ => $self->input->param($_) || '' } @params;
    $self->params( \%params );
}

sub has_error {
    my $self = shift;
    scalar keys %{ $self->errors };
}

sub valid {
    my ($self, $p) = @_;

    if ($p) {
        $self->errors->{$p} ? return : return $self->params->{$p};
    }

    my @params = keys %{ $self->params };
    my @errors = keys %{ $self->errors };

    my $diff = Array::Diff->diff(\@params, \@errors);

    return {
        map { $_ => $self->params->{$_} } @{ $diff->deleted }
    };
}

sub process {
    my ($self, @rest) = @_;

    $self->apply_filters(@rest);
    $self->check_rules(@rest);

    return $self;
}

sub apply_filters {
    my $self = shift;

    for my $p ( keys %{ $self->params } ) {
        my $field = $self->context->fields->{$p} or next;

        for my $filter (@{ $field->filters }) {
            $self->params->{$p} = $filter->process->( $self->params->{$p}, $self, @_ );
        }
    }
}

sub check_rules {
    my $self = shift;

    for my $p ( keys %{ $self->params } ) {
        my $field = $self->context->fields->{$p} or next;

        for my $rule_name (@{ $field->rules }) {
            my $rule = $self->context->rules->{$rule_name} or next;
            my $args = $field->rule_args->{$rule} || [];

            my $ok = $rule->process->( $self->params->{$p}, $args, $self, @_ );

            unless ($ok) {
                $self->errors->{$p}{ $rule }++;
            }
        }
    }
}

1;
