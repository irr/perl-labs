#!/bin/bash
export PERLBREW_ROOT=$HOME/perl5/perlbrew
export PERLBREW_HOME=$HOME/.perlbrew
source ${PERLBREW_ROOT}/etc/bashrc
perlbrew use perl-5.14.4
perl "$@"
