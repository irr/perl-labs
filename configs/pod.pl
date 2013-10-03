#!/usr/bin/perl
#####
#
# perllocal - Cleans up perllocal.pod
#
#####

use strict;
use warnings;
$|=1;

use Pod::Perldoc;

MAIN:
{
    # Find perllocal.pod
    my ($pod) = Pod::Perldoc->new()->grand_search_init([ 'perllocal' ]);
    if (! $pod) {
        print(STDERR "WARNING: 'perllocal.pod' not found\n");
        exit(1);
    }

    # Parse perllocal.pod
    my %pod;
    my $removed = 0;
    if (open(my $IN, $pod)) {
        my ($line, $module, $order);

        # Read up to first 'head2' line
        while ($line = readline($IN)) {
            if ($line =~ /^=head2/) {
                last;
            }
        }

        # Parse each module entry
        # Duplicates will be overwritten by later entries in the file
        do {
            # New module entry encountered
            if ($line =~ /^=head2/) {
                # Extract module name from 'head2' line
                ($module) = $line =~ /L<([^|]+)\|/;
                # See if it's a duplicate
                if (exists($pod{$module})) {
                    $removed++;
                }
                # Remember this module's order in the file
                $pod{$module}{'order'} = ++$order;
                # Save the text
                $pod{$module}{'text'} = $line;

            } else {
                # Concatenate text for current module entry
                $pod{$module}{'text'} .= $line;
            }
        } while ($line = readline($IN));
        close($IN);

    } else {
        print(STDERR "ERROR: Failure opening '$pod': $!\n");
        exit(1);
    }

    # Check for uninstalls
    if (@ARGV) {
        my $arg = shift(@ARGV);
        if ($arg eq '-u') {
            for my $mod (@ARGV) {
                if (delete($pod{$mod})) {
                    print("$mod removed from 'perllocal'\n");
                    $removed++;
                } else {
                    print("$mod not found in 'perllocal'\n");
                }
            }
        }
    }

    # Output the cleaned up results
    my $cnt = 0;
    if (open(my $OUT, "> $pod")) {
        # Sort by original order
        for my $module (sort { $pod{$a}{'order'} <=> $pod{$b}{'order'} }
                          keys(%pod))
        {
            # Output the module entry
            print($OUT $pod{$module}{'text'});
            $cnt++;
        }
        close($OUT);

    } else {
        print(STDERR "ERROR: Failure opening '$pod': $!\n");
        exit(1);
    }

    # Report on results
    print("'perllocal' now contains $cnt entries.  ($removed removed.)\n");
}

exit(0);

# EOF
