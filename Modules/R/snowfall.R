#!/usr/bin/env Rscript

# package snowfall must be first installed with
# install.packages("snowfall")
# see http://scitas.epfl.ch/kb/Running+R+on+SCITAS+machines

library(snowfall)

# how many cpus do we have?

ncpus <- Sys.getenv('SLURM_CPUS_ON_NODE')

# we are running in parallel.
# This will take by default all the available cores on a node

sfInit(parallel=TRUE, cpus=ncpus, type="SOCK")

sfStop()
