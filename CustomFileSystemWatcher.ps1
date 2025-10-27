# WORK IN PROGRESS
# Kickstarted by https://powershell.one/tricks/filesystem/filesystemwatcher

# I think I need to add some sort of debounce functionality
# because I don't want the handler running on each change.
# I think that would clog everything up.
# I also need some way to checking if the handler is already running.
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

        $lastAction = Get-Date
        $action = {
            Write-Host Last Action: $lastAction
            $curr = Get-Date
            $date_diff = New-TimeSpan -Start $lastAction -End $curr
            $lastAction = Get-Date
            if ($date_diff.TotalMilliseconds -lt 1000) {
                Write-Host Skipping...
            } else {
                Write-Host Running custom handler
                # & $EventHandler $event
                # This seems to be hanging
            }
        }

        $handlers = . {
          Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action
        }

        # Monitoring starts now
        $watcher.EnableRaisingEvents = $true

        Write-Host "Watching for changes to $Path"

        # Since the FileSystemWatcher is no longer blocking PowerShell
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
        # This gets executed when user presses CTRL+C:

        # Stop monitoring
        $watcher.EnableRaisingEvents = $false

        # Remove the event handlers
        $handlers | ForEach-Object {
          Unregister-Event -SourceIdentifier $_.Name
        }

        # Event handlers are technically implemented as a special kind of background job, so remove the jobs now:
        $handlers | Remove-Job

        $watcher.Dispose()

        Write-Host "Event Handler disabled, monitoring ends."
    }
}
