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
        [ValidateSet("CurrentUser","AllUsers")]
        [System.String]
        $InstallScope,

        [parameter(Mandatory = $true)]
        [System.String]
        $RunKey
    )


    ####
    <#
    $env:chocolateyProxyLocation
    $env:chocolateyProxyUser
    $env:chocolateyProxyPassword
    #$env:chocolateyVersion = 'versionnumber'
    #$env:chocolateyDownloadUrl = 'full url to nupkg file
    $env:chocolateyUseWindowsCompression = 'true'
    $env:chocolateyIgnoreProxy = 'true'
    #>
    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $returnValue = @{
    Ensure = [System.String]
    InstallScope = [System.String]
    RunKey = [System.String]
    }

    $returnValue
    #>
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
        [ValidateSet("CurrentUser","AllUsers")]
        [System.String]
        $InstallScope,

        [parameter(Mandatory = $true)]
        [System.String]
        $RunKey
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    #Include this line if the resource requires a system reboot.
    #$global:DSCMachineStatus = 1


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
        [ValidateSet("CurrentUser","AllUsers")]
        [System.String]
        $InstallScope,

        [parameter(Mandatory = $true)]
        [System.String]
        $RunKey
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $result = [System.Boolean]
    
    $result
    #>
}


Export-ModuleMember -Function *-TargetResource

