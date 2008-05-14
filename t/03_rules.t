use t::AssetsTest;

plan 'no_plan';

run_assets_test('t/assets/03_rules');

1;

__DATA__

===
--- input
required: 0
--- expected
ok( $res->has_error );
ok( !$res->valid('required') );

===
--- input
required: "foo"
--- expected
ok( !$res->has_error );
is( $res->valid('required'), "foo" );

===
--- input
yr: 2008
mo: 10
--- expected
ok( !$res->has_error );

