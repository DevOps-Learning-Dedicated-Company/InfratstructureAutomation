param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $NSGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $VNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $SNAME
)

Invoke-Command `
    -ArgumentList $RGNAME, $NSGNAME, $VNAME, $SNAME `
    -ScriptBlock {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $RGNAME,

            [Parameter(Mandatory = $true)]
            [string]
            $NSGNAME,

            [Parameter(Mandatory = $true)]
            [string]
            $VNAME,

            [Parameter(Mandatory = $true)]
            [string]
            $SNAME
        )
        
        Write-Output "rgname: $RGNAME"
        Write-Output "vnet name: $VNAME"
        Write-Output "nsg name: $NSGNAME"
        Write-Output "subnet name: $SNAME"

        $VNET = Get-AzVirtualNetwork -Name $VNAME -ResourceGroupName $RGNAME

        $NSG = Get-AzNetworkSecurityGroup -Name $NSGNAME -ResourceGroupName $RGNAME

        $SUBNET = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $SNAME

        Set-AzVirtualNetworkSubnetConfig -Name $SUBNET.Name -VirtualNetwork $VNET -AddressPrefix $SUBNET.AddressPrefix -NetworkSecurityGroup $NSG
        Set-AzVirtualNetwork -VirtualNetwork $VNET
    }