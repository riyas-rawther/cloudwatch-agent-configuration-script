import-Module WebAdministration
#(Get-ItemProperty 'IIS:\Sites\site-1\' -Name logfile).logExtFileFlags
#Set-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName" }

$LogPath = “C:\logs\IIS-LogFiles”
foreach($site in (dir iis:\sites\*))
{
New-Item $LogPath\$($site.Name) -type directory
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.directory -value “$LogPath\$($site.Name)”
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.truncateSize -value "10485760"
Set-ItemProperty IIS:\Sites\$($site.Name) -name logfile.logTargetW3C  -Value "File,ETW"
## (Get-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile).logExtFileFlags
Set-ItemProperty IIS:\Sites\$($site.Name) -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName,SiteName,ComputerName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,Cookie,Referer,ProtocolVersion,Host,HttpSubStatus"}
}

