<#
	Paragon for the installation script is PsGet
#>
$jenvZipUrl = 'https://jenv.mvnsearch.org/jenv-ps.zip'

$modulePaths = @($Env:PSModulePath -split ';')
# set module path to posh default
$targetModulePath = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
# if its not use select the first defined
if ( $modulePaths -inotcontains $targetModulePath  ) {
	$targetModulePath = $modulePaths | Select-Object -Index 0
}

$jenvPath = "$targetModulePath\jenv"

try {
    # create temp dir
    $tempDir = [guid]::NewGuid().ToString()
    $tempDir = "$env:TEMP\$tempDir"
    New-Item -ItemType Directory $tempDir | Out-Null

    # download current version
    $jenvZip = "$tempDir\jenv.zip"
    Write-Host "Downloading jenv from $jenvZipUrl"
    $client = (New-Object Net.WebClient)
    $client.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    $client.DownloadFile($jenvZipUrl, $jenvZip)

    # unzip archive
    $shell = New-Object -com shell.application
    $shell.namespace($tempDir).copyhere($shell.namespace($jenvZip).items(), 0x14)


    # check if unzip successfully
    if ( Test-Path "$tempDir\jenv" ) {
        # remove old jenv
        if ( !(Test-Path $poshGvmPath) ) {
           New-Item -ItemType Directory $jenvPath | Out-Null
        }

        Copy-Item "$tempDir\posh-gvm-master\*" $jenvPath -Force -Recurse
        Write-Host "jenv installed!"
        Write-Host "Please see https://jenv.io for details to get startet."
    } else {
        Write-Warning 'Could not unzip archive containing jenv. Most likely the archive is currupt. Please try to install again.'
    }
} finally {
    # clear temp dir
    Remove-Item -Recurse -Force $tempDir
}