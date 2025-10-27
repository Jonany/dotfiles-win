# Random functions I don't use but want to keep around.

function azdo-mkpr {
    param (
    [Parameter(Mandatory)]
        [string]$Title,
    [Parameter(Mandatory)]
        [string]$TargetBranch,
    [Parameter(Mandatory)]
        [string]$WorkItem,
    [Parameter(Mandatory)]
        [boolean]$IsDraft
    )
    $CurrentBranch = git rev-parse --abbrev-ref HEAD

   az repos pr create --open --title $Title -s $CurrentBranch -t $TargetBranch --work-item $WorkItem --draft $IsDraft
}

function dn-fd-proj {
    return fd -e csproj -t f
        | Sort-Object -Top 1 {
            $inCurrentDir = [int]((Split-Path $_ -Parent) -eq (Get-Location).Path)
            $hasApi = [int]($_ -like "*Api*")
            -($inCurrentDir * 10000 + $hasApi * 100), $_
        }
    # Sorted, first result
    # (fd -e csproj -t f -d 1 -X lsd --color=never --icon=never --literal) | coreutils.exe head -1 #same-dir
    # (fd -e csproj -t f -X lsd --color=never --icon=never --literal) | coreutils.exe head -1      #all
    # (fd -e csproj Api -t f -X lsd --color=never --icon=never --literal) | coreutils.exe head -1  #api

    #$csproj = fd -e csproj -t f | sort -Top 1 { -([int]($_ -like "*Api*") * 10000), (Split-Path $_ -Leaf) }
}
function dnr {
    if ($args.Count -eq 0) {
        dotnet run --project dn-fd-proj
    } elseif ($args.Count -eq 1) {
        #return $args[0]
        dotnet run --project $args[0]
    } else {
        #return $args
        dotnet run $args
    }
}

#function dwb {
#    $csproj = ''
#    if ($args.Count -eq 0) {
#        $csproj = dn-fd-proj
#    } else {
#        $csproj = $args[0]
#    }
#
#    $projDir = Split-Path $csproj -Parent
#    Push-Location $projDir
#    $watchArgs = $args[1..($args.Length - 1)]
#    #dotnet watch build @watchArgs
#    #Pop-Location $projDir
#    try {
#        dotnet watch build @watchArgs
#    }
#    catch [System.Management.Automation.PipelineStoppedException] {
#        Write-Host "dotnet watch interrupted by Ctrl+C"
#    }
#    finally {
#        Pop-Location
#    }
#}


#function dnr-pwsh {
#    if ($args.Count -eq 0) {
#        $csproj = Get-ChildItem -Recurse -Include *.csproj
#            | Sort-Object -Top 1 {
#                $inCurrentDir = [int]((Split-Path $_ -Parent) -eq (Get-Location).Path)
#                $hasApi = [int]($_ -like "*Api*")
#                $fileName = [string](Split-Path $_ -Leaf)
#                -($inCurrentDir * 10000 + $hasApi * 100), $fileName
#            }
#
#        return $csproj
#        #dotnet run --project $csproj
#    } elseif ($args.Count -eq 1) {
#        return $args[0]
#        #dotnet run --project $args[0]
#    } else {
#        return $args
#        #dotnet run $args
#    }
#}

function RefreshDevNugetPackage {
    param (
        [Parameter(Mandatory)] [string]$DotnetProject,
        [Parameter(Mandatory)] [string]$NugetPackageName,
        [string]$KillDotnetHostProcesses = 'N'
    )

    if ($KillDotnetHostProcesses -eq 'Y')
    {
        $Username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

        Write-Host '[RefreshDevNugetPackage]: Killing all .NET Host processes to prevent locking of temp files'
        Get-Process -Name "dotnet" -IncludeUserName | Where-Object { $_.UserName -eq $Username } | Stop-Process
    }

    Write-Host "[RefreshDevNugetPackage]: Removing Nuget package: $NugetPackageName"
    Remove-Item "$env:userprofile\.nuget\packages\$NugetPackageName" -Recurse -Force

    Write-Host "[RefreshDevNugetPackage]: Finding Nuget package source for $NugetPackageName"
    $nugetSources = dotnet nuget list source --format short
    $nugetSourcePath = $nugetSources | Where-Object { $_ -like "*$NugetPackageName*" }

    if ($nugetSourcePath) {
        $nugetSourcePath = $nugetSourcePath -replace "^E\s+", "" -replace "bin\\Release", ""
        dotnet build -v q --no-incremental -c Release $nugetSourcePath
    } else {
        Write-Host "[RefreshDevNugetPackage]: Nuget package source for $NugetPackageName not found."
    }

    Write-Host "[RefreshDevNugetPackage]: Rebuilding: $DotnetProject"
    dotnet build -v q --no-incremental $DotnetProject
}

function sudo {
    param([string]$command)
    Start-Process -FilePath pwsh -Verb RunAs -ArgumentList "-Command $command"
}

function adm {
    param([string]$command)
    Start-Process -FilePath 'wezterm-gui' -Verb RunAs -ArgumentList "--config-file `"$env:XDG_CONFIG_HOME\wezterm.lua`""
}

