$windowsLogs = @("Application", "System", "Security")
$windowsLoglevel = @("ERROR", "INFORMATION")
$iissites = Get-Website | Where-Object {$_.Name -ne "Default Web Site"}

#setting current working path to get scripts and json files
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

# reading and creating dynamic key value strings
Foreach ($i in $(Get-Content $dir/config.env)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

$iislogs = @()
foreach ($site in $iissites) {
    $iislog = @{
        file_path = "$backuppath\$($site.name)\W3SVC$($site.id)\*.log"
        log_group_name = "/iis/$varhostname"
        log_stream_name = $($site.Name.ToLower())
        timestamp_format = "%Y-%m-%d %H:%M:%S"
        timezone = "UTC"
        encoding = "utf-8"
        retention_in_days = $iislogretention
    }
    $iislogs += $iislog
}
 
$winlogs = @()
foreach ($event in $windowsLogs) {
    $winlog = @{
        event_name = $event
        event_levels = $windowsLoglevel
        event_format ="text"
        log_group_name = "/eventlog/$($event.ToLower())"
        log_stream_name = $varhostname
        retention_in_days = $winlogretention
    }
    $winlogs += $winlog
}
 
$config = @{
    logs = @{
        logs_collected = @{
            files = @{
                collect_list = $iislogs
            }
            windows_events = @{
                collect_list = $winlogs
            }
        }
        log_stream_name = "generic-logs"
    }
    
}
 
# this could be any other location as long as it’s absolute

 
# $json = $config | ConvertTo-Json -Depth 10 | Out-File $dir\json\acwa-logs.json

# Write-Host "Merging two json"

# $data1 = Get-Content $dir\json\acwa-logs.json -Raw | ConvertFrom-Json 
# $data2 = Get-Content $dir\json\acwa-matrices.json -Raw | ConvertFrom-Json 

# @($data1; $data2) | ConvertTo-Json -Depth 10  | Out-File $dir\json\amazon-cloudwatch-agent.json

 