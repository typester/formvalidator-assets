rule 'date';

# use_rule date => ('year', 'month');
process {
    my ($v, $args, $result) = @_;

    $result->params->{ $args->[0] } =~ /^\d{4}$/
        and $result->params->{ $args->[1] } =~ /^\d{2}$/;
};
