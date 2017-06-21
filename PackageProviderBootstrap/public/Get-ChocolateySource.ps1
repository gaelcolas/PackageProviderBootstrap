function Get-ChocolateySource {
    [CmdletBinding()]
    Param(
        [Alias('Name')]
        [ValidateNotNullOrEmpty()]
        [string]
        $id
    )
    Begin {
        if (-not ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue)) {
            Throw "Chocolatey Software not found"
        }
        $ChocoConfigPath = join-path $chocoCmd.Path ..\..\config\*.config -Resolve
        $ChocoXml = [xml]::new()
        $ChocoXml.Load($ChocoConfigPath)
    }

    Process {
        if (!$ChocoXml) {
            Throw "Error with Chocolatey config"
        }

        if ($id) {
            $sourceNodes = $ChocoXml.SelectNodes("//source[@id='$([Security.SecurityElement]::Escape($id))']")
        }
        else {
            $sourceNodes = $ChocoXml.chocolatey.sources.childNodes
        }

        foreach ($source in $sourceNodes) {
            Write-Output ([PSCustomObject]@{
                PSTypeName  = 'Chocolatey.Source'
                id          = $source.id
                value       = $source.value
                disabled    = [bool]::Parse($source.disabled)
                bypassProxy = [bool]::Parse($source.bypassProxy)
                selfService = [bool]::Parse($source.selfService)
                priority    = [int]$source.priority
            })
        }
    }
}