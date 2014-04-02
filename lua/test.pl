use strict;
use warnings;

# cpanm -v -n Lua::API
# sudo ln -s /usr/lib64/pkgconfig/lua.pc /usr/lib64/pkgconfig/lua5.1.pc

use Lua::API;

my $L = Lua::API::State->new;

my $status = $L->loadfile("test.lua");
if($status) {
    die "Failed to load file: " . $L->tostring(-1);
}

$L->newtable;
for(my $i = 1; $i <= 5; $i++) {
    $L->pushnumber($i);
    $L->pushnumber($i*2);
    $L->rawset(-3);
}
$L->setglobal("foo");

my $result = $L->pcall(0, Lua::API::MULTRET, 0);
if($result) {
    die "Failed to execute file: " . $L->tostring(-1);
}

my $sum = $L->tonumber(-1);

print "Script returned $sum\n";

$L->pop(1);
$L->close;
