function Install-PackageProviderFromFile {
    <#
      .SYNOPSIS
      Sample Function to return input string.

      .DESCRIPTION
      This function is only a sample Advanced function that returns the Data given via parameter Data.

      .EXAMPLE
      Get-Something -Data 'Get me this text'


      .PARAMETER Scope
      The Data parameter is the data that will be returned without transformation.

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
        [String]
        $ProviderName,

        [Parameter(
            ValueFromPipeline
            ,ValueFromPipelineByPropertyName
            )]
        [ValidateSet('AllUsers','CurrentUser')]
        [String]
        $Scope = 'CurrentUser'
    )

    Process {
        if ($pscmdlet.ShouldProcess($Data)) {
            Write-Verbose ('Installing Provider {0} from lib folder for {1}' -f $ProviderName,$Scope)
            
            
        }
    }

}