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

