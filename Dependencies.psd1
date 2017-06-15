@{
    # Set up a mini virtual environment...
    PSDependOptions = @{
        AddToPath = $True
        Target = 'BuildOutput\modules'
        Parameters = @{
        }
    }

    buildhelpers = 'latest'
    invokeBuild = 'latest'
    pester = 'latest'
    PSScriptAnalyzer = 'latest'
    PlatyPS = 'latest'
    psdeploy = 'latest'

    # 'https://chocolatey.org/install.ps1' = @{
    #     DependencyType = 'FileDownload'
    #     Target = 'PackageProviderBootStrap\bin\Chocolatey\'
    #     AddToPath = $False
    # }

    'Chocolatey' = @{
        DependencyType = 'Package'
        Target = 'PackageProviderBootStrap\bin\Chocolatey\'
        Source = 'nuget'
    }

}