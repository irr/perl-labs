perl-labs
-----------

**perl-labs**  is a set of sample codes whose main purpose is to experiment and test *Perl* and *[Nginx]*

**Nginx** with *Perl* module enabled:

 Get [Perlbrew]
```shell
sudo mkdir -p /opt/perl5 /opt/perl
sudo chown irocha: /opt/perl5 /opt/perl
export PERLBREW_ROOT=/opt/perl5

sudo yum install perlbrew perl-Term-ReadLine-Gnu \
                 perl-CPAN perl-Text-Diff perl-Test-LongString \
                 perl-List-MoreUtils perl-Test-Base \
                 perl-IO-Socket-SSL perl-Time-HiRes \
                 perl-ExtUtils-Embed
sudo yum groupinstall "Development Tools"

sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev \
                     libreadline-dev libsqlite3-dev libpcap-dev \
                     libmysqlclient-dev libgd-dev libexpat1-dev \
                     cpanminus libtext-diff-perl \
                     libtest-longstring-perl \
                     liblist-moreutils-perl \
                     libtest-base-perl libparams-util-perl \
                     geoip-bin geoip-database libgeoip-dev \
                     liblwp-useragent-determined-perl \
                     build-essential

sudo apt-get install eclipse
# http://www.epic-ide.org/updates/testing
# http://download.eclipse.org/egit/updates
```

```shell
perlbrew init
perlbrew mirror
perlbrew available
perlbrew install perl-5.24.0 -Dusethreads \
                             -Dcccdlflags=-fPIC \
                             -Duseshrplib \
                             -Duselargefiles \
                             -Dusemymalloc=no \
                             -Duse64bitall
perlbrew install-cpanm or cpan -i App::cpanminus
perlbrew switch perl-5.24.0 and perlbrew switch-off
perlbrew use perl-5.24.0 and exit or perlbrew off

perlbrew use perl-5.24.0
```

```shell
cd /usr/local/bin
sudo ln -s ~/perl/utils/perlbrew.sh
sudo ln -s ~/perl/utils/srt.pl srt
sudo ln -s ~/git/configs/torrents/wg.pl wg
```

CPAN
-----------

```shell
sudo apt-get install libpcre3-dev zlib1g-dev libssl-dev libreadline-dev \
                     libsqlite3-dev libpcap-dev libmysqlclient-dev \
                     libgd-dev libexpat1-dev

sudo yum install pcre-devel zlib-devel openssl-devel readline-devel \
                 sqlite-devel libpcap-devel mysql-devel gd-devel expat-devel

sudo pacman -S perl-crypt-cbc perl-dbd-mysql perl-dbd-sqlite \
               perl-io-socket-ssl perl-ipc-system-simple \
               perl-tie-hash-indexed perl-lwp-protocol-https \
               perl-term-readline-gnu perl-try-tiny \
               perl-yaml-tiny perl-test-leaktrace \
               perl-log-log4perl
```

```shell
cpanm -v -n Algorithm::NaiveBayes
cpanm -v -n App::FatPacker
cpanm -v -n Crypt::CBC
cpanm -v -n Crypt::Rijndael
cpanm -v -n Dancer2
cpanm -v -n Dancer2::Template::Mason2
cpanm -v -n DateTime
cpanm -v -n DBD::Cassandra
cpanm -v -n DBD::mysql
cpanm -v -n DBD::SQLite
cpanm -v -n ExtUtils::MakeMaker
cpanm -v -n File::Slurper
cpanm -v -n Geo::Hash::XS
cpanm -v -n Geohash
cpanm -v -n Inline::C
cpanm -v -n IO::Socket::SSL
cpanm -v -n IPC::System::Simple
cpanm -v -n Hash::Ordered
cpanm -v -n HTML::Strip
cpanm -v -n JSON
cpanm -v -n Log::Dispatch
cpanm -v -n LWP::Protocol::https
cpanm -v -n LWP::Simple
cpanm -v -n Mason
cpanm -v -n Modern::Perl
cpanm -v -n Net::Server::SS::PreFork
cpanm -v -n PAR::Packer
cpanm -v -n Pod::POM::Web
cpanm -v -n Pry
cpanm -v -n Redis
cpanm -v -n Redis::Fast
cpanm -v -n RedisDB
cpanm -v -n Reply
cpanm -v -n Scalar::Util
cpanm -v -n Task::Plack
cpanm -v -n Test::LeakTrace
cpanm -v -n Test::Nginx::Socket
cpanm -v -n Term::ReadLine::Gnu
cpanm -v -n Text::CSV_XS
cpanm -v -n Tie::File
cpanm -v -n Try::Tiny
cpanm -v -n WWW::Mechanize
cpanm -v -n XML::Simple
cpanm -v -n YAML
cpanm -v -n YAML::Tiny
```

```
export JAVA_HOME=/usr/lib/jvm/java-openjdk
cpanm -v -n Inline::Java
cpanm -v -n Lingua::StanfordCoreNLP
```

 Get [Nginx]
```shell
sudo apt-get install libreadline6-dev libpcre3-dev libssl-dev \
                     libsqlite3-dev libmysqlclient-dev libzmq3-dev libboost-all-dev \
                     geoip-bin geoip-database libgeoip-dev \
                     libapr1 libaprutil1 libaprutil1-dev libaprutil1-dbd-sqlite3 \
                     libapreq2-3 libapr1-dev libapreq2-dev libperl-dev
cd /opt/perl
wget http://nginx.org/download/nginx-1.11.4.tar.gz
wget https://github.com/openresty/headers-more-nginx-module/archive/v0.29.tar.gz \
     -O headers-more-nginx-module-0.29.tar.gz
tar xfva headers-more-nginx-module-0.29.tar.gz
tar xfva nginx-1.11.4.tar.gz
cd nginx-1.11.4
./configure --with-http_perl_module \
            --with-http_gunzip_module \
            --with-http_geoip_module \
            --with-http_realip_module \
            --with-http_stub_status_module \
            --with-http_ssl_module \
            --with-http_realip_module \
            --with-http_v2_module \
            --with-file-aio \
            --with-stream \
            --with-stream_ssl_module \
            --without-http_fastcgi_module \
            --without-http_uwsgi_module \
            --without-http_scgi_module \
            --with-debug \
            --add-module=/opt/perl/headers-more-nginx-module-0.29 \
            --prefix=/opt/perl/nginx
make -j4
make install
cd /usr/sbin
sudo ln -s /opt/perl/nginx/sbin/nginx
cd
/opt/perl/nginx/sbin/nginx -c /home/irocha/perl/nginx/nginx-perl.conf
curl -v http://localhost:8888/ -d "name=ivan&other=ale&value=100";echo
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
