param
(
    [Parameter(Mandatory=$true)]
    $resourceGroupName='ToDoApp87f7'
)

Login-AzureRmAccount
Remove-AzureRmResourceGroup -name $resourceGroupName 
