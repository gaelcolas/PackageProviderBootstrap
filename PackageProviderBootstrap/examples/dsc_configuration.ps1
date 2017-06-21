configuration Default {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Node localhost {
        NuGetBootstrapDsc nugetproviderInstall {
            Ensure = 'Present'
            InstallScope = 'AllUsers'
            RunKey = 'NuGet Provider Bootstrap'
        }

        ChocolateyPrototypeBootstrapDsc ChocolateyproviderInstall {
            Ensure = 'Present'
            InstallScope = 'AllUsers'
            RunKey = 'Chocolatey Prototype Provider Bootstrap'
        }

    }
}

configuration Remove {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Node localhost {
        NuGetBootstrapDsc nugetproviderRemove {
            Ensure = 'Absent'
            InstallScope = 'AllUsers'
            RunKey = 'NuGet Provider Bootstrap'
        }

        ChocolateyPrototypeBootstrapDsc ChocolateyproviderRemove {
            Ensure = 'Absent'
            InstallScope = 'AllUsers'
            RunKey = 'Chocolatey Prototype Provider Bootstrap'
        }

    }
}