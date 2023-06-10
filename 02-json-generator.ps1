$windowsLogs = @("Application", "System", "Security")
$windowsLoglevel = @("ERROR", "INFORMATION")
$instance = hostname
$iissites = Get-Website | Where-Object {$_.Name -ne "Default Web Site"}
$configfile = "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent.json"


$iislogs = @()
foreach ($site in $iissites) {
    $iislog = @{
        file_path = "C:\logs\IIS-LogFiles\$($site.id)\*.log"
        log_group_name = "/iis/$instance"
        log_stream_name = $($site.Name.ToLower())
        timestamp_format = "%Y-%m-%d %H:%M:%S"
        timezone = "UTC"
        encoding = "utf-8"
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
        log_stream_name = $instance
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

 
$json = $config | ConvertTo-Json -Depth 10 | Out-File .\acwa-logs.json

Write-Host "Merging two jsosn"

$data1 = Get-Content .\acwa-logs.json -Raw | ConvertFrom-Json 
$data2 = Get-Content .\acwa-matrices.json -Raw | ConvertFrom-Json 

@($data1; $data2) | ConvertTo-Json -Depth 10  | Out-File .\amazon-cloudwatch-agent.json

 