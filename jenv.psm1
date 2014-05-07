function jenv([string]$Command, [string]$Candidate, [string]$Versiond)
{
     try {
        switch -regex ($Command) {
            '^h(elp)?$'       { Jenv-Help }
            default           { Write-Warning "Invalid command: $Command"; Show-Help }
        }
    } catch {
        Jenv-Help
    }
}

function Jenv-Help() {
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
        offline           <enable|disable>
        selfupdate        [-Force]
        flush             <candidates|broadcast|archives|temp>
    candidate  :  $($Script:GVM_CANDIDATES -join ', ')
	
    version    :  where optional, defaults to latest stable if not provided

eg: jenv install groovy
"@
}