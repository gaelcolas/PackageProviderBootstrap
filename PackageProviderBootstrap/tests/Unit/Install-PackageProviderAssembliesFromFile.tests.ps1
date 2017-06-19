$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here/../../*/$sut" #for files in Public\Private folders, called from the tests folder


Describe 'Install-PackageProviderFromFile' {
    Context 'Basic Use case' {
        It 'Runs without Errors' {
            {Install-PackageProviderAssembliesFromFile -Scope 'CurrentUser' -ProviderName NuGet} | Should Not Throw
        }
    }
}