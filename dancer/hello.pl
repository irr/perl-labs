#!/usr/bin/env perl

# rm -rf fatlib hello.packed.pl types.db
# fatpack pack hello.pl > hello.packed.pl
# chmod a+x hello.packed.pl
# cp fatlib/MIME/types.db .
# ./hello.packed.pl

use Dancer2;

get '/' => sub {
    'Hello World'
};

dance;