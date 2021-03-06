function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Name
    )
    <#
        ,

        [parameter()]
        [System.String]
        $Source,

        [parameter()]
        [System.Boolean]
        $Disabled,

        [parameter()]
        [System.Boolean]
        $ByPassProxy,

        [parameter()]
        [System.Boolean]
        $SelfService,

        [parameter()]
        [System.Int]
        $priority,

        [parameter()]
        [System.String]
        $username
    #>
    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')
    
    Import-Module $PSScriptRoot\..\..\PackageProviderBootstrap.psd1 -verbose:$False

    $ChocoSourceParams = @{
        Name = $Name
    }
    switch ($PSBoundParameters.keys) {
        'Source'      {$ChocoSourceParams.add('Source',$Source)}
        'disabled'    {$ChocoSourceParams.Add('disabled',$Disabled)}
        'bypassproxy' {$ChocoSourceParams.add('bypassproxy',$bypassproxy)}
        'selfservice' {$ChocoSourceParams.add('selfservice',$selfservice)}
        'priority'    {$ChocoSourceParams.add('priority',$priority)}
    }

    if (!($SourceConfigured = Get-ChocolateySource @ChocoSourceParams) ) {
        Write-verbose ("Source $Name not found with configuration `r`n{0}" -f ($ChocoSourceParams|Format-list))
    }
    else {
        Write-Verbose "Source $Name has an exact match."
    }

    return @{
        Source      = $SourceConfigured.Source
        disabled    = $SourceConfigured.disabled
        bypassproxy = $sourceconfigured.bypassproxy
        selfservice = $SourceConfigured.selfservice
        priority    = $SourceConfigured.priority
    }
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

        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $Source,

        [System.Int16]
        $Priority,

        [System.Boolean]
        $Disabled,

        [System.Boolean]
        $BypassProxy,

        [System.Boolean]
        $SelfService,

        [System.Management.Automation.PSCredential]
        $Credential
    )

    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')
    
    Import-Module $PSScriptRoot\..\..\PackageProviderBootstrap.psd1 -verbose:$False

    $ChocoSourceParams = @{
        Name = $Name
    }
    switch ($PSBoundParameters.keys) {
        'Source'      {$ChocoSourceParams.add('Source',$Source)}
        'disabled'    {$ChocoSourceParams.Add('disabled',$Disabled)}
        'bypassproxy' {$ChocoSourceParams.add('bypassproxy',$bypassproxy)}
        'selfservice' {$ChocoSourceParams.add('selfservice',$selfservice)}
        'priority'    {$ChocoSourceParams.add('priority', $priority)}
        'Credential'  {$ChocoSourceParams.add('Credential',$Credential)}
    }

    switch ($Ensure) {
        'Present' { Register-ChocolateySource @ChocoSourceParams -noProgress }
        'Absent' { Unregister-ChocolateySource @ChocoSourceParams -noProgress }
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

        [parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [System.String]
        $Source,

        [System.Int16]
        $Priority,

        [System.Boolean]
        $Disabled,

        [System.Boolean]
        $BypassProxy,

        [System.Boolean]
        $SelfService,

        [System.Management.Automation.PSCredential]
        $Credential
    )
    
    $Env:Path = [Environment]::GetEnvironmentVariable('Path','Machine')
    Import-Module $PSScriptRoot\..\..\PackageProviderBootstrap.psd1 -verbose:$False

    $ChocoSourceParams = @{
        Name = $Name
    }
    switch ($PSBoundParameters.keys) {
        'Source'      {$ChocoSourceParams.add('Source',$Source)}
        'disabled'    {$ChocoSourceParams.Add('disabled',$Disabled)}
        'bypassproxy' {$ChocoSourceParams.add('bypassproxy',$bypassproxy)}
        'selfservice' {$ChocoSourceParams.add('selfservice',$selfservice)}
        'priority'    {$ChocoSourceParams.add('priority', $priority)}
        'Credential'  {$ChocoSourceParams.add('Credential',$Credential)}
    }

    $EnsureResultMap = @{
        'Present'=$true
        'Absent'=$false
    }

    return ($EnsureResultMap[$Ensure] -eq (Test-ChocolateySource @ChocoSourceParams))
}


Export-ModuleMember -Function *-TargetResource

