#setting current working path to get scripts and json files
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c file:$dir\json\amazon-cloudwatch-agent.json -s