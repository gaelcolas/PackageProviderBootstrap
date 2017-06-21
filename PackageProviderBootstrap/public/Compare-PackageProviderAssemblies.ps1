function Compare-PackageProviderAssemblies {
    <#
      .SYNOPSIS
      Compare Installed ProviderAssemblies with the files provided within the module.

      .DESCRIPTION
      Compares all files installed under a Package Provider, depending on scope,
      against those provided within the module.

      .EXAMPLE
      Compare-PackageProviderAssemblies -Scope 'CurrentUser' -ProviderName NuGet

      .PARAMETER Scope
      Defines whether the comparison should be done with for the globally installed ($Env:ProgramFiles)
      or exclusively for the current user ($Env:LOCALAPPDATA).

      .PARAMETER ProviderName
      Specify which ProviderAssembly should be compared. The possible values are nuget,
      chocolatey, or psl.

      #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [cmdletBinding(
            SupportsShouldProcess=$true,
            ConfirmImpact='Low'
            )]
    Param(
        [Parameter(
            Mandatory
            ,ValueFromPipelineByPropertyName
            )]
        [ValidateSet('nuget','chocolatey','psl')]
        [String]
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
        $ScopePath = switch ($Scope) {
            'AllUsers'    { $Env:ProgramFiles }
            'CurrentUser' { $Env:LOCALAPPDATA }
        }
    }

    Process {
        Foreach ($Provider in $ProviderName) {
            Write-Verbose ('Uninstalling Provider {0} from {1}' -f $Provider,$Scope)
            
            $TargetPath = [io.path]::Combine(
                $ScopePath,
                'PackageManagement\ProviderAssemblies',
                $Provider
            )

            $sourceFiles = Get-ChildItem "$Modulebase\bin\providers\$Provider" -Recurse -ErrorAction SilentlyContinue
            $TargetFiles = Get-ChildItem $TargetPath -Recurse -ErrorAction SilentlyContinue

            if ($pscmdlet.ShouldProcess("Comparing $Provider")) {
                if(!$TargetFiles) {
                    $TargetFiles = @()
                }
                Write-Output -InputObject (
                    Compare-Object -ReferenceObject $sourceFiles -DifferenceObject $TargetFiles|
                      Where-Object {$_.SideIndicator -eq '<='}
                )
            }
        }
    }
}