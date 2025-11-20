Set-StrictMode -Version 3.0

function prompt {
    $segments = $ExecutionContext.SessionState.Path.CurrentLocation -split '\\'
    $shortSegments = @()
    for ($i = 0; $i -lt $segments.Count; $i++) {
        if ($i -lt $segments.Count - 1) {
            if ($segments[$i] -eq 'C:') {
                $shortSegments += 'c'
                #Write-Host -NoNewline 'c/'
            }
            else {
                $shortSegments += "$($segments[$i][0])"
                #Write-Host -NoNewline "$($segments[$i][0])/"
            }
        }
        else {
            $shortSegments += "$($segments[$i])"
            #Write-Host "$($segments[$i])"
        }
    }
    #Write-Host -NoNewline "-> "
    $shortPath = $shortSegments -join '/'

    $gitBranch = ''
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            $gitBranch = " ($branch)"
        }
    } catch {}

    $host.UI.RawUI.WindowTitle = Split-Path -Leaf ($ExecutionContext.SessionState.Path.CurrentLocation)

    return "`n$shortPath$gitBranch`n-> ".ToLower()
}

$env:XDG_CONFIG_HOME = "c:\util\src\etc\dotfiles-win\config"
$env:STARSHIP_CONFIG = "$env:XDG_CONFIG_HOME\starship.toml"
$env:EDITOR = "nvim"
$env:YAZI_CONFIG_HOME = "$env:XDG_CONFIG_HOME\yazi"
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe" # TODO: mv to adm_bin
$env:USR_BIN = "c:\util\apps\usr-bin" # binaries installed without needing admin permissions
$env:ADM_BIN = "c:\util\apps\bin" # binaries installed needing admin permissions
$env:DOTNET_CLI_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK_OPTOUT = 1

$env:PATH += ";$env:ADM_BIN"
$env:PATH += ";$env:ADM_BIN\neovim\bin"
$env:PATH += ";$env:USR_BIN"
$env:PATH += ";$env:USR_BIN\lua-language-server\bin"
$env:PATH += ";$env:USR_BIN\zig"
$env:PATH += ";C:\Program Files\7-Zip" #7z cli tool

Set-Alias -Name find -Value fd
Set-Alias -Name ls -Value lsd
# The default curl alias points to Invoke-WebRequest
Set-Alias -Name curl -Value curl.exe

try {
    coreutils --help > $null

    function coreutils-cat { coreutils cat @args }
    function coreutils-date { coreutils date @args }
    function coreutils-df { coreutils df @args }
    function coreutils-du { coreutils du @args }
    function coreutils-head { coreutils head @args }
    function coreutils-mkdir { coreutils mkdir @args }
    function coreutils-mv { coreutils mv @args }
    function coreutils-pwd { coreutils pwd @args }
    function coreutils-rm { coreutils rm @args }
    function coreutils-split { coreutils split @args }
    function coreutils-tail { coreutils tail @args }
    function coreutils-touch { coreutils touch @args }
    function coreutils-true { coreutils true @args }
    Set-Alias -Name cat         -Value coreutils-cat
    Set-Alias -Name date        -Value coreutils-date
    Set-Alias -Name df          -Value coreutils-df
    Set-Alias -Name du          -Value coreutils-du
    Set-Alias -Name head        -Value coreutils-head
    Set-Alias -Name mkdir       -Value coreutils-mkdir
    Set-Alias -Name mv          -Value coreutils-mv
    Set-Alias -Name pwd         -Value coreutils-pwd
    Set-Alias -Name rm          -Value coreutils-rm
    Set-Alias -Name split       -Value coreutils-split
    Set-Alias -Name tail        -Value coreutils-tail
    Set-Alias -Name touch       -Value coreutils-touch
    Set-Alias -Name true        -Value coreutils-true
} catch { }

function dps { docker ps --format '{{json .}}' | ConvertFrom-Json | sort Names | ft Names, Status, Ports, Image }

function dusset { dotnet user-secrets set @args && dusls }
function dusls { dotnet user-secrets list @args }
function dusrm { dotnet user-secrets remove @args && dusls }
function dusinit { dotnet user-secrets init @args }

function lg { lazygit -ucf "$env:XDG_CONFIG_HOME/lazygit/config.yml" }

function cl { cd @args && ls }
function unzip { Expand-Archive @args }
function grep {
    $count = @($input).Count
    $input.Reset()

    if ($count) {
        $input | rg.exe --hidden $args
    }
    else {
        rg.exe --hidden $args
    }
}
function pwd-custom { (Get-Location).Path }
Set-Alias -Name pwd -Value pwd-custom
function pwd-clip { pwd | Set-Clipboard }

function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}

function better-test() {
    echo "Building..." `
    && dotnet build --nologo --no-restore --tl:off -clp:"ErrorsOnly;NoSummary" -p:WarningLevel=0 `
    && echo "Testing..." `
    && dotnet test --no-build --nologo --tl:off --logger "console;verbosity=detailed" @args
}
