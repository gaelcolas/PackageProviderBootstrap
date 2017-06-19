function Uninstall-PackageProviderAssemblies {
    <#
      .SYNOPSIS
      Removes the Provider Assmemblies for a given provider.

      .DESCRIPTION
      This cmdlet removes all files related to a Package Provider Assemblies from the
      adequate folder based on the scope ($Env:ProgramFiles for AllUsers, or $Env:LOCALAPPDATA
      For current user). This command will fail if the files (i.e. .dll) is loaded in a PowerShell
      session. Kill that session to free the handle and remove the files.

      .EXAMPLE
      Uninstall-PackageProviderAssemblies -Scope 'CurrentUser' -ProviderName NuGet

      .PARAMETER Scope
      Defines whether the installation should be done globally for all users ($Env:ProgramFiles)
      or exclusively for the current user ($Env:LOCALAPPDATA).

      .PARAMETER ProviderName
      Specify which ProviderAssembly should be installed. The possible values are nuget,
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

    Process {
        Foreach ($Provider in $ProviderName) {
            Write-Verbose ('Uninstalling Provider {0} from {1}' -f $Provider,$Scope)
            $ScopePath = switch ($Scope) {
                'AllUsers'    { $Env:ProgramFiles }
                'CurrentUser' { $Env:LOCALAPPDATA }
            }
            
            $TargetPath = [io.path]::Combine(
                $ScopePath,
                'PackageManagement\ProviderAssemblies',
                $Provider
            )
            
            if ($pscmdlet.ShouldProcess("Removing $TargetPath")) {
                Remove-Item -Path $TargetPath -Recurse -Force -ErrorAction Stop
            }
        }
    }
}