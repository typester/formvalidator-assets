use t::AssetsTest;

plan 'no_plan';

run_assets_test('t/assets/02_bundle', 'foo_and_bar');

1;

__DATA__

===
--- input
foo: bar
--- expected
ok( $res->has_error, 'bar is required!');


