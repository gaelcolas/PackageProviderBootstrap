function Install-PackageProviderAssembliesFromFile {
    <#
      .SYNOPSIS
      Install the given Provider assemblies from the files provided within this module.

      .DESCRIPTION
      This cmdlet copies the required files to bootstrap the Package provider in the
      adequate location for the targeted scope.

      .EXAMPLE
      Install-PackageProviderAssembliesFromFile -Scope 'CurrentUser' -ProviderName NuGet

      .PARAMETER Scope
      Define whether the installation should be done globally for all users ($Env:ProgramFiles)
      or exclusively for the current user ($Env:LOCALAPPDATA).

      .PARAMETER ProviderName
      Specify which ProviderAssembly should be installed. The possible values are nuget,
      chocolatey, or psl.

      #>
    [cmdletBinding(
            SupportsShouldProcess=$true,
            ConfirmImpact='Low'
            )]
    Param(
        [Parameter(
            Mandatory
            ,ValueFromPipeline
            ,ValueFromPipelineByPropertyName
            )]
        [ValidateSet('nuget','chocolatey','psl')]
        [String[]]
        $ProviderName,

        [Parameter(
            ValueFromPipelineByPropertyName
            )]
        [ValidateSet('AllUsers','CurrentUser')]
        [String]
        $Scope = 'CurrentUser'
    )
    begin {
        if(-not ($ModuleBase = $MyInvocation.Mycommand.Module.ModuleBase)) {
            $Modulebase= (Resolve-Path "$PSScriptRoot\..").Path
        }
    }

    Process {
        Foreach ($Provider in $ProviderName) {
            Write-Verbose ('Installing Provider {0} from lib folder for {1}' -f $Provider,$Scope)
            $ScopePath = switch ($Scope) {
                'AllUsers'    { $Env:ProgramFiles }
                'CurrentUser' { $Env:LOCALAPPDATA }
            }
            $TargetPath = [io.path]::Combine(
                $ScopePath,
                'PackageManagement\ProviderAssemblies',
                $Provider
            )
            $ProviderFilePath = "$Modulebase\bin\providers\$Provider"
            if ($pscmdlet.ShouldProcess("Copying $Modulebase\bin\providers\$Provider to $TargetPath")) {
                Copy-Item -Path $ProviderFilePath -Destination $TargetPath -Recurse -Force -ErrorAction Stop
            }
        }
    }
}