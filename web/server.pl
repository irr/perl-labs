#!/usr/bin/env perl
use Dancer;

# http://www.nntp.perl.org/group/perl.par/2013/12/msg5672.html
# pp -a "/path/to/your/MIME/types.db;lib/MIME/types.db" \
#    -F PatchContent=MIME/Types.pm \
#    -M PerlIO::encoding 

# development
#set environment => 'development';
#set log => 'core';

# production
set environment => 'production';
set log => 'warning';
set startup_info => 0;
set show_errors =>  0;

set logger => 'console';
set serializer => 'JSON';
set charset => 'UTF-8';
set default_mime_type => 'application/json';

get '/' => sub {
    { name => "ivan", value => 200, list => [ 1, 2, 3 ] };
};

dance;


