#!/bin/bash

#####################################################################################
#       ~~~~~~~~~~~~~~~~~~~~~~~~~~~PCAPITATE~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#       ~~~~~~~~~~~~~~~~~~~~~~~By: CylentKnight~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#      Version 1.0: Crude but functional, requires 6 static arguments to include    #
# start date, start time, end date, end time, IP to filter, and Output Destination. #
#####################################################################################

strStartDate=$1
strStartTime=$2
strEndDate=$3
strEndTime=$4
strHost=$5
strOutFile=$6

cp /data/TCPDumpLog/pcap /tmp/pcap_copy #change this to the path of your live tcpdump file
/usr/bin/editcap -A """$strStartDate $strStartTime""" -B """$strEndDate $strEndTime""" /tmp/pcap_copy /tmp/pcap_tmp &>/dev/null
rm /tmp/pcap_copy
/usr/bin/tcpdump -nnvvX -r /tmp/pcap_tmp host $strHost -w $strOutFile &>/dev/null
rm /tmp/pcap_tmp

exit
