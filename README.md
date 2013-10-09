perl-labs
-----------

**perl-labs**  is a set of sample codes whose main purpose is to experiment and test *Perl* and *[Nginx]*

**Nginx** with *Perl* module enabled:

 1. Get [Perlbrew]
```shell
cd
curl -kL http://install.perlbrew.pl | bash
perlbrew init
perlbrew mirror
perlbrew available
perlbrew install perl-5.18.1 -Dusethreads
perlbrew install-cpanm or cpan -i App::cpanminus
perlbrew switch perl-5.18.1 and perlbrew switch-off
perlbrew use perl-5.18.1 and exit or perlbrew off
```

 2. Get [Nginx]
```shell
./configure --with-http_perl_module --with-http_ssl_module --prefix=/opt/perl/nginx
make install
/opt/perl/nginx/sbin/nginx -c /home/irocha/perl/nginx/nginx-perl.conf
```

Dependencies
-----------

```shell
sudo yum install pcre-devel zlib-devel openssl-devel readline-devel sqlite-devel libpcap-devel
sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev libpcap-dev
```

```shell
cpanm -v Redis
cpanm -v JSON
cpanm -v Dancer
cpanm -v DBD::SQLite
cpanm -v DBD::mysql
cpanm -v Net::Async::CassandraCQL
cpanm -v Test::Nginx::Socket
cpanm -v POE
cpanm -v Net::Pcap
cpanm -v NetPacket::Ethernet
cpanm -v Encode::Detect::Detector
```

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
  