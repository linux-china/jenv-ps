jenv-ps
=======================================

jenv Power Shell Edition, refer https://github.com/flofreud/posh-gvm

### Install
Execute following command In your power shell console

     (new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

if you use ps-get, please use following command:

     install-module -ModuleUrl https://jenv.io/jenv-ps.zip

### Development
 

    git clone  git@github.com:linux-china/jenv-ps.git  C:\Users\xxxxx\Documents\WindowsPowerShell\Modules\jenv
    Get-Module -ListAvailable
    Import-Module -Verbose -Name jenv
