param (
    [Parameter(Mandatory = $true)]
    [string]
    $LOCATION,

    [Parameter(Mandatory = $true)]
    [string]
    $STORAGE,

    [Parameter(Mandatory = $true)]
    [string]
    $PRICING
)

Invoke-Command `
    -ArgumentList $LOCATION, $STORAGE, $PRICING `
    -ScriptBlock {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $LOCATION,

            [Parameter(Mandatory = $true)]
            [string]
            $STORAGE,
        
            [Parameter(Mandatory = $true)]
            [string]
            $PRICING
        )

        $RGNAME = "automated-powershell-group"
        
        Write-Output "rgname: $RGNAME"
        Write-Output "location: $LOCATION"
        Write-Output "storage account name: $STORAGE"
        Write-Output "pricing tier: $PRICING"

        New-AzResourceGroup -Name $RGNAME -Location $LOCATION

        $STORAGE = New-AzStorageAccount -ResourceGroupName $RGNAME -Name $STORAGE -Location $LOCATION -SkuName $PRICING
    }