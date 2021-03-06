$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here/../../*/$sut" #for files in Public\Private folders, called from the tests folder


Describe 'Compare-PackageProviderAssemblies' {
    Context 'Basic Use case' {
        It 'Runs without Errors' {
            {Compare-PackageProviderAssemblies -Scope 'CurrentUser' -ProviderName NuGet} | Should Not Throw
        }
    }
}