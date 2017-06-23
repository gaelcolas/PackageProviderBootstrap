function Test-ChocolateyPackageIsInstalled {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory
            ,ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Version,
        
        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        $Source,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [PSCredential]
        $Credential,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [String]
        $CacheLocation

    )

    Process {
        if (-not ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue)) {
            Throw "Chocolatey Software not found"
        }
        
        #if version latest verify against sources
        if (! ($InstalledPackages += Get-ChocolateyPackage -LocalOnly -Name $Name) ) {
            Write-Verbose "Could not find Package $Name"
            return $false
        }

        $SearchPackageParams = $PSBoundParameters
        $null = $SearchPackageParams.Remove('version')

        if ($Version -eq 'latest') {
            $ReferenceObject = Get-ChocolateyPackage @SearchPackageParams -Exact
            if(!$ReferenceObject) {
                Throw "Latest version of Package $name not found. Verify that the sources are reachable."
            }
        }
        else {
            $ReferenceObject = [PSCustomObject]@{
                Name = $Name
            }
            if($Version) { $ReferenceObject | Add-Member -MemberType NoteProperty -Name version -value $Version }
        }

        $MatchingPackages = $InstalledPackages | Where-Object {
            Write-Verbose "Testing $($_.Name) against $($ReferenceObject.Name)"
            $ReferenceObject.PSObject.Properties.Name | Write-Verbose
            "Installed Package: " + $_ | Write-Verbose
            "Reference Package: " +$ReferenceObject | Write-verbose
            -not (Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $_ -Property $ReferenceObject.PSObject.Properties.Name)
        }
        if ($MatchingPackages) {
            Write-Verbose ("'{0}' packages match the given properties." -f $MatchingPackages.Count)
            $True
        }
        else {
            Write-Verbose "No packages match the selection."
            $False
        }
    }
}