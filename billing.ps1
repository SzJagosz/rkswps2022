$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$data = Import-CSV .\billing_db.csv
$last = $data[-1]

$start_date = "'start_date'"
$end_date = "'end_date'"

$start=$last.$start_date
$end=$last.$end_date

$azure_billing_data = Get-AzConsumptionUsageDetail -ResourceGroup ing-hackathon-rg -StartDate $start -EndDate $end | sort PretaxCost -Descending | select *, @{n='ResType';e={(Get-AzResource -ResourceId $_.InstanceId).ResourceType}} 

$azure_billing_group_type = $azure_billing_data | Group-Object ResType | Select-Object name,@{ n='Type'; e={if($_.name){(($_.name).split('.')[1]).split('/')[0]}else{"Resource removed"} } },@{ n='Component'; e={if($_.name){($_.name).split('/')[1]}else{"Resource removed"} } }, @{ n='Count'; e={$_.count } }, @{ n='Cost (EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Sum).Sum),2) } }, @{ n='CostAV (EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Average).Average ),2) }} | select * -ExcludeProperty Name

$all_costs = ($azure_billing_group_type | Measure-Object 'Cost (EUR)' -Sum).sum

$final_costs = $azure_billing_group_type | select *, @{ n='Cost (%)'; e={[math]::Round( (($_.'Cost (EUR)'/$all_costs)*100) )}}
$final_costs | Export-Csv -Path ".\billing.csv" -NoTypeInformation -Force
#$all_costs = (($azure_billing_group_type | Measure-Object 'Cost (EUR)' -Sum).sum).ToString() | Out-File .\total.txt