import-Module WebAdministration

#setting current working path to get scripts and json files
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

# reading and creating dynamic key value strings
Foreach ($i in $(Get-Content $dir/config.env)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

#take IIS site config backup
$fileDateTime = $(get-date -f "MM_dd_yyyy__HH_mm_ss")
Backup-WebConfiguration -Name myIISBackup_$fileDateTime
#C:\Windows\System32\inetsrv\backup
#Restore-WebConfiguration -Name myIISBackup

#(Get-ItemProperty 'IIS:\Sites\site-1\' -Name logfile).logExtFileFlags
#Set-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName" }

$LogPath = $backuppath
foreach($site in (dir iis:\sites\*))
{
New-Item $LogPath\$($site.Name) -type directory
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.directory -value "$LogPath\$($site.Name)"
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.truncateSize -value "10485760"
Set-ItemProperty IIS:\Sites\$($site.Name) -name logfile.logTargetW3C  -Value "File,ETW"
## (Get-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile).logExtFileFlags
Set-ItemProperty IIS:\Sites\$($site.Name) -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName,SiteName,ComputerName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,Cookie,Referer,ProtocolVersion,Host,HttpSubStatus"}
}

