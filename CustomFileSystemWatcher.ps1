# WORK IN PROGRESS
# Kickstarted by https://powershell.one/tricks/filesystem/filesystemwatcher

function CustomFileSystemWatcher {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Filters,
        [Parameter(Mandatory = $true)]
        [scriptblock]$EventHandler
    )

    try
    {
        $path = Get-Location
        $watcher = New-Object -TypeName System.IO.FileSystemWatcher -Property @{
            Path = $path
            IncludeSubdirectories = $true
            NotifyFilter = [IO.NotifyFilters]::LastWrite
        }

        foreach ($str in $Filters) {
            $watcher.Filters.Add($str) | Out-Null
        }

        $handlers = . {
          Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $EventHandler
        }

        # monitoring starts now:
        $watcher.EnableRaisingEvents = $true

        Write-Host "Watching for changes to $Path"

        # since the FileSystemWatcher is no longer blocking PowerShell
        # we need a way to pause PowerShell while being responsive to
        # incoming events. Use an endless loop to keep PowerShell busy:
        do
        {
            # Wait-Event waits for a second and stays responsive to events
            # Start-Sleep in contrast would NOT work and ignore incoming events
            Wait-Event -Timeout 1
        } while ($true)
    }
    finally
    {
        # this gets executed when user presses CTRL+C:

        # stop monitoring
        $watcher.EnableRaisingEvents = $false

        # remove the event handlers
        $handlers | ForEach-Object {
          Unregister-Event -SourceIdentifier $_.Name
        }

        # event handlers are technically implemented as a special kind
        # of background job, so remove the jobs now:
        $handlers | Remove-Job

        $watcher.Dispose()

        Write-Host "Event Handler disabled, monitoring ends."
    }
}
