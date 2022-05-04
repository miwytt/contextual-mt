#$ -S /bin/bash
#$ -q all.q
#$ -l h_rt=00:01:00
#$ -j y
#$ -o localhost:/home/jhclark/workspace-scala/ducttape/builtins/hello/baseline/job.out
#$ -N -hello-baseline
set -e # stop on errors
set -o pipefail # stop on pipeline errors
set -u # stop on undeclared variables
set -x # show each command as it is executed
cd /home/jhclark/workspace-scala/ducttape/builtins/hello/baseline

  echo hello

