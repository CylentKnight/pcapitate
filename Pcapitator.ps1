######################################################################################
# Pcapitate.sh must be installed on the remote linux machine. In addition, plink.exe #
# and pscp.exe (included with PuTTY) must also be installed. See inline comments for #
# hardcoded paths which may need to change depending on individual architectures     #
######################################################################################

clear
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~PCAPITATOR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~~~~~~~~~~~~~~~~~~~~~By: CylentKnight~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "  Ver 1.0: Quickly extract TCPDump data from a remote linux machine"
echo " filtered by time and host IP (both source and destination). Output"
echo "  will be automatically delivered to the local destination of your"
echo "                           choosing"
echo ""

$plinkPath = "C:\Program Files\Putty_0.68_x64\plink.exe" #point this to the location of plink.exe
If (Test-Path $plinkPath) {
  Set-Alias plink $plinkPath
} else {
  Throw "ERROR: plink.exe not found"
}
$pscpPath = "C:\Program Files\Putty_0.68_x64\pscp.exe"  #point this to the location of pscp.exe
If (Test-Path $pscpPath) {
} else {
  Throw "ERROR: pscp.exe not found"
}

$rhost = Read-Host "Source IP"
$uname = Read-Host "Username"
$pword = Read-Host "Password" -AsSecureString
$pword = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword)
$pword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($pword)
$startTime = Read-Host "Start Time (YYYY-MM-DD hh:mm:ss)"
$stopTime = Read-Host "End Time (YYYY-MM-DD hh:mm:ss)"
$IPQuery = Read-Host "IP to Filter"
$ldest = Read-Host "Destination path and filename"

$execCommand = @('/usr/bin/pcapitate.sh ' + $startTime + ' ' + $stopTime + ' ' + $IPQuery + ' /tmp/pcapitator.pcap') #point to pcapitate location on remote linux machine
echo "[+] Beginning Extraction. Please wait..."
plink -ssh $rhost -l $uname -pw $pword $execCommand
echo "[+] Extraction Complete. Beginning File Transfer"
pscp -l $uname -pw $pword ${rhost}:/tmp/pcapitator.pcap $ldest
echo "[+] Cleaning up.
plink -ssh $rhost -l $uname -pw $pword rm /tmp/pcapitator.pcap
$pword="OVERWRITE"
