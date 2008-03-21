rule 'ascii';

process {
    return !!(shift =~ /^[\x00-\x7f]*$/);
};
