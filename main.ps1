#Import csv
$data = Import-CSV .\db.csv
$last = $data[-1]
#Merge Data
$pwd = "'pwd'"
$res_gr = "'res_gr'"
$aks_name = "'aks_name'"
$nodes_min = "'nodes_min'"
$nodes_max = "'nodes_max'"
$os = "'os'"
$instance_name = "'instance_name'"
#Merge Variables
$RESOURCE_GROUP=$last.$res_gr
$AKS_CLUSTER=$last.$aks_name
$nodes_min_int=$last.$nodes_min
$nodes_max_int=$last.$nodes_max
$Username = 'secmasterfmo'
$Password = $last.$pwd
$PWord = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $PWord
#Password from CSV to secure string

#Nodes min/max from CSV to int
$node_count_min=[int]$nodes_min_int
$node_count_max=[int]$nodes_max_int

#Merge Variables continuation
$OsType=$last.$os
$nazwa_instancji=$last.$instance_name
#Main Script
#$WorkspaceName = "log-analytics-HACKATHON-" + (Get-Random -Maximum 99999) # workspace names need to be unique in resource group - Get-Random helps with this for the example code
$WorkspaceName = "log-analytics-HACKATHON-46555"
#New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku PerGB2018 -ResourceGroupName $RESOURCE_GROUP

New-AzAksCluster -ResourceGroupName $RESOURCE_GROUP -Name $AKS_CLUSTER -NodeCount 2 -EnableNodeAutoScaling -NodeMinCount $node_count_min -NodeMaxCount $node_count_max -NetworkPlugin azure -NodeVmSetType VirtualMachineScaleSets -WindowsProfileAdminUserName $Credential.UserName -WindowsProfileAdminUserPassword $Credential.Password | Enable-AzAksAddon -Name Monitoring -workspaceresourceid (get-AzOperationalInsightsWorkspace -name $WorkspaceName -resourcegroup $RESOURCE_GROUP).ResourceID
Start-Sleep -Seconds 10
New-AzAksNodePool -ResourceGroupName $RESOURCE_GROUP -ClusterName $AKS_CLUSTER -VmSetType VirtualMachineScaleSets -OsType $OsType -Name $nazwa_instancji -EnableAutoScaling -mincount $node_count_min -maxcount $node_count_max
