function Get-ChocolateyDefaultArgument {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipelineByPropertyName
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
        $NoProgress,

        [Parameter(
            ,ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Version,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $LocalOnly,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $IdOnly,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $Prerelease,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Switch]
        $ApprovedOnly,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $IncludePrograms,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $ByIdOnly,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [Switch]
        $IdStartsWith,

        [Parameter(
            ValueFromPipelineByPropertyName
        )]
        [switch]
        $Exact

    )

    Process {

        $ChocoArguments = switch($PSBoundParameters.Keys) {
            'Priority'      { if ( $Priority -gt 0) {"--priority=$priority" } }
            'SelfService'   { if ( $SelfService.ToBool() ) { "--allow-self-service"}}
            'Name'          { "-n`"$Name`"" }
            'Source'        { "-s`"$Source`"" }
            'ByPassProxy'   { if ( $BypassProxy.ToBool() ) { "--bypass-proxy"} }
            'CacheLocation' { "--cache-location=`"$CacheLocation`"" }
            'WhatIf'        {  if ( $WhatIf.ToBool()) {"--whatif" } }
            'cert'          { "--cert=`"$Cert`"" }
            'Force'         { if ( $Force.ToBool() ) { '--yes' } }
            'AcceptLicense' { '--accept-license' }
            'Verbose'       { '--verbose'}
            'Debug'         { '--debug'  }
            'Credential'    {
                if ($Username = $Credential.Username) {
                    "--user=`"$Username`""
                }
                if($Password = $Credential.GetNetworkCredential().Password) {
                    "--password=`"$Password`""
                }
            }
            'ByTagOnly'    { '--by-tag-only' }
            'ByIdOnly'     { '--by-id-only' }
            'LocalOnly'    { '--local-only' }
            'IdStartsWith' { '--id-starts-with' }
            'ApprovedOnly' { '--approved-only'}
            'OrderByPopularity' { '--order-by-popularity' }
            'NotBroken'    { '--not-broken' }
            'prerelease'   { '--prerelease' }
            'IncludePrograms' { '--include-programs'}
            'AllVersions'  { '--all-versions' }
            'Version'      { "--version=`"$version`"" }
            'exact'        { "--exact" }


        }

        return $ChocoArguments
    }
}