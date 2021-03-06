#!powershell
#
# Header
#
# WANT_JSON
# POWERSHELL_COMMON
# Initialise module variables
$change=$false;
$myerror=$true;
$msg=@();

# Variabelise the arguments
$params = Parse-Args $args;

$Partition = @{}
$Volume = @{}
$Partition.DiskID = Get-AnsibleParam -obj $params -name "diskid" -failifempty $true
$Partition.driveletter = Get-AnsibleParam -obj $params -name "driveletter" -failifempty $true
#[int]$Partition.partitionsize = Get-AnsibleParam -obj $params -name "partitionsize" -failifempty $true -default 1
$Partition.partitionsize = Get-AnsibleParam -obj $params -name "partitionsize" -failifempty $true -default 1
$Partition.typedisk = Get-AnsibleParam -obj $params -name "typedisk" -failifempty $true -validateSet "GPT","MBR"
$Volume.FileSystem = Get-AnsibleParam -obj $params -name "filesystem" -validateSet "NTFS","ReFS","exFAT","FAT32","FAT" -default "NTFS"
$Volume.AllocationUnitSize = Get-AnsibleParam -obj $params -name "allocationunitsize" -validateSet "512","1024","2048","4096","8192","16384","32765","65536" -default "4096"
$Volume.NewFileSystemLabel = Get-AnsibleParam -obj $params -name "newfilesystemlabel" -failifempty $true 


#Check if disk exist
try
{
    $mydisk = Get-Disk | Where-Object {$_.Number -eq $Partition.diskid}
    if ( $mydisk -eq $null)
    {
        $result=New-Object psobject @{
        changed=$false
        failed=$true
        error=$true
        msg= "Disk: " + $Partition.diskid + " does not exist"
        }; 
        Exit-Json $result;
    }
    if ($mydisk.IsReadOnly -eq $true){$mydisk | Set-Disk -IsReadOnly $false}
    if ($mydisk.IsOffline -eq $true){$mydisk | Set-Disk -IsOffline $false}
    
	#check if partition exist #### 
	$my_mountpoint = Get-PSDrive | Where-Object {($_.Name -eq $Partition.driveletter)}
	$my_partition = Get-partition | Where-Object {($_.DriveLetter -eq $Partition.driveletter)}
	
    if($my_partition -ne $null) 
	{
        #if ($my_partition.size/1GB -ne $Partition.partitionsize){$change = $false;$myerror = $true; $msg = "Partition already exist, Present size for: " + $Partition.driveletter + ":\ is: " + ($my_partition.size/1GB) + "GB"}
        if (($Partition.partitionsize -ne "remainingsize") -and ($Partition.partitionsize -ne $my_partition.size/1GB)){$change = $false;$myerror = $true; $msg = "Partition already exist, Present size for: " + $Partition.driveletter + ":\ is: " + ($my_partition.size/1GB) + "GB"}
        
		#check filesystem
        elseif (($my_partition | Get-Volume).FileSystem -ne $Volume.FileSystem){$change = $false;$myerror = $true; $msg = "Partition already exist, File system error. Present filesystem for: " + $Partition.driveletter + " is: " + (($my_partition | Get-Volume).FileSystem)}
        elseif (($my_partition | Get-Volume).FileSystemlabel -ne $Volume.NewFileSystemLabel){$change = $false;$myerror = $true; $msg = "Partition already exist, File system error. Actuall filesystemLabel for: " + $Partition.driveletter + " is: " + (($my_partition | Get-Volume).FileSystemlabel)}
        elseif (-not(Test-Path ($Partition.driveletter + ":")))
            {$change = $false;$myerror = $true; $msg = "Partition already exist, Path: " + $Partition.driveletter + ":\ exist but is not accessible"}
        else
            {$change = $false;$myerror = $false; $msg = "Path: " + $Partition.driveletter + ":\ is accessible"}
    }
	elseif($my_mountpoint -ne $null)
	{
		$change = $false;$myerror = $true; $msg = "Mount Point: " + $Partition.driveletter + ":\ is already mounted"
	}
    else
    {
        # If it s a new disk #create partition and volume
        if ( $mydisk.PartitionStyle -eq "raw")
	   	{
			$mydisk | Initialize-Disk -PartitionStyle $Partition.typedisk
			$mydisk = Get-Disk | Where-Object {$_.Number -eq $Partition.diskid}
		}
        # size is OK create the partition
        if ($Partition.partitionsize -eq "remainingsize")
        {
		    if ($mydisk.LargestFreeExtent -le 1024){$change = $false;$myerror = $true; $msg = "Remaining size is too small. Actuall remaining size lower than 1024b, it is: " + ($mydisk.LargestFreeExtent/1GB)
            }else{
                $mydisk | New-Partition -UseMaximumSize -DriveLetter $Partition.driveletter | Format-Volume -FileSystem $Volume.FileSystem -AllocationUnitSize $Volume.AllocationUnitSize -NewFileSystemLabel $Volume.NewFileSystemLabel -Force -Confirm:$false
                $change = $true;$myerror = $false; $msg = "New Partition OK"
            }
        }
        else{
            if(($mydisk.LargestFreeExtent/1GB) -le $Partition.partitionsize ){$change = $false;$myerror = $true; $msg = "Remaining size is too small. Actuall remaining size is: " + ($mydisk.LargestFreeExtent/1GB)
            }else{ 
                $mysize = [convert]::Toint64(($Partition.partitionsize * 1073741824),10)
                $mydisk | New-Partition -Size $mysize -DriveLetter $Partition.driveletter  | Format-Volume -FileSystem $Volume.FileSystem -AllocationUnitSize $Volume.AllocationUnitSize -NewFileSystemLabel $Volume.NewFileSystemLabel -Force -Confirm:$false
                $change = $true; $myerror = $false; $msg = "New Partition OK"
            }
        }
    }  
	$result=New-Object psobject @{
       changed=$change
       failed=$myerror
       error=$myerror
       msg=$msg
    };           
     Exit-Json $result; 
}
catch [Exception]{
    $result=New-Object psobject @{
	changed=$false
    failed=$true
    error=$_.Exception.Message
    msg=$msg
    };
    Exit-Json $result;
}
