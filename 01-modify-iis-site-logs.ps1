import-Module WebAdministration
$iissites = Get-Website | Where-Object {$_.Name -ne "Default Web Site" -and  $_.State -ne "Stopped"} 
#setting current working path to get scripts and json files
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$LogPath = $backuppath
$fileDateTime = $(get-date -f "MM_dd_yyyy__HH_mm_ss")
# reading and creating dynamic key value strings
Foreach ($i in $(Get-Content $dir/config.env)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

#take IIS site config backup

Backup-WebConfiguration -Name myIISBackup_$fileDateTime
#C:\Windows\System32\inetsrv\backup
#Restore-WebConfiguration -Name myIISBackup

#(Get-ItemProperty 'IIS:\Sites\site-1\' -Name logfile).logExtFileFlags
#Set-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName" }


foreach($site in ($iissites ))
{
New-Item $LogPath\$($site.Name) -type directory
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.directory -value "$LogPath\$($site.Name)"
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.truncateSize -value (truncateSize)
Set-ItemProperty IIS:\Sites\$($site.Name) -name logfile.logTargetW3C  -Value ($logTargetW3C)
## (Get-ItemProperty 'IIS:\Sites\Default Web Site\' -Name logfile).logExtFileFlags
Set-ItemProperty IIS:\Sites\$($site.Name) -Name logfile -Value @{logExtFileFlags = "Date,Time,ClientIP,UserName,SiteName,ComputerName,ServerIP,Method,UriStem,UriQuery,HttpStatus,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,Referer,ProtocolVersion,Host,HttpSubStatus"}
}

if ($xforwarded) 
{
## Enabling X-Forwarded-For for Loadbalancer
Add-WebConfigurationProperty -PSPath 'MACHINE/WEBROOT/APPHOST' `
     -Filter "system.applicationHost/sites/siteDefaults/logFile/customFields" `
     -Name "." `
     -Value @{logFieldName='X-Forwarded-For';sourceName='X-Forwarded-For';sourceType='RequestHeader'}
}