# Script for reproducing a bug in volsnap.sys (v10.0.22621.1) on Windows 11 
# The shadow copy's OriginatingMachine and VolumeName property are hardcoded for the prepared vhd
param(
    [string]$VhdFile,
    [int]$VscCount
)

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true) {
	Throw "Must be run as an Administrator"
}

$counter = 0

While($true)
{
    Write-Host "-- Run $counter"
    $vhd = Mount-DiskImage -ImagePath $VhdFile -Access ReadWrite -PassThru -Verbose
    If(-not($vhd.Attached)){break}
    Write-Host "Using: $($vhd.DevicePath)";
    $vscs = Get-WmiObject Win32_ShadowCopy | Where-Object {$_.OriginatingMachine -eq "Hello World" -and $_.VolumeName -match "96aa9cf1-0000-0000-0000-010000000000"}
    Write-Host "VSC: $($vscs.Count)"
    If ($vscs.Count -ne $VscCount){
        Write-Warning "VSC missing! Check eventlog for volsnap errors."
        $vhd = Dismount-DiskImage -InputObject $vhd
        Write-Host "Attached: $($vhd.Attached)"
        Break
    }
    $vhd = Dismount-DiskImage -InputObject $vhd -Verbose
    Write-Host "Attached: $($vhd.Attached)"
    $counter += 1
}
