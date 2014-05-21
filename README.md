perl-labs
-----------

**perl-labs**  is a set of sample codes whose main purpose is to experiment and test *Perl* and *[Nginx]*

**Nginx** with *Perl* module enabled:

Ubuntu 14.04 LTS
```shell
sudo apt-get install perl-doc-html libperl-dev libterm-readline-gnu-perl libpar-packer-perl libtry-tiny-perl libjson-perl libredis-perl libcache-memcached-perl libdbd-mysql-perl libplack-perl libauthen-krb5-admin-perl starman libcrypt-cbc-perl libcrypt-rijndael-perl libpod-webserver-perl libpoe-perl libwww-mechanize-perl libnet-pcap-perl libnetpacket-perl libdancer-perl libarchive-any-perl libdatetime-perl libparallel-forkmanager-perl
```
```shell
http://search.cpan.org/~kazuho/Net-Server-SS-PreFork-0.05/lib/Net/Server/SS/PreFork.pm

[irocha@irrlab perl]$ tar xfva /media/irocha/128G/Sources/Net-Server-SS-PreFork-0.05.tar.gz 
Net-Server-SS-PreFork-0.05/
Net-Server-SS-PreFork-0.05/Changes
Net-Server-SS-PreFork-0.05/inc/
Net-Server-SS-PreFork-0.05/lib/
Net-Server-SS-PreFork-0.05/Makefile.PL
Net-Server-SS-PreFork-0.05/MANIFEST
Net-Server-SS-PreFork-0.05/META.yml
Net-Server-SS-PreFork-0.05/README
Net-Server-SS-PreFork-0.05/t/
Net-Server-SS-PreFork-0.05/t/00-base.t
Net-Server-SS-PreFork-0.05/t/01-httpd.pl
Net-Server-SS-PreFork-0.05/t/01-httpd.t
Net-Server-SS-PreFork-0.05/t/02-multiport.t
Net-Server-SS-PreFork-0.05/lib/Net/
Net-Server-SS-PreFork-0.05/lib/Net/Server/
Net-Server-SS-PreFork-0.05/lib/Net/Server/SS/
Net-Server-SS-PreFork-0.05/lib/Net/Server/SS/PreFork.pm
Net-Server-SS-PreFork-0.05/inc/HTTP/
Net-Server-SS-PreFork-0.05/inc/LWP/
Net-Server-SS-PreFork-0.05/inc/Module/
Net-Server-SS-PreFork-0.05/inc/Test/
Net-Server-SS-PreFork-0.05/inc/Test/TCP.pm
Net-Server-SS-PreFork-0.05/inc/Module/AutoInstall.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/
Net-Server-SS-PreFork-0.05/inc/Module/Install.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/AutoInstall.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Base.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Can.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Fetch.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Include.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Makefile.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Metadata.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/Win32.pm
Net-Server-SS-PreFork-0.05/inc/Module/Install/WriteAll.pm
Net-Server-SS-PreFork-0.05/inc/LWP/Simple.pm
Net-Server-SS-PreFork-0.05/inc/HTTP/Server/
Net-Server-SS-PreFork-0.05/inc/HTTP/Server/Simple/
Net-Server-SS-PreFork-0.05/inc/HTTP/Server/Simple/CGI.pm
[irocha@irrlab perl]$ cd Net-Server-SS-PreFork-0.05/
[irocha@irrlab Net-Server-SS-PreFork-0.05]$ ll
total 40
drwxr-xr-x 5 irocha irocha 4096 Fev 21  2010 ./
drwxr-xr-x 4 irocha irocha 4096 Mai 16 17:30 ../
-rw-r--r-- 1 irocha irocha  570 Fev 21  2010 Changes
drwxr-xr-x 6 irocha irocha 4096 Mai 16 17:30 inc/
drwxr-xr-x 3 irocha irocha 4096 Mai 16 17:30 lib/
-rw-r--r-- 1 irocha irocha  393 Fev 16  2010 Makefile.PL
-rw-r--r-- 1 irocha irocha  529 Fev 21  2010 MANIFEST
-rw-r--r-- 1 irocha irocha  608 Fev 21  2010 META.yml
-rw-r--r-- 1 irocha irocha   33 Fev 16  2010 README
drwxr-xr-x 2 irocha irocha 4096 Fev 21  2010 t/
[irocha@irrlab Net-Server-SS-PreFork-0.05]$ perl Makefile.PL 
*** Module::AutoInstall version 1.03
*** Checking for Perl dependencies...
[Core Features]
- LWP::Simple               ...loaded. (5.827)
- Test::TCP                 ...loaded. (0.16 >= 0.06)
- HTTP::Server::Simple::CGI ...loaded. (0.44)
- Net::Server               ...loaded. (2.007)
- Server::Starter           ...loaded. (0.15 >= 0.02)
*** Module::AutoInstall configuration finished.
Checking if your kit is complete...
Looks good
Writing Makefile for Net::Server::SS::PreFork
Writing MYMETA.yml and MYMETA.json
[irocha@irrlab Net-Server-SS-PreFork-0.05]$ make
cp lib/Net/Server/SS/PreFork.pm blib/lib/Net/Server/SS/PreFork.pm
Manifying blib/man3/Net::Server::SS::PreFork.3pm
[irocha@irrlab Net-Server-SS-PreFork-0.05]$ sudo make install
Installing /usr/local/share/perl/5.18.2/Net/Server/SS/PreFork.pm
Installing /usr/local/man/man3/Net::Server::SS::PreFork.3pm
Appending installation info to /usr/local/lib/perl/5.18.2/perllocal.pod
```

 Get [Perlbrew]
```shell
export PERLBREW_ROOT=/opt/perl5

# CentOS
sudo yum install perl-ExtUtils-MakeMaker
curl -kL http://install.perlbrew.pl | bash

# Ubuntu
sudo apt-get install perlbrew build-essential

# Install
perlbrew init
perlbrew mirror
perlbrew available
perlbrew install-patchperl
perlbrew install perl-5.14.4 -Dusethreads -Dcccdlflags=-fPIC -Duseshrplib -Duse64bitall -Duselargefiles
perlbrew install-cpanm or cpan -i App::cpanminus
perlbrew switch perl-5.14.4 and perlbrew switch-off
perlbrew use perl-5.14.4 and exit or perlbrew off
```

 Get [Nginx]
```shell
wget http://nginx.org/download/nginx-1.6.0.tar.gz
tar xfva nginx-1.6.0.tar.gz
cd nginx-1.6.0
wget https://github.com/irr/nginx_tcp_proxy_module/raw/master/tcp-1.6.0.patch
patch -p1 < tcp-1.6.0.patch
./configure --with-http_perl_module --with-http_ssl_module --prefix=/opt/perl/nginx --add-module=/opt/perl/nginx_tcp_proxy_module --add-module=/opt/perl/headers-more-nginx-module-0.25
make -j4
make install 
or
sudo make install
/opt/perl/nginx/sbin/nginx -c /home/irocha/perl/nginx/nginx-perl.conf
```

 Get [Software Collections]
```shell 
sudo yum install https://www.softwarecollections.org/en/scls/rhscl/perl516/epel-6-x86_64/download/rhscl-perl516-epel-6-x86_64-1-1.noarch.rpm
sudo yum update -y
sudo yum install --nogpg -y perl516
scl enable perl516 <script>
```

Dependencies
-----------

```shell
sudo yum install pcre-devel zlib-devel openssl-devel readline-devel sqlite-devel libpcap-devel mysql-devel
sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev libpcap-dev libmysqlclient-dev
```

```shell
cpanm -v -n Authen::Krb5::Admin
cpanm -v -n Crypt::CBC
cpanm -v -n Crypt::Rijndael
cpanm -v -n DBD::mysql
cpanm -v -n JSON
cpanm -v -n Net::Server::SS::PreFork
cpanm -v -n Redis
cpanm -v -n Task::Plack
cpanm -v -n Term::ReadLine::Gnu
cpanm -v -n Try::Tiny
cpanm -v -n YAML::Tiny
cpanm -v -n WWW::Mechanize
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
