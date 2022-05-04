# Chapter 6: Submitters
# Lesson 2:  Sun Grid Engine (Simple)

# note: submitter syntax is currently experimental since a major change is planned for a future release
global {
  ducttape_experimental_submitters=enable
}

task hello_sge :: .submitter=sge .walltime="00:01:00" .vmem=1g .q=all.q {
  echo hello
}

# cpus, vmem, walltime, q: these can be passed as parameters to each task: .cpus .vmem .walltime .q
# COMMANDS: the bash commands from some task
# TASK, REALIZATION, CONFIGURATION: variables passed by ducttape
submitter sge :: vmem walltime q
              :: COMMANDS
              :: TASK REALIZATION CONFIGURATION {
  action run {
    wrapper="ducttape_job.sh"
    echo "#$ -S /bin/bash" >> $wrapper
    echo "#$ -q $q" >> $wrapper
    echo "#$ -l h_rt=$walltime" >> $wrapper
    echo "#$ -j y" >> $wrapper
    echo "#$ -o localhost:$PWD/job.out" >> $wrapper
    echo "#$ -N $CONFIGURATION-$TASK-$REALIZATION" >> $wrapper

    # Bash flags aren't necessarily passed into the scheduler
    # so we must re-initialize them
    echo "set -e # stop on errors" >> $wrapper
    echo "set -o pipefail # stop on pipeline errors" >> $wrapper
    echo "set -u # stop on undeclared variables" >> $wrapper
    echo "set -x # show each command as it is executed" >> $wrapper

    # The current working directory will also be changed by most schedulers
    echo "cd $PWD" >> $wrapper

    echo "$COMMANDS" >> $wrapper

    # Use SGE's -sync option to prevent qsub from immediately returning
    qsub -sync y $wrapper
  }
}
