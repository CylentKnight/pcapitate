######################################################################################
# Pcapitate.sh must be installed on the remote linux machine. In addition, plink.exe #
# and pscp.exe (included with PuTTY) must also be installed. See inline comments for #
# hardcoded paths which may need to change depending on individual architectures     #
######################################################################################

Add-Type -AssemblyName System.Windows.Forms

Function btnBrowse_Click {
<### Initiates a SaveAs Dialog Box ###>
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
<### Performs the primary task of interfacing with pcapitate.sh ###>
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
<### Retrieved necessary information from form ###>
  $rhost = $dropDownBox.SelectedItem.ToString()
  $uname = $userNameTextBox.Text
  $pword = $maskedTextBox.Text
  $startTime = $datePicker1.Text
  $stopTime = $datePicker2.Text
  $IPQuery = $ipFilterTextBox.Text
  $ldest = $filePathTextBox.Text
<### Builds the command string ###> 
  if ($IPQuery > "") {
    $execCommand = @('/usr/bin/pcapitate.sh -a ' + $startTime + ' -b ' + $stopTime + ' -i' + $IPQuery + '-o /tmp/pcapitator.pcap') #point to pcapitate location on remote linux machine
  } else {
    $execCommand = @('/usr/bin/pcapitate.sh -a ' + $startTime + ' -b ' + $stopTime + ' -o /tmp/pcapitator.pcap') #point to pcapitate location on remote linux machine
  }
<### Connects to target machine via SSH to execute pcapitate.sh ###>
  $statusBar.Text = "[+] Beginning Extraction. Please wait..."
  plink -ssh $rhost -l $uname -pw $pword $execCommand
  $statusBar.Text = Extraction Complete. Beginning File Transfer"
  pscp -l $uname -pw $pword ${rhost}:/tmp/pcapitator.pcap $ldest
  $statusBar.Text = "[+] Cleaning up.
  plink -ssh $rhost -l $uname -pw $pword rm /tmp/pcapitator.pcap
  $pword="OVERWRITE"
}
<### Execution begins here ###>
$rhost = ""
$startTime = ""
$stopTime = ""

<### From here down builds the GUI ###>
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

<### Combo Box is used to store multiple linux machines ###>
$dropDownBox = New-Object System.Windows.Forms.ComboBox
  $dropDownBox.Location = New-Object System.Drawing.Size(110,20)
  $dropDownBox.Size = New-Object System.Drawing.Size(200,20)
  $dropDownBox.DropDownHeight = 200
  $form.Controls.Add($dropDownBox)
  
<### Populates the Combo Box ###>  
foreach ($IP in $linuxIPArray) {
  $dropDownBox.Items.Add($IP)
}

<### Text Box option to replace Combo Box if desired ###>
#$targetTextBox = New-Object System.Windows.Forms.TextBox
#  $targetTextBox.Text = "Ex. 192.168.1.1"
#  $targetTextBox.Location = "110,20"
#  $targetTextBox.Size = "200,22"
#  $form.Controls.Add($targetTextBox)

$datePickerLabel1 = New-Object System.Windows.Forms.Label
  $datePickerLabel1.Text = "Start time (YYYY-MM-DD HH:mm:ss)"
  $datePickerLabel1.Location - "110,60"
  $datePickerLabel1.Height = "22"
  $datePickerLabel1.Width = "90
  $form.Controls.Add($datePickerLabel1)
  
$datePicker1 = New Object System.Windows.Forms.DateTimePicker
  $datePicker1.Location = "110,60"
  $datePicker1.Width = "200"
  $datePicker1.Format = [Windows.Forms.DateTimePickerFormat]::custom
  $datePicker1.CustomFormat = "yyyy-MM-DD HH:mm:ss"
  $datePicker1.ShowUpDown = $FALSE
  $datePicker1.ShowCheckBox = $FALSE
  $form.Controls.Add($datePicker1)
  
$datePickerLabel2 = New-Object System.Windows.Forms.Label
  $datePickerLabel2.Text = "Start time (YYYY-MM-DD HH:mm:ss)"
  $datePickerLabel2.Location - "15,100"
  $datePickerLabel2.Height = "22"
  $datePickerLabel2.Width = "90
  $form.Controls.Add($datePickerLabel2)
  
$datePicker2 = New Object System.Windows.Forms.DateTimePicker
  $datePicker2.Location = "110,100"
  $datePicker2.Width = "200"
  $datePicker2.Format = [Windows.Forms.DateTimePickerFormat]::custom
  $datePicker2.CustomFormat = "yyyy-MM-DD HH:mm:ss"
  $datePicker2.ShowUpDown = $FALSE
  $datePicker2.ShowCheckBox = $FALSE
  $form.Controls.Add($datePicker2)

$ipFilterLabel = New-Object System.Windows.Forms.Label
  $ipFilterLabel.Text = "IP Filter"
  $ipFilterLabel.Location = "15,140"
  $ipFilterLabel.Height = "22"
  $ipFilterLabel.Width = "90"
  $form.Controls.Add($ipFilterLabel)
  
$ipFilterTextBox = New-Object System.Windows.Forms.TextBox
  $ipFilterTextBox.Text = "(optional)"
  $ipFilterTextBox.Location = "110,140"
  $ipFilterTextBox.Height = "22"
  $ipFilterTextBox.Width = "150"
  $form.Controls.Add($ipFilterTextBox)
  
$userNameLabel = New-Object System.Windows.Forms.Label
  $userNameLabel.Text = "User Name"
  $userNameLabel.Location = "15,180"
  $userNameLabel.Height = "22"
  $userNameLabel.Width = "90"
  $form.Controls.Add($userNameLabel)

$userNameTextBox = New-Object System.Windows.Forms.TextBox
  $userNameTextBox.Text = $Env:USERNAME
  $userNameTextBox.Location = "110,180"
  $userNameTextBox.Height = "22"
  $userNameTextBox.Width = "300"
  $form.Controls.Add($userNameTextBox)
  
$maskedLabel = New-Object System.Windows.Forms.Label
  $maskedLabel.Text = "Password"
  $maskedLabel.Location = "15,220"
  $maskedLabel.Size = "90,22"
  $form.Controls.Add($maskedLabel)
  
$maskedTextBox = New-Object System.Windows.Forms.MaskedTextBox
  $maskedTextBox.PasswordChar = "*"
  $maskedTextBox.Location = "110,220"
  $maskedTextBox.Size = "300,22"
  $form.Controls.Add($maskedTextBox)
  
$filePathLabel = New-Object System.Windows.Forms.Label
  $filePathLabel.Text = "Save As"
  $filePathLabel.Location = "15,260"
  $filePathLabel.Height = "22"
  $filePathLabel.Width = "90"
  $form.Controls.Add($filePathLabel)
  
$filePathTextBox = New-Object System.Windows.Forms.TextBox
  $filePathTextBox.Text = "C:\Users\" + $Env:USERNAME + "\Documents\pcap1.pcap"
  $filePathTextBox.Location = "110,260"
  $filePathTextBox.Height = "22"
  $filePathTextBox.Width = "300"
  $form.Controls.Add($filePathTextBox)
  
$btnBrowse = New-Object System.Windows.Forms.Button
  $btnBrowse.Text = "Browse"
  $btnBrowse.Location = New-Object System.Drawing.Size(335,290)
  $btnBrowse.Size = New-Object System.Drawing.Size(75,30)
  $form.Controls.Add($btnBrowse)
  
$btnOK = New-Object System.Windows.Forms.Button
  $btnOK.Text = "Get PCAP"
  $btnOK.Location = "110,340"
  $btnOK.Size = "300,22"
  $btnOK.BackColor = "Red"
  $btnOK.ForeColor = "White"
  $form.Controls.Add($btnOK)
  
$statusBar = New-Object System.Windows.Forms.Label
  $statusBar.Text = ""
  $statusBar.Location = "5,370"
  $statusBar.Height = "22"
  $statusBar.Width = "490"
  $form.Controls.Add($statusBar)

<### Define the functios to be called on button clicks ###>
$btnBrowse.Add_Click({btnBrowse_Click})
$btnOK.Add_Click({btnOk_Click})

<### Show the form ###>
$form.ShowDialog()


