#!/bin/bash

#####################################################################################
#       ~~~~~~~~~~~~~~~~~~~~~~~~~~~PCAPITATE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#       ~~~~~~~~~~~~~~~~~~~~~~~By: CylentKnight~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#       Version 1.1: User friendly version, requires 5-6 arguments to include       #
# start date, start time, end date, end time, IP (Optional), and Output Destination.#
#       Script requires editcap (part of the Wireshark application) and tcpdump.    #
#####################################################################################

### Begin Argument Parsing ###
while [[ $# -gt 0 ]] && [[ ."$1" = .-* ]]; do
  arg="$1"
  shift;
  case $arg in
    "-a")
      strStartDate="$1"
      shift;
      strStartTime="$1"
      shift;
      ;;
    "-b")
      strEndDate="$1"
      shift;
      strEndTime="$1"
      shift;
      ;;
    "-i")
      strHost="$1"
      shift;
      ;;
    "-o")
      strOutFile="$1"
      shift;
      ;;
    *)
      echo "\nUSAGE:"
      echo "pcapitate.sh -a <START TIME> -b <END TIME> [-i <FILTER IP>] -o <OUTPUT PATH/FILE>"
      echo "=================================================================================="
      echo "\n-a  Start time for capture. FORMAT YYYY-MM-DD hh:mm:ss"
      echo "-b  End time for capture. FORMAT YYYY-MM-DD hh:mm:ss"
      echo "-i  Host IP address to filter. Ex. 192.168.1.1"
      echo "-o  Output file path and file name. Ex. /tmp/pcap1.pcap"
      echo "\nEXAMPLES:"
      echo "=================================================================================="
      echo "\npcapitate.sh -a 2018-05-01 10:00:00 -b 2018-05-01 10:05:00 -i 10.10.10.1 -o /tmp/pcap1.pcap"
      echo "pcapitate.sh -a 2018-05-01 10:00:00 -b 2018-05-01 10:05:00 -o /tmp/pcap1.pcap\n"
      exit
      ;;
  esac
done

### Begin Input Validation ###
if [ -z "$strStartDate" ] || [ -z "$strStartTime" ] || [ -z "$strEndDate" ] || [ -z "$strEndTime" ] || [ -z "$strOutFile"]; then
  echo "Missing arguments, type -h for help"
  exit 1
fi
if [[ $strStartDate =~ ^20[0-9]{2}-[0-1][0-9]-[0-3][0-9]$ ]] || [[ $strEndDate =~ ^20[0-9]{2}-[0-1][0-9]-[0-3][0-9]$ ]]; then
  echo "SYNTAX ERROR: Invalid date format YYYY-MM-DD"
  exit 1
fi
if [[ $strStartTiem =~ ^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$ ]] || [[ $strEndDate =~ ^[0-2][0-9]:[0-5][0-9]:[0-5][0-9]$ ]]; then
  echo "SYNTAX ERROR: Invalid time format HH:mm:ss"
  exit 1
fi
if [ -z "$strHost" ]; then
  noHost=1
else
  if [[ $strHost =~ ^[0-9]{1-3}.[0-9]{1-3}.[0-9]{1-3}.[0-9]{1-3}$ ]]; then
    echo "SYNTAX ERROR: Invalid -i filter IP"
    exit 1
fi

### Begin Spinning Gears ###
cp /data/TCPDumpLog/pcap /tmp/pcap_copy #change this to the path of your live tcpdump file
/usr/bin/editcap -A """$strStartDate $strStartTime""" -B """$strEndDate $strEndTime""" /tmp/pcap_copy /tmp/pcap_tmp &>/dev/null
rm /tmp/pcap_copy
if [ -z "$noHost" ]; then
  /usr/bin/tcpdump -nnvvX -r /tmp/pcap_tmp host $strHost -w $strOutFile &>/dev/null
  rm /tmp/pcap_tmp
else
  mv /tmp/pcapitate_tmp $strOutFile
fi

exit
