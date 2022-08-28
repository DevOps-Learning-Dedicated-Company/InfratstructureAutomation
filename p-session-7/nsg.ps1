param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $LOCATION,

    [Parameter(Mandatory = $true)]
    [string]
    $NAME,

    [Parameter(Mandatory = $false)]
    [string[]]
    $RULES
)

Invoke-Command `
    -ArgumentList $RGNAME, $LOCATION, $NAME, $RULES `
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
            $NAME,

            [Parameter(Mandatory = $true)]
            [string[]]
            $RULES
        )
        
        Write-Output "rgname: $RGNAME"
        Write-Output "location: $LOCATION"
        Write-Output "nsg name: $NAME"
        Write-Output "rules: $RULES"

        for ($i = 0; $i -lt $RULES.Length; $i += 9)
        {
        $R = New-AzNetworkSecurityRuleConfig -Name $RULES[$i] -Access $RULES[$i+1] -Protocol $RULES[$i+2] `
                -Direction $RULES[$i+3] -SourcePortRange $RULES[$i+4] -DestinationPortRange $RULES[$i+5] `
                -SourceAddressPrefix $RULES[$i+6] -DestinationAddressPrefix $RULES[$i+7] -Priority $RULES[$i+8]

        New-AzNetworkSecurityGroup -ResourceGroupName $RGNAME -Location $LOCATION -name $NAME -SecurityRules $R
        }
    }
