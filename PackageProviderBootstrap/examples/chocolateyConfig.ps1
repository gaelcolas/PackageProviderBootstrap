configuration Chocolatey {
    Import-DscResource -ModuleName PackageProviderBootstrap

    Node localhost {
        ChocolateyInstall ChocoInst {
            Ensure = 'Present'
        }
    }
}