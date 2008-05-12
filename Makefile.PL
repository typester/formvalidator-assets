use inc::Module::Install;
name 'FormValidator-Assets';
all_from 'lib/FormValidator/Assets.pm';

build_requires 'Test::More';

tests 't/*.t t/assets/*/*.t';
use_test_base;

auto_include;

WriteAll;
