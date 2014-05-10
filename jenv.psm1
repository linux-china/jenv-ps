$jenvDir = $Env:JENV_DIR

if(  $jenvDir -le $null) {
  $jenvDir="c:\jenv"
}

function Start-Jenv() {
   $shell = New-Object -COM WScript.Shell
   $files = dir "$jenvDir\candidates"
   for($i=0;$i –lt $files.Length;$i++){
     $candidate=$files[$i].Name
	 $candidateLink="$jenvDir\candidates\$candidate\current.lnk"
	 if ( Test-Path "$jenvDir\candidates\$candidate\current.lnk") {
	     $link = $shell.CreateShortcut("$jenvDir\candidates\$candidate\current.lnk")
		 if( Test-Path $link.TargetPath ) {
		   $Env:Path = $link.TargetPath +"\bin;"+$Env:Path
		   [environment]::SetEnvironmentVariable($candidate.ToUpper()+"_HOME", $link.TargetPath,"Process")
		 }
	 }
   }
}

Start-Jenv

function jenv([string]$Command, [string]$Candidate, [string]$Versiond)
{
     try {
        switch -regex ($Command) {
            'help'       { Show-Help }
			'install'       { Install-Candidate $Candidate $Versiond }
            default           { Write-Warning "Invalid command: $Command"; Show-Help }
        }
    } catch {
        Jenv-Help
    }
}

function Install-Candidate([string]$candidate, [string]$version){
    $jenvArchives="$jenvDir\archives"
	if ( !(Test-Path $jenvArchives )) {
      New-Item $jenvArchives -ItemType Directory
    }
	$candidateFileName=$candidate+"-"+$version+".zip"
	$candidateHome="$jenvDir\candidates\$candidate\$version"
	$candidateUrl="http://get.jenv.mvnsearch.org/download/$candidate/$candidateFileName"
	if ( !(Test-Path "$jenvDir\candidates\$candidate" )) {
	   New-Item "$jenvDir\candidates\$candidate" -ItemType directory
	}
	if ( !(Test-Path $candidateHome )) { 
		if ( !(Test-Path "$jenvArchives\$candidateFileName")) {
		  $webClient = (New-Object Net.WebClient)
		  $webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
		  $webClient.DownloadFile($candidateUrl, "$jenvArchives\$candidateFileName")
		}
		# unzip archive
		$shell = New-Object -com shell.application
		$shell.namespace($jenvArchives).copyhere($shell.namespace("$jenvArchives\$candidateFileName").items(), 0x14)
		Move-Item ("$jenvArchives\"+$candidate+"-"+$version) ($candidateHome)
	}
}

function Show-Help() {
    Write-Output @"
Usage: jenv <command> <candidate> [version]
    gvm offline <enable|disable>

    commands:
        install   or i    <candidate> [version]
        uninstall or rm   <candidate> <version>
        list      or ls   <candidate>
        use       or u    <candidate> [version]
        default   or d    <candidate> [version]
        current   or c    [candidate]
        version   or v
        broadcast or b
        help      or h
        selfupdate        [-Force]
        version    :  where optional, defaults to latest stable if not provided

eg: jenv install groovy
"@
}
