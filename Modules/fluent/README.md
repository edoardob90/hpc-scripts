= How to use these examples =

Submit the job with the command:
  sbatch job.fluent.slurm


= Input files: =
fluent-test.cas
fluent-test.jou


= Output files: =
* fluent-test.cas (its content changes)
* fluent-test.dat

  
= Comments: =
* The input file (here fluent-test.jou) contains the appropriate Fluent text commands (TUI).
* The case file (here fluent-test.cas) should have been created through interactive run of Fluent on a PC or on the front-end of the cluster.
* job.fluent.slurm  -> 1 node  / 16 processors
* job2.fluent.slurm -> 2 nodes / 32 processors


= Problems resolutions =
Here is a little workaround in case you are experiencing some common errors.

== First example - job.fluent.slurm ==
The result of the job gives an error such as: 

///var/spool/slurmd/job4274455/slurm_script: line 29: fluent: command not found//


== Workaround ==
* You don't belong to the **ansys-users** group.
Please ask to be added to [this group ](https://groups.epfl.ch/viewgroup?groupid=S00058)
* You do belong to this group. In that case, try this command:

`newgrp ansys-users`

and relaunch this batch script.


== Second example - job2.fluent.slurm ==
You are trying to use the second example, but you have an error such as: 

COUNTEREXAMPLE
//Host key verification failed.//

//Error: It seems ssh is trying to verify authenticity of [node's hostname]. Please resolve it and try again!//

== Workaround: ==
From your home directory, change directory to `.ssh`

Type the following command:
  ssh-keygen -t rsa

IMPORTANT: Do not enter any passphrase!

You'll get a //id_rsa// and //id_rsa.pub// files.

Add the content of the //id_rsa.pub// into //authorized_keys// file.
NOTE: if authorized_keys file doesn't exit, just create it as follow: 

  touch authorized_keys

Then, create a config file:
  vi config

and add the following:
```
Host *
  StrictHostKeyChecking no
```




{nav Author: Jean-Luc Desbiolles (2015-10-27)}    
{nav Update: Jean-Claude De Giorgi (2020-05-11)}
