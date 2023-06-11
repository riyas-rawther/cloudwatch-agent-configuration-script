> You will need IIS and sites already configured.   
> Create log folder and add the path inside the config.env file   
> Run the 01-modify-iis-site-logs.ps1 file to backup and modify all sites    
> Run the 02-json-generator.ps1 file to generate the log config json file   
> Copy the content of the ./json/acwa-logs.json to https://codebeautify.org/json-fixer   
> switch to Tree view and add new objec to the bottom.   
> copy the content of the acwa-matrices.json file and manupulate it.   
> go to the required server's C:\Program Files\Amazon\AmazonCloudWatchAgent   
> copy the manupulated file to this dir   
> Shift right click and open the Powershell.   
>  ./amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c file:./jsonamazon-cloudwatch-agent.json -s   

# Retention in days

| Days |
|------|
| -1   |
| 1    |
| 3    |
| 5    |
| 7    |
| 14   |
| 30   |
| 60   |
| 90   |
| 120  |
| 150  |
| 180  |
| 365  |
| 400  |
| 545  |
| 731  |
| 1827 |
| 2192 |
| 2557 |
| 2922 |
| 3288 |
| 3653 |
