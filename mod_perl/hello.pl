#!/usr/bin/perl
use strict;
use JSON;

print "Content-type: application/json\n\n";

my $json = JSON->new->allow_nonref;
my $value = { name => "ivan", mod_perl => "rocks!" };
print $json->pretty->encode($value);

# sudo yum install perl-JSON mod_perl
# sudo vim /etc/httpd/conf/httpd.conf

# ServerName york
#
# User irocha
# Group irocha
#
# Alias /perl /home/irocha/git/cc-lab/perl/mod_perl
# <Location /perl/>
#     SetHandler perl-script
#     PerlResponseHandler ModPerl::Registry
#     PerlOptions +ParseHeaders
#     Options +ExecCGI
#     Order allow,deny
#     Allow from all 
# </Location>


