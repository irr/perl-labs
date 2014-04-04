#!/bin/bash
export PERLBREW_ROOT=/opt/perl5
source ${PERLBREW_ROOT}/etc/bashrc
perlbrew use perl-5.14.4
perl "$@"
