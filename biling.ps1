$start = ((get-date).AddDays(-1)).ToString("yyyy-MM-dd")
$end = (get-date).ToString("yyyy-MM-dd")

$start_date = "'start_date'"
$end_date = "'end_date'"

$azure_billing_data = Get-AzConsumptionUsageDetail -ResourceGroup ing-hackathon-rg -StartDate $start -EndDate $end | sort PretaxCost -Descending | Group-Object InstanceName | Select-Object name, @{ n='Count'; e={$_.count } }, @{ n='Cost(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Sum).Sum),2) } }, @{ n='CostAV(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Average).Average ),2) }}
$azure_billing_data |Export-Csv  -NoTypeInformation -Path ".\billing.csv" -Delimiter ';'
$cleaner = Get-Content .\billing_db.csv
$cleaner.Replace('","',",").TrimStart('"').TrimEnd('"') | Out-File .\billing_db.csv -Force -Confirm:$false