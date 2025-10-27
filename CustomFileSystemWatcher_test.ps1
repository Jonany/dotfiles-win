. .\CustomFileSystemWatcher.ps1

$eventHandler = { param($watcher, $event)
    Write-Host "Entering handler"
}
CustomFileSystemWatcher -Filters @("*.*") -EventHandler $eventHandler
# Nothing will run after this.
# Once the filewatcher is killed, the script will end.
# Could add an optional param that would get called in the finally block
