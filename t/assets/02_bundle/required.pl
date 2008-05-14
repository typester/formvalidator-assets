rule 'required';

process {
    return defined $_[0] && length $_[0];
};
