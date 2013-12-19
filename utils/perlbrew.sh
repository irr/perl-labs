#!/bin/bash
export PERLBREW_ROOT=$HOME/perl5/perlbrew
export PERLBREW_HOME=$HOME/.perlbrew
source ${PERLBREW_ROOT}/etc/bashrc
perlbrew use perl-5.18.1
perl "$@"