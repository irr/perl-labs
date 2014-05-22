use Test::Nginx::Socket;

perl_modules("perl_modules /home/irocha/perl/nginx;");
perl_require("perl_require test.pm;");

repeat_each(1);

plan tests => $Test::Nginx::Socket::RepeatEach * 2 * blocks();

$ENV{TEST_NGINX_ERROR_LOG} = "/tmp/test.log";

log_level('warn');

run_tests();

__DATA__

=== TEST 1: basic
--- config
    location /test {
      perl test::handler;
    }
--- more_headers
Content-Type: application/json
--- request eval
"POST /test
name=ivan\n
\n
"
--- error_code: 200
--- response_body
{"/test":{"name":"ivan"}}