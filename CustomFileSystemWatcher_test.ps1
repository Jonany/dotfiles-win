. .\CustomFileSystemWatcher.ps1

#function better-test() {
#    echo "Building..." `
#    && dotnet build --nologo --no-restore --tl:off -clp:"ErrorsOnly;NoSummary" -p:WarningLevel=0 `
#    && echo "Testing..." `
#    && dotnet test --no-build --nologo --tl:off --logger "console;verbosity=detailed" @args
#}

$eventHandler =
{
    param($FileWatcher, $EventArgs)
    Write-Output "Entering handler"
}

CustomFileSystemWatcher -Filters @("*.*") -EventHandler $eventHandler
# Nothing will run after this.
# Once the filewatcher is killed, the script will end.
# Could add an optional param that would get called in the finally block
