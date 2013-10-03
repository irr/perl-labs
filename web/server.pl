#!/usr/bin/env perl
use Dancer;

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


