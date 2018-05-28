# pcapitate
CURRENT Version:
===============
V1.1

SUMMARY:
========
A great tool for infosec and sysadmins who collect tcpdump data on one or more remote linux machine(s). These files can be very large and often need to be split prior to being moved and analyzed. Pcapitate.sh is a standalone linux side script which allows the user to filter out packets by time range as well as by host IP (source and destination).  In addition to Pcapitate I've included Pcapitator.ps1 which is a windows side administration tool for Pcapitate.sh. Pcapitator is a Powershell built GUI and interface agent which automatically collects and forwards information to pcapitate.sh via ssh and transfers the output pcap to the local windows machine or file share.

DEPENDENCIES:
=============
plink.exe (PuTTY - Windows)
pscp.exe (PuTTY - Windows)
editcap (Wireshark - Linux)
tcpdump (tcpdump - Linux)

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

IN DEV:
=======
1. Input validation :heavy_check_mark:
2. A simple GUI for pcapitator.ps1 :heavy_check_mark:
3. Argument switches for pcapitate.sh :heavy_check_mark:
4. Optional IP filtering :heavy_check_mark:
5. key pair usage
