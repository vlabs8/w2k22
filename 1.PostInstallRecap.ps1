# Post installation tasks

# Activation

# To activate a server with gui run:
start slui

# For the administration and querying of license information on Windows Server 2022 computers, Microsoft provides the SLMGR.VBS script, which you # can run with different options:
# /ato - Activate Windows online
# /dli - Displays the current license information
# /dlv - shows even more license details
# /dlv all - shows detailed information for all installed licenses
# Lets  display the status of activating Windows Server 2022, by entering:
slmgr /dli

# You can also use dism command
# For example, to view the currently installed edition run:
dism /online /Get-CurrentEdition

# Check driver installation:
devmgmt.msc 

#You can use the msinfo32 command to get a very detailed overview of a PC's built-in hardware and:
msinfo32

# Use the systemInfo command to display all of your computer's information in the command prompt. 
# To save it to a file run:
systeminfo /FO list > C:\sysinfo.txt

# The quickest way to view network card settings is to run:
ncpa.cpl 

# To install language packs, run:
lpksetup

# To Disable Media Player, run:
dism /online /Disable-Feature /FeatureName:WindowsMediaPlayer /norestart

# Run System Properties to rename a computer, add it to domain and enable remoting with:
sysdm.cpl 

# Check for connected users with:
qwinsta

# To repair the boot manager, try these commands:
bcdboot C:\Windows /s C: /f BIOS
bootsect.exe /nt60 ALL /force
bootsect.exe /nt60 C: /mbr /force

# To install git run: 
start msedge https://git-scm.com/download/win

# To run sysprep:
sl C:\Windows\System32\sysprep
.\sysprep.exe /oobe /generalize /shutdown /mode:vm









