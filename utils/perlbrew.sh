#!/bin/bash
if [ -z ${PERLBREW_PERL+x} ]; then
    export PERLBREW_ROOT=/opt/perl5
    export PERLBREW_HOME=$HOME/.perlbrew
    source ${PERLBREW_ROOT}/etc/bashrc
    perlbrew use perl-5.24.0
fi
perl "$@"
