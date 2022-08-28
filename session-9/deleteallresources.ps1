param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME
)

Invoke-Command `
    -ArgumentList $RGNAME `
    -ScriptBlock {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $RGNAME
        )
        
        Write-Output "rgname: $RGNAME"

        $RESOURCES = @( Get-AzResource -ResourceGroupName $RGNAME )

        $LEN = $RESOURCES.Length

        $RESOURCES = @( $RESOURCES.Id )

        for (($i = 0); $i -lt $LEN; $i++)
        {
            Remove-AzResource -ResourceId $RESOURCES[$i] -Force
        }

        $ROUND2 = @( Get-AzResource -ResourceGroupName $RGNAME )

        $LEN2 = $ROUND2.Length

        $ROUND2 = @( $ROUND2.Id )

        for (($i = 0); $i -lt $LEN2; $i++)
        {
            Remove-AzResource -ResourceId $ROUND2[$i] -Force
        }
    }