configuration Default {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Node localhost {
        NuGetBootstrapDsc nugetprovider {
            Ensure = 'Present'
            InstallScope = 'AllUsers'
            RunKey = 'NuGet Provider Bootstrap'
        }
    }
}