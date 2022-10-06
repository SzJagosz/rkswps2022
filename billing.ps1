#install-module az.resources
#install-module az.billing

$data = Import-CSV .\billing_db.csv
$last = $data[-1]

$start_date = "'start_date'"
$end_date = "'end_date'"

$start=$last.$start_date
$end=$last.$end_date

$azure_billing_data = Get-AzConsumptionUsageDetail -ResourceGroup ing-hackathon-rg -StartDate $start -EndDate $end | sort PretaxCost -Descending | select *, @{n='ResType';e={(Get-AzResource -ResourceId $_.InstanceId).ResourceType}} 


$azure_billing_group_instance = $azure_billing_data | Group-Object InstanceName | Select-Object name, @{ n='Count'; e={$_.count } }, @{ n='Cost(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Sum).Sum),2) } }, @{ n='CostAV(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Average).Average ),2) }}, @{ n='ResType'; e={ $_.Group.ResType | select -First 1  }}

$azure_billing_group_type = $azure_billing_data | Group-Object ResType | Select-Object name,@{ n='Type'; e={(($_.name).split('.')[1]).split('/')[0] } },@{ n='Component'; e={($_.name).split('/')[1] } }, @{ n='Count'; e={$_.count } }, @{ n='Cost(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Sum).Sum),2) } }, @{ n='CostAV(EUR)'; e={ [math]::Round((($_.Group | Measure-Object 'PretaxCost' -Average).Average ),2) }} | select * -ExcludeProperty Name


$azure_billing_data |Export-Csv  -NoTypeInformation -Path ".\billing.csv" -Delimiter ';'