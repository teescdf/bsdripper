# *bsdripper (Work in Progress)*
Script for live collection of data and triage of BSD-based systems. Offshoot of [*linuxripper*](https://github.com/teescdf/linuxripper) project. Work in progress - use with caution!

## acquiring and running *bsdripper*

The script can be downloaded directly onto a web-connected BSD computer with the following command:
```
wget https://github.com/teescdf/bsdripper/raw/refs/heads/main/bsdripper/bsdripper.sh
```
Make the script executable with:
```
chmod +x bsdripper.sh
```
Run the script with:
```
sh bsdripper.sh
```
Or preferably rather, run the following command to automatically log all on-screen outputs and errors to a logfile. These will print out to screen normally (with the above command), but this version will also capture everything into a text file for you:
```
sh bsdripper.sh 2>&1 | tee -a logfile.txt
```
The resultant logfile will be moved into the collection folder automatically, and renamed to **0_caselog.txt**.

Certain data (e.g. certain log files and the /etc/shadow file) may not be collected unless this script is run with admin privileges. Ideally run using an account with admin/sudo privileges.

NB: The use of "2>&1" in the above commands results in both STDERR and STDOUT being captured to the logfile. The command can be run without this, however error messages (and additional information) will not be captured.

Finally, collect all of the resultant data that is produced (found in the "collection" folder) and review it accordingly (see below for more detail on this).

## post-run collection exfiltration options
There are several options/methods for exfiltration/extraction of the collected data, for subsequent review. If the collected data is stored on an isolated storage medium (e.g. a connected USB stick, then safe removal is the only thing required at this stage. If the collection took place on the local, internal storage, then exfiltration of the data will be required. 

For example, the data can be packaged up into a tar.gz file, using the following commands
```
cd ..
```
This command moves one directory level up, so that the **tar** command can be used to compress and archive the complete working folder from which *bsdripper* was run. It would then be followed by:
```
tar -czvf [filename].tar.gz [foldername]/
```
Use of some form of relevant identifier is recommended, for example:
```
tar -czvf 20260402_server001.tar.gz bsdripper/
```
The above example command is based on an hypothetical collection in which the *bsdripper* script was placed in a folder called "bsdripper" on the target system (known as ***server001***,) and ran from there, and also that collection took place on 2nd April 2026; hence using ***20260402*** as the case ref. no.

Once packaged, the data may be collected or transmitted remotely, for example by using scp, or alternatively, it may be uploaded to cloud storage for subsequent download.

The created **tar** archive can then either be copied off manually, via an external disc, or alternatively can be acquired remotely over the network, via commands such as **scp**. The **scp** command (run on the destination workstation) to do this is structured as follows:
```
scp [filename].tar.gz [username]@[IP address or hostname of target computer]:[path to save location on target forensic device]
```
For example:
```
scp 20260402_server001.tar.gz investigator@server001:/home/investigator/Desktop
```
Again, the above example is based on an hypothetical case in which the computer being investigated is ***server001***, the case ref. is ***20260402***, and the forensic workstation's local user account is ***investigator***.

<!-- ## footprint minimisation considerations...STILL TO DO!
For those especially conscious of the footprint resulting from downloading this file onto the target machine, a lightweight version of the script has been created. In this version, all non-essential information has been removed (e.g. comments, additional information etc.) so that the script uses minimal disc space. This version can be found in the repository, named br.sh. Deploy in the usual way (wget/via USB stick), make executable and run as follows:

```
wget https://github.com/teescdf/bsdripper/raw/refs/heads/main/bsdripper/br.sh
              [[or deploy via USB]]
```
```
chmod +x br.sh
sh br.sh
              [[logfile creation with "2>&1 | tee -a logfile.txt" entirely optional]]
-->
.
