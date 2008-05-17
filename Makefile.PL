use inc::Module::Install 0.72;
name 'FormValidator-Assets';
all_from 'lib/FormValidator/Assets.pm';

test_requires 'Test::More';

requires 'Moose';
requires 'Digest::MD5';
requires 'Array::Diff';
requires 'Path::Class::Dir';

tests 't/*.t t/assets/*/*.t';
use_test_base;

auto_include;

WriteAll;
