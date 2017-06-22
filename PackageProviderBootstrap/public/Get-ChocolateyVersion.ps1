function Get-ChocolateyVersion {
    [CmdletBinding()]
    Param(
    )

    Process {
        if (-not ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue)) {
            Throw "Chocolatey Software not found"
        }
        
        $ChocoArguments = @('-v')
        Write-Verbose "choco $($ChocoArguments -join ' ')"

        $CHOCO_OLD_MESSAGE = "Please run chocolatey /? or chocolatey help - chocolatey v"
        $versionOutput = (&$chocoCmd $ChocoArguments) -replace ([regex]::escape($CHOCO_OLD_MESSAGE))
        
        Write-Verbose $versionOutput
        [version]($versionOutput)
    }
}