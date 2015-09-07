#!/usr/bin/env perl

# rm -rf fatlib hello.packed.pl types.db packlists

# fatpack pack hello.pl > hello.packed.pl

# fatpack trace hello.pl
# fatpack packlists-for `cat fatpacker.trace` >packlists
# fatpack tree `cat packlists`
# fatpack file hello.pl > hello.packed.pl

# chmod a+x hello.packed.pl
# cp fatlib/MIME/types.db .
# ./hello.packed.pl

use Dancer2;

get '/' => sub {
    'Hello World'
};

dance;