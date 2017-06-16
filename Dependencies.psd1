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

    xDscResourceDesigner ='latest'
    # 'https://chocolatey.org/install.ps1' = @{
    #     DependencyType = 'FileDownload'
    #     Target = 'PackageProviderBootStrap\bin\Chocolatey\'
    #     AddToPath = $False
    # }

    'ProviderBinaries' = @{
        DependencyType = 'Command'
        Source = @'
$iwr = (iwr 'https://go.microsoft.com/fwlink/?LinkID=627338&clcid=0x409' -UseBasicParsing)
$swidxml = [xml][System.Text.Encoding]::ASCII.GetString($iwr.content)

$providers = @{}

$swidxml.SoftwareIdentity.Link.where{$_.Rel -eq 'package'} | % {
    $providers.Add(
        $_.name,
        $_.href
    )
}

foreach ($provider in $providers.Keys) {
    $iwr = (iwr $providers[$provider] -UseBasicParsing)
    $xml = [xml][System.Text.Encoding]::ASCII.GetString($iwr.content)
    $xml.SoftwareIdentity.link | % {
        $providerPath = ".\PackageProviderBootstrap\bin\$provider"
        if (!(Test-Path $providerPath)) { mkdir $providerPath}
        iwr $_.href -OutFile "$providerPath\$($_.targetfileName)"
    }
}
'@
    }

    'Chocolatey' = @{
        DependencyType = 'Package'
        Target = 'PackageProviderBootStrap\bin\Chocolatey\'
        Source = 'nuget'
    }

}