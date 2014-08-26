#!/bin/bash
perl -mthreads -le'$_->join for map threads->new(sub{print"Thread $_";sleep(2)}),1..4'
