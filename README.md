perl-labs
-----------

**perl-labs**  is a set of sample codes whose main purpose is to experiment and test *Perl* and *[Nginx]*

**Nginx** with *Perl* module enabled:

 1. Get [Perlbrew]
```shell
yum install perl-CPAN
cpan App::cpanminus
cpanm install App::perlbrew
```

```shell
cd
curl -kL http://install.perlbrew.pl | bash
perlbrew init
perlbrew mirror
perlbrew available
# Fetching perl-5.14.4 as /home/irocha/perl5/perlbrew/dists/perl-5.14.4.tar.gz
perlbrew install perl-5.14.4 -Dusethreads -Dcccdlflags=-fPIC -Duseshrplib -Duse64bitall -Duselargefiles
perlbrew install-cpanm or cpan -i App::cpanminus
perlbrew switch perl-5.14.4 and perlbrew switch-off
perlbrew use perl-5.14.4 and exit or perlbrew off
```

 2. Get [Nginx]
```shell
cd nginx-1.4.3
wget https://github.com/irr/nginx_tcp_proxy_module/raw/master/tcp-1.4.3.patch
patch -p1 < tcp-1.4.3.patch
./configure --with-http_perl_module --with-http_ssl_module --prefix=/opt/perl/nginx --add-module=/opt/perl/nginx_tcp_proxy_module-0.4.4 --add-module=/opt/perl/headers-more-nginx-module-0.24
make -j4
make install
/opt/perl/nginx/sbin/nginx -c /home/irocha/perl/nginx/nginx-perl.conf
```

Dependencies
-----------

```shell
sudo yum install pcre-devel zlib-devel openssl-devel readline-devel sqlite-devel libpcap-devel mysql-devel
sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev libpcap-dev libmysqlclient-dev
```

```shell
cpanm -v -n DateTime
cpanm -v -n DateTime::Tiny
cpanm -v -n Eval::Closure
cpanm -v -n List::MoreUtils
cpanm -v -n PAR::Packer
cpanm -v -n Proc::ProcessTable
cpanm -v -n String::Util
cpanm -v -n Term::ReadLine::Gnu
cpanm -v -n YAML
cpanm -v -n WWW::Mechanize
```

```shell
cpanm -v -n DBD::SQLite
cpanm -v -n DBD::mysql
cpanm -v -n JSON
cpanm -v -n Redis
```

```shell
cpanm -v -n Dancer
cpanm -v -n Dancer::Plugin::Database
cpanm -v -n Dancer::Plugin::Redis
```

```shell
cpanm -v -n --configure-args="--with-http_ssl_module" Nginx
cpanm -v -n Nginx::HTTP
cpanm -v -n Nginx::Redis
cpanm -v -n Nginx::Test
```

```shell
cpanm -v -n Crypt::CBC
cpanm -v -n Crypt::Cipher::AES
cpanm -v -n Crypt::Random
cpanm -v -n Digest::MD5
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