use strict;
use warnings;

use Eval::Closure;
 
my $code = eval_closure(
    source      => 'sub { $foo++ }',
    environment => {
        '$foo' => \1,
    },
);
 
warn $code->(); # 1
warn $code->(); # 2