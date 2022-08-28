param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $LOCATION,

    [Parameter(Mandatory = $true)]
    [string]
    $PLANNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $NOW,
    
    [Parameter(Mandatory = $true)]
    [string]
    $PRICING,

    [Parameter(Mandatory = $true)]
    [string]
    $IMAGE,

    [Parameter(Mandatory = $true)]
    [string]
    $APPNAME
)

Invoke-Command `
    -ArgumentList $RGNAME, $LOCATION, $PLANNAME, $NOW, $PRICING, $IMAGE, $APPNAME `
    -ScriptBlock {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $RGNAME,

            [Parameter(Mandatory = $true)]
            [string]
            $LOCATION,

            [Parameter(Mandatory = $true)]
            [string]
            $PLANNAME,

            [Parameter(Mandatory = $true)]
            [string]
            $NOW,
            
            [Parameter(Mandatory = $true)]
            [string]
            $PRICING,
        
            [Parameter(Mandatory = $true)]
            [string]
            $IMAGE,
        
            [Parameter(Mandatory = $true)]
            [string]
            $APPNAME
        )
        
        Write-Output "rgname: $RGNAME"
        Write-Output "location: $LOCATION"
        Write-Output "app service plan name: $PLANNAME"
        Write-Output "number of workers: $NOW"
        Write-Output "pricing tier: $PRICING"
        Write-Output "docker image: $IMAGE"
        Write-Output "name of the app: $APPNAME"

        New-AzResourceGroup -Name $RGNAME -Location $LOCATION

        New-AzAppServicePlan -ResourceGroupName $RGNAME -Location $LOCATION -Name $PLANNAME -NumberofWorkers $NOW -Linux -Tier $PRICING
            
        New-AzWebApp -ResourceGroupName $RGNAME -Name $APPNAME -AppServicePlan $PLANNAME -ContainerImageName $IMAGE
    }