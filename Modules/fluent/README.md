# How to use these examples

Submit the job with the command:
```
sbatch job.fluent.slurm
```

## Input files:
fluent-test.cas
fluent-test.jou


## Output files:
fluent-test.cas (its content changes)
fluent-test.dat

<br>
## Comments:
* The input file (here fluent-test.jou) contains the appropriate Fluent text commands (TUI).
* The case file (here fluent-test.cas) should have been created through interactive run of Fluent on a PC or on the front-end of the cluster.
* job.fluent.slurm  -> 1 node  / 16 processors
* job2.fluent.slurm -> 2 nodes / 32 processors


# Problems resolutions
Here is a little workaround in case you are experiencing some common errors.

## First example - job.fluent.slurm
The result of the job give an error such as:<br>
_/var/spool/slurmd/job4274455/slurm\_script: line 29: fluent: command not found_

**Workaround**
1. You don't belong to the *ansys-users* group.
Please ask to be added to [this group ](https://groups.epfl.ch/viewgroup?groupid=S00058)
2. You do belong to this group. In that case, try this:
	`newgrp ansys-users`
	and relaunch this batch script.


## Second example - job2.fluent.slurm
You are trying to use the second example, but you have an error such as:
*Host key verification failed.
Error: It seems ssh is trying to verify authenticity of h193. Please resolve it and try again!*

**Workaround:**
From your home directory, change to `.ssh`

Type the following command:
	`ssh-keygen -t rsa`

**Do not enter any passphrase!**

You'll get a _id\_rsa_ and _id\_rsa.pub_ files.

Add the content of the _id\_rsa.pub_ into _authorized\_keys_ file
	(if it doesn't exit, just create it: `touch authorized_keys`).

Then, create a config file (`vi config`) and add the following:
```
Host *
  StrictHostKeyChecking no
```




Author: Jean-Luc Desbiolles (2015-10-27)
	Update: Jean-Claude De Giorgi (2020-05-11)