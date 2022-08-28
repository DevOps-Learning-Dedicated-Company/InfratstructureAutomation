param (
    [Parameter(Mandatory = $true)]
    [string]
    $RGNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $LOCATION,

    [Parameter(Mandatory = $true)]
    [string]
    $IMAGE,

    [Parameter(Mandatory = $true)]
    [string]
    $NAME,

    [Parameter(Mandatory = $true)]
    [string]
    $VNETNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $SNAME,

    [Parameter(Mandatory = $true)]
    [string]
    $SIZE,

    [Parameter(Mandatory = $false)]
    [string]
    $DNS,

    [Parameter(Mandatory = $false)]
    [string]
    $IP
)

Invoke-Command `
    -ArgumentList $RGNAME, $LOCATION, $IMAGE, $NAME, $VNETNAME, $SNAME, $SIZE, $DNS, $IP `
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
            $IMAGE,
        
            [Parameter(Mandatory = $true)]
            [string]
            $NAME,
        
            [Parameter(Mandatory = $true)]
            [string]
            $VNETNAME,
        
            [Parameter(Mandatory = $true)]
            [string]
            $SNAME,
        
            [Parameter(Mandatory = $true)]
            [string]
            $SIZE,
        
            [Parameter(Mandatory = $false)]
            [string]
            $DNS,
        
            [Parameter(Mandatory = $false)]
            [string]
            $IP
        )
        
        Write-Output "rgname: $RGNAME"
        Write-Output "location: $LOCATION"
        Write-Output "image: $IMAGE"
        Write-Output "vm name: $NAME"
        Write-Output "vnet name: $VNETNAME"
        Write-Output "subnet name: $SNAME"
        Write-Output "size of the vm: $SIZE"
        Write-Output "dns: $DNS"
        Write-Output "IP address: $IP"

        $VMLocalAdminUser = "LocalAdminUser"
        $VMLocalAdminSecurePassword = ConvertTo-SecureString "Thisismyvmpassword1" -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

        if ($DNS -and $IP)
        {
            New-AzVM -VM $VM -ResourceGroupName $RGNAME -Location $LOCATION -ImageName $IMAGE -Name $NAME `
            -VirtualNetworkName $VNETNAME -SubnetName $SNAME -Size $SIZE -Credential $Credential `
            -DatadiskDeleteOption Delete -NetworkInterfaceDeleteOption Delete -OSDiskDeleteOption Delete `
            -PublicIpAddressName $IP -AllocationMethod Static -DomainNameLabel $DNS -Verbose
        }
        elseif ($DNS -and ($IP -eq $null)) 
        {
            New-AzVM -ResourceGroupName $RGNAME -Location $LOCATION -ImageName $IMAGE -Name $NAME `
            -VirtualNetworkName $VNETNAME -SubnetName $SNAME -Size $SIZE -Credential $Credential `
            -DatadiskDeleteOption Delete -NetworkInterfaceDeleteOption Delete -OSDiskDeleteOption Delete `
            -DomainNameLabel $DNS -Verbose
        }
        elseif (($DNS -eq $null) -and $IP) 
        {
            New-AzVM -ResourceGroupName $RGNAME -Location $LOCATION -ImageName $IMAGE -Name $NAME `
            -VirtualNetworkName $VNETNAME -SubnetName $SNAME -Size $SIZE -Credential $Credential `
            -DatadiskDeleteOption Delete -NetworkInterfaceDeleteOption Delete -OSDiskDeleteOption Delete `
            -PublicIpAddressName $IP -AllocationMethod Static -Verbose
        }
        else 
        {
            New-AzVM -ResourceGroupName $RGNAME -Location $LOCATION -ImageName $IMAGE -Name $NAME `
            -VirtualNetworkName $VNETNAME -SubnetName $SNAME -Size $SIZE -Credential $Credential `
            -DatadiskDeleteOption Delete -NetworkInterfaceDeleteOption Delete -OSDiskDeleteOption Delete `
            -Verbose
        }

    }

# $VMLocalAdminUser = "LocalAdminUser"
# $VMLocalAdminSecurePassword = ConvertTo-SecureString "Thisismyvmpassword1" -AsPlainText -Force
# $Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

# $agents = @{
#     ResourceGroupName = 'build-agents-01-automated'
#     Location = 'ukwest'
#     ImageName = 'UbuntuLTS'
#     VirtualNetworkName = 'agents-vnet'
#     SubnetName = 'agents-subnet'
#     Size = 'Standard_DS1_v2'
#     Credential = $Credential
#     DomainNameLabel = 'custom-public-domain-name'
#     DataDiskDeleteOption = 'Delete'
#     NetworkInterfaceDeleteOption = 'Delete'
#     OSDiskDeleteOption = 'Delete'
#     SecurityGroupName = 'agents-NSG'
# }

# $jumpbox = @{
#     ResourceGroupName = 'build-agents-01-automated'
#     Location = 'ukwest'
#     ImageName = 'Win2019Datacenter'
#     VirtualNetworkName = 'agents-vnet'
#     SubnetName = 'agents-subnet'
#     Size = 'Standard_DS1_v2'
#     Credential = $Credential
#     DataDiskDeleteOption = 'Delete'
#     NetworkInterfaceDeleteOption = 'Delete'
#     OSDiskDeleteOption = 'Delete'
#     SecurityGroupName = 'jumpbox-NSG'
#     PublicIpAddressName = 'reserved-jumpbox-ip'
#     AllocationMethod = 'Static'
# }

# for (($i = 1); $i -le 3; $i++)
# {
#     $VM = New-AzVM @agents -Name "agent-0$i"
#     Set-AzVMOSDisk -Name standardHDDdisk -StorageAccountType Standard_LRS -VM $VM
# }# for loop creating 3 ubuntu agents with standard HDD disks

# $jumpbox = New-AzVM @jumpbox -Name 'jumpbox-01'
# Set-AzVMOSDisk -Name standardHDDdisk -StorageAccountType Standard_LRS -VM $jumpbox