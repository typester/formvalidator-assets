use Test::Base 'no_plan';

use FindBin;
use File::Spec;

use CGI::Simple;
use FormValidator::Assets;

my $f = FormValidator::Assets->new( assets_dir => File::Spec->catfile($FindBin::Bin, 'assets', 'foobar') );

ok($f, 'object created successfully');
isa_ok($f, 'FormValidator::Assets');

my $res = $f->process(CGI::Simple->new({ foo => 'foo', bar => 'bar' }));


