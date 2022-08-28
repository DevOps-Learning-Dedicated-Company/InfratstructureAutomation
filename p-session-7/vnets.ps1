param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $LOCATION,

    [Parameter(Mandatory = $true)]
    [string]
    $VNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $ADDRESS,

    [Parameter(Mandatory = $true)]
    [string[]]
    $SUBNETS
)

Invoke-Command `
    -ArgumentList $RGNAME, $LOCATION, $VNAME, $ADDRESS, $SUBNETS `
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
            $VNAME,
        
            [Parameter(Mandatory = $true)]
            [string]
            $ADDRESS,

            [Parameter(Mandatory = $true)]
            [string[]]
            $SUBNETS
        )
        
        Write-Output "rgname: $RGNAME"
        Write-Output "location: $LOCATION"
        Write-Output "vnet name: $VNAME"
        Write-Output "vnet address space: $ADDRESS"
        Write-Output "subnets: $SUBNETS"

        New-AzResourceGroup -ResourceGroupName @RGNAME -Location @LOCATION

        $VNET = New-AzVirtualNetwork -Name $VNAME -ResourceGroupName $RGNAME -Location $LOCATION -AddressPrefix $ADDRESS

        for ($i = 0; $i -lt $SUBNETS.Length; $i += 2) 
        {
            Add-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $SUBNETS[$i] -AddressPrefix $SUBNETS[$i + 1]
            
            $VNET | Set-AzVirtualNetwork
        }
    }