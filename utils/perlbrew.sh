#!/bin/bash
export PERLBREW_ROOT=/opt/perl5
export PERLBREW_HOME=$HOME/.perlbrew
source ${PERLBREW_ROOT}/etc/bashrc
perlbrew use perl-5.20.2
perl "$@"
