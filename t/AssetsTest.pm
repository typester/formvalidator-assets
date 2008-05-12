package t::AssetsTest;
use Test::Base -base;

our @EXPORT = qw/run_assets_test/;

use FindBin;
use CGI::Simple;
use FormValidator::Assets;

sub run_assets_test {
    my $assets_dir = shift || $FindBin::Bin;
    $assets_dir =~ s/\.t$//;

    my $f = FormValidator::Assets->new( assets_dir => $assets_dir );

    filters {
        input => ['yaml'],
    };

    run {
        my $block = shift;

        my $res = $f->process( CGI::Simple->new($block->input) );
        eval $block->expected;

        fail $@ if $@;
    };
}

1;

