param
(
    $resourceGroupName='ToDoApp87f7',
    $deploymentName='ToDoAppDeploy',
    $resourceGroupLocation='East US',
    $subscriptionID='85e6739d-a925-4590-9eee-b55d4a9c9947',
    $templateFilePath=".\ToDotemplate.json",
    $parameterFile=".\ToDoparameters.json"
)

function ConvertFrom-AzureParameterFile {
    param($parameterFile)

    $p=(Get-Content $parameterFile | ConvertFrom-Json).parameters

    $propertyNames = ($p | Get-Member -MemberType NoteProperty).Name

    $h=@{}
    foreach ($name in $propertyNames) {
        $h.$name=$p.$name.value
    }
    $h
}

$rh=ConvertFrom-AzureParameterFile $parameterFile
$rh.sqlServerAdminPassword = ConvertTo-SecureString $rh.sqlServerAdminPassword -AsPlainText -Force

Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionID $subscriptionId
New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath @rh -Name $deploymentName