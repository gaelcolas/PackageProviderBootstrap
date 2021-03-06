function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )
    <#
        ,[string]
        $InstallDir
    #>
    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')

    if ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue) {
        $chocoBin = Split-Path -Parent $chocoCmd.Path -ErrorAction SilentlyContinue
        $InstallDir = (Resolve-Path ([io.path]::combine($chocoBin,'..'))).Path
    }

    Write-Output (@{
        Ensure = if ($chocoCmd) {'Present'} else {'Absent'}
        InstallDir = $InstallDir
    })
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $InstallDir,

        [System.String]
        $ChocoInstallScriptUrl
    )
    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')

    Import-Module $PSScriptRoot\..\..\PackageProviderBootstrap.psd1

    $ChocoParams = @{}
    if ($ChocoInstallScriptUrl) {$ChocoParams.Add('ChocoInstallScriptUrl',$ChocoInstallScriptUrl)}
    if ($InstallDir)            {$ChocoParams.Add('InstallDir',$InstallDir)}

    if ($ensure -eq 'Present') {
        Install-Chocolatey @ChocoParams
    }
    else {
        Uninstall-Chocolatey -InstallDir $InstallDir
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $InstallDir,

        [System.String]
        $ChocoInstallScriptUrl
    )
    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')
    
    Import-Module $PSScriptRoot\..\..\PackageProviderBootstrap.psd1

    $ChocoParams = @{}
    if ($InstallDir) {$ChocoParams.Add('InstallDir',$InstallDir)}

    $EnsureTestMap = @{'Present'=$true;'Absent'=$false}

    return ($EnsureTestMap[$Ensure] -eq (Test-ChocolateyInstall @ChocoParams))

}


Export-ModuleMember -Function *-TargetResource

