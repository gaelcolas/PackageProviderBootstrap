configuration Default {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Nodes localhost {
        NuGetBootstrapDsc nugetprovider {
            Ensure = 'Present'
            InstallScope = 'AllUsers'
            RunKey = 'NuGet Provider Bootstrap'
        }
    }
}