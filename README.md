# pcapitate
CURRENT BRANCH:
===============
V1.1

SUMMARY:
========
Project: extract packets based on host IP and time frame from large tcpdump file

DESCRIPTION:
============
shell script (pcapitate.sh) for linux that leverages editcap and tcpdump filtering options to extract packets based on host IP (source & Destination) as well as time range. This tool requires the following information:
1. start time (YYYY-MM-DD hh:mm:ss)
2. stop time (YYYY-MM-DD hh:mm:ss)
3. IP to filter (optional)
4. Output path/file.name

Next is a powershell script (pcapitator.ps1) intended to gather the necessary information from standard users on a remote windows machine and remotely execute pcapitate.sh and pull the file back to the windows machine for analysis. This is accomplished by leveraging plink.exe and pscp.exe, two modules included with PuTTY. In addition to the information required for pcapitate.sh, pcapitator.ps1 also requires the following information:
1. username
2. password
3. local output file destination

These are the version 1.0 requirements.

IN DEV:
=======
1. Input validation
2. A simple GUI for pcapitator.ps1 :heavy_check_mark:
3. Argument switches for pcapitate.sh :heavy_check_mark:
4. error handling
5. Optional IP filtering :heavy_check_mark:
6. key pair usage
