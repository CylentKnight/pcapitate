######################################################################################
# Pcapitate.sh must be installed on the remote linux machine. In addition, plink.exe #
# and pscp.exe (included with PuTTY) must also be installed. See inline comments for #
# hardcoded paths which may need to change depending on individual architectures     #
######################################################################################

Add-Type -AssemblyName System.Windows.Forms

Function btnBrowse_Click {
  $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
  $saveFileDialog.InitialDirectory = [System.IO.Directory]::GetCurrentDirectory()
  $saveFileDialog.Title = "Save Output As"
  $saveFileDialog.Filter = "PCAP Files (*.pcap)|*.pcap"
  $saveFileDialog.ShowHelp = $True
  $saveFilePath = $saveFileDialog.ShowDialog()
  if($saveFilePath -eq "OK") {
    $filePathTextBox.Text = $saveFileDialog.FileName
  }
}

Function btnOk_Click {

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

  $rhost = $dropDownBox.SelectedItem.ToString()
  $uname = $userNameTextBox.Text
  $pword = $maskedTextBox.Text
  $startTime = $datePicker1.Text
  $stopTime = $datePicker2.Text
  $IPQuery = $ipFilterTextBox.Text
  $ldest = $filePathTextBox.Text

  if ($IPQuery > "") {
    $execCommand = @('/usr/bin/pcapitate.sh -a ' + $startTime + ' -b ' + $stopTime + ' -i' + $IPQuery + '-o /tmp/pcapitator.pcap') #point to pcapitate location on remote linux machine
  } else {
    $execCommand = @('/usr/bin/pcapitate.sh -a ' + $startTime + ' -b ' + $stopTime + ' -o /tmp/pcapitator.pcap') #point to pcapitate location on remote linux machine
  }
  
  $statusBar.Text = "[+] Beginning Extraction. Please wait..."
  plink -ssh $rhost -l $uname -pw $pword $execCommand
  $statusBar.Text = Extraction Complete. Beginning File Transfer"
  pscp -l $uname -pw $pword ${rhost}:/tmp/pcapitator.pcap $ldest
  $statusBar.Text = "[+] Cleaning up.
  plink -ssh $rhost -l $uname -pw $pword rm /tmp/pcapitator.pcap
  $pword="OVERWRITE"
}

$rhost = ""
$startTime = ""
$stopTime = ""

$form = New-Object System.Windows.Forms.Form
  $form.Text = "Pcapitator"
  $form.Width = "500"
  $form.Height = "430"

<### FONT OPTIONS ###>
#$font = new-Object System.Drawing.Font("Lucida Sans",12)
#$form.font = $font

<### COLOR OPTIONS ###>
#$form.ForeColor = "Crimson"
#$form.BackColor = "DarkGray"

$linuxIPArray = @("192.168.1.10","192.168.1.20","192.168.1.30")

$dropDownLabel = New-Object System.Windows.Forms.Label
  $dropDownLabel.Text = "Host Machine IP"
  $dropDownLabel.Location = "15,20"
  $dropDownLabel.Height = "22"
  $dropDownLabel.Width = "90"
  $form.Controls.Add($dropDownLabel)
  
$dropDownBox = New-Object System.Windows.Forms.ComboBox
  $dropDownBox.Location = New-Object System.Drawing.Size(110,20)
  $dropDownBox.Size = New-Object System.Drawing.Size(200,20)
  $dropDownBox.DropDownHeight = 200
  $form.Controls.Add($dropDownBox)
  
foreach ($IP in $linuxIPArray) {
  $dropDownBox.Items.Add($IP)
}

$datePickerLabel1 = New-Object System.Windows.Forms.Label
  $datePickerLabel1.Text = "Start time (YYYY-MM-DD HH:mm:ss)"
  $datePickerLabel1.Location - "110,60"
  $datePickerLabel1.Height = "22"
  $datePickerLabel1.Width = "90
  $form.Controls.Ass($datePickerLabel1)
  
$datePicker1 = New Object System.Windows.Forms.DateTimePicker
  $datePicker1.Location = "110,60"
  $datePicker1.Width = "200"
  $datePicker.Format = [Windows.Forms.DateTimePickerFormat]::custom
  $datePicker1.CustomFormat = "yyyy-MM-DD HH:mm:ss"
  
  #TO BE CONTINUED



