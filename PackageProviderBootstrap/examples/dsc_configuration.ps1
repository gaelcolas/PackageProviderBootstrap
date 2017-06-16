configuration Default {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Nodes localhost {
        ChocolateyBootstrapDsc Choco {
            Ensure = 'Present'
            InstallKey = 'aa'
        }
    }

}