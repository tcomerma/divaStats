Diva Manager scripts
-----------------

These scripts extract log information from Diva and send them to the elk server.
They use cygwin and SQL*Plus (both installed with Diva Archive). Can be
run as diva user.

A copy of the logfiles is kept local, just in case you have to reload information

Instructions
* Copy the files to C:\Scripts\elk
* Edit genera_logs_elk.sh to set username and host address for the elk server
* Edit genera_logs_elk.sh to set username and password for diva database.
* Create ssh key pair to be able to use scp without credentials. Plenty of tutorials
around, like https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
* Create an scheduled task that runs once per day, at 1:00 am
