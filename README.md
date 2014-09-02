perl-labs
-----------

**perl-labs**  is a set of sample codes whose main purpose is to experiment and test *Perl* and *[Nginx]*

**Nginx** with *Perl* module enabled:

 Get [Perlbrew]
```shell
export PERLBREW_ROOT=/opt/perl5
sudo yum install perlbrew perl-Term-ReadLine-Gnu
sudo yum groupinstall "Development Tools"
```
```shell
perlbrew init
perlbrew mirror
perlbrew available
perlbrew install perl-5.20.0 -Dusethreads -Dcccdlflags=-fPIC -Duseshrplib -Duse64bitall -Duselargefiles -Dusemymalloc=no
perlbrew install-cpanm or cpan -i App::cpanminus
perlbrew switch perl-5.20.0 and perlbrew switch-off
perlbrew use perl-5.20.0 and exit or perlbrew off
```
```shell
perlbrew use perl-5.20.0
cd /usr/include; h2ph -r -l . && h2ph asm/*
```
 Get [Nginx]
```shell
wget http://nginx.org/download/nginx-1.6.0.tar.gz
tar xfva nginx-1.6.0.tar.gz
cd nginx-1.6.0
./configure --with-http_perl_module --with-http_ssl_module --prefix=/opt/perl/nginx
make -j4
make install 
/opt/perl/nginx/sbin/nginx -c /home/irocha/perl/nginx/nginx-perl.conf
```

CPAN
-----------

```shell
sudo yum install pcre-devel zlib-devel openssl-devel readline-devel sqlite-devel libpcap-devel mysql-devel gd-devel expat-devel
sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev libpcap-dev libmysqlclient-dev libgd-dev libexpat1-dev
```
```shell
cpanm -v -n Authen::Krb5::Admin
cpanm -v -n Crypt::CBC
cpanm -v -n Crypt::Rijndael
cpanm -v -n DBD::mysql
cpanm -v -n DBD::SQLite
cpanm -v -n IO::Socket::SSL
cpanm -v -n IPC::System::Simple
cpanm -v -n Hash::Ordered
cpanm -v -n JSON
cpanm -v -n JSON::PP
cpanm -v -n Log::Dispatch
cpanm -v -n LWP::Protocol::https
cpanm -v -n Net::Server::SS::PreFork
cpanm -v -n PAR::Packer
cpanm -v -n Perl::MinimumVersion
cpanm -v -n Pry
cpanm -v -n Redis
cpanm -v -n Reply
cpanm -v -n Task::Plack
cpanm -v -n Test::LeakTrace
cpanm -v -n Test::Nginx::Socket
cpanm -v -n Term::ReadLine::Gnu
cpanm -v -n Text::CSV_XS
cpanm -v -n Try::Tiny
cpanm -v -n YAML
cpanm -v -n YAML::Tiny
```
```shell
cpanm -v -n Finance::Quote
cpanm -v -n Finance::QuoteHist
cpanm -v -n GD::Graph
cpanm -v -n Math::Business::SMA
```
```shell
cpanm -v -n Pod::POM::Web
perl -MPod::POM::Web -e "Pod::POM::Web->server"
```
 Get [Software Collections]
```shell 
sudo yum install https://www.softwarecollections.org/en/scls/rhscl/perl516/epel-6-x86_64/download/rhscl-perl516-epel-6-x86_64-1-1.noarch.rpm
sudo yum update -y
sudo yum install --nogpg -y perl516
scl enable perl516 <script>
```
* [nginx_tcp_proxy_module]: add the feature of tcp proxy with nginx, with health check and status monitor
* [headers-more-nginx-module]: set, add, and clear arbitrary output headers

Copyright and License
-----------
Copyright 2012 Ivan Ribeiro Rocha

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[Nginx]: http://wiki.nginx.org/
[Perlbrew]: http://perlbrew.pl/
[nginx_tcp_proxy_module]: https://github.com/irr/nginx_tcp_proxy_module
[headers-more-nginx-module]: https://github.com/agentzh/headers-more-nginx-module
[Software Collections]: https://www.softwarecollections.org/en/scls/rhscl/perl516/
