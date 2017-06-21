function Test-ChocolateySource {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory
            ,ValueFromPipelineByPropertyName
        )]
        [String]
        $Name,

        [Parameter(
            ValueFromPipelineByPropertyName
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
        $Credential

    )

    Process {
        if (-not ($chocoCmd = Get-Command 'choco.exe' -CommandType Application -ErrorAction SilentlyContinue)) {
            Throw "Chocolatey Software not found"
        }

        if (-not ($Source = (Get-ChocolateySource -Name $Name)) ) {
            Write-Verbose "Chocolatey Source $Name cannot be found."
            Return $false
        }
        
        if($Credential) {
            Write-Warning 'Comparing source with cred not yet supported'
            $guid = (New-Guid).ToString()
            $newSource = $PSBoundParameters
            $NewSource['name'] = $guid
            Register-ChocolateySource @newSource
            $ReferenceSource = Get-ChocolateySource -Name $guid
            $ReferenceSource.Name = $PSBoundParameters.Name
        }
        else {
            $ReferenceSource = [PSCustomObject]@{}

            foreach ( $Property in $PSBoundParameters.keys.where{
                $_ -notin ([System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters)}
            )
            {
                $MemberParams = @{
                    MemberType = 'NoteProperty' 
                    Name = $Property 
                    Value = $PSboundParameters[$Property]
                }
                $ReferenceSource | Add-Member @MemberParams
            }
        }

        Compare-Object -ReferenceObject $ReferenceSource -DifferenceObject $Source -Property $ReferenceSource.PSObject.Properties.Name
        
        if($NewSource) {
            Unregister-ChocolateySource @NewSource
        }
    }
}