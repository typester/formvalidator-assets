use t::AssetsTest;

plan 'no_plan';

run_assets_test('t/assets/01_nop');

1;

__DATA__

===
--- input
foo: bar
--- expected
is($res->valid('foo'), 'bar');

===
--- input
bar: foo
--- expected
ok($res->has_error, 'has errors');
ok(!$res->valid('bar'));

