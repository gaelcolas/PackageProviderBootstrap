function Register-ChocolateySource {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory
            ,ValueFromPipelineByPropertyName
        )]
        [String]
        $Name,

        [Parameter(
            Mandatory
            ,ValueFromPipelineByPropertyName
        )]
        $Source,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $Disabled,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $BypassProxy,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $SelfService,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [int]
        $Priority = 0,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [PSCredential]
        $Credential,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $Force,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [String]
        $CacheLocation,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $NoProgress

    )

    Process {
        if (-not ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue)) {
            Throw "Chocolatey Software not found"
        }

        if (Get-ChocolateySource -id $Name) {
            Throw "Chocolatey Source $Name already exists. You can modify it using Set-ChocolateySource."
        }
        
        $ChocoArguments = @('source','add')
        $ChocoArguments += Get-ChocolateyDefaultArgument @PSBoundParameters
        Write-Verbose "choco $($ChocoArguments -join ' ')"

        &$chocoCmd $ChocoArguments | Write-Verbose

        if ($Disabled) {
            &$chocoCmd @('source','disable',"-n=`"$Name`"") | Write-Verbose
        }
    }
}