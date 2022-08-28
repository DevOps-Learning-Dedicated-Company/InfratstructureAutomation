param (
    [Parameter(Mandatory = $true)]
    [string]
    $SERVICE,

    [Parameter(Mandatory = $true)]
    [string]
    $STORAGE,

    [Parameter(Mandatory = $true)]
    [string]
    $SCHEDULE,

    [Parameter(Mandatory = $true)]
    [string]
    $RETENTION,

    [Parameter(Mandatory = $false)]
    [string]
    $DATABASES
)

Invoke-Command `
    -ArgumentList $SERVICE, $STORAGE, $SCHEDULE, $RETENTION, $DATABASES `
    -ScriptBlock {
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $SERVICE,

            [Parameter(Mandatory = $true)]
            [string]
            $STORAGE,

            [Parameter(Mandatory = $true)]
            [string]
            $SCHEDULE,
        
            [Parameter(Mandatory = $true)]
            [string]
            $RETENTION,

            [Parameter(Mandatory = $false)]
            [string]
            $DATABASES
        )

        $RGNAME = "automated-powershell-group"
        
        Write-Output "rgname: $RGNAME"
        Write-Output "app name: $SERVICE"
        Write-Output "storage account name: $STORAGE"
        Write-Output "schedule: $SCHEDULE"
        Write-Output "retention policy: $RETENTION"

        $CON = New-AzStorageContext -StorageAccountName $STORAGE

        New-AzStorageContainer -Name "backupcontainer01" -Context $CON

        $SASURL = New-AzStorageContainerSASToken -Name "backupcontainer01" -Permission rwdl `
        -Context $CON -ExpiryTime (Get-Date).AddDays(7) -FullUri


        if ($DATABASES)
        {
            Edit-AzWebAppBackupConfiguration -ResourceGroupName $RGNAME -Name $SERVICE `
            -StorageAccountUrl $SASURL -FrequencyInterval $SCHEDULE -FrequencyUnit Day -KeepAtLeastOneBackup `
            -StartTime (Get-Date).AddMinutes(5) -RetentionPeriodInDays $RETENTION -Databases $DATABASES
        }
        else 
        {
            Edit-AzWebAppBackupConfiguration -ResourceGroupName $RGNAME -Name $SERVICE `
            -StorageAccountUrl $SASURL -FrequencyInterval $SCHEDULE -FrequencyUnit Day -KeepAtLeastOneBackup `
            -StartTime (Get-Date).AddMinutes(5) -RetentionPeriodInDays $RETENTION
        }
    }