function New-FileSystemWatcherWrapper {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Filters,

        [Parameter(Mandatory)]
        [ScriptBlock] $Action,

        # Optional: simple debounce to coalesce bursts (0 = disabled)
        [int] $DebounceMilliseconds = 0
    )

    # Create the watcher
    $fsw = [System.IO.FileSystemWatcher]::new($Path)
    $fsw.IncludeSubdirectories = $true
    $fsw.NotifyFilter          = [System.IO.NotifyFilters]::LastWrite
    $fsw.EnableRaisingEvents   = $true
    foreach ($str in $Filters) {
        $fsw.Filters.Add($str) | Out-Null
    }

    # Debounce support (per FullName)
    $debounce = [System.Collections.Concurrent.ConcurrentDictionary[string, datetime]]::new()
    $debounceWindow = [TimeSpan]::FromMilliseconds([math]::Max(0, $DebounceMilliseconds))

    $commonHandler = {
        param($sender, $args, $eventType)

        if ($using:DebounceMilliseconds -gt 0) {
            $key = $args.FullPath
            $now = [DateTime]::UtcNow
            $last = $null
            if ($using:debounce.TryGetValue($key, [ref]$last)) {
                if (($now - $last) -lt $using:debounceWindow) { return }
                $using:debounce[$key] = $now | Out-Null
            } else {
                [void]$using:debounce.TryAdd($key, $now)
            }
        }

        $eventData = @{
            EventType     = $eventType
            FullPath      = $args.FullPath
            Name          = $args.Name
            OldFullPath   = ($args.PSObject.Properties['OldFullPath']?.Value)
            OldName       = ($args.PSObject.Properties['OldName']?.Value)
            ChangeType    = $args.ChangeType
            TimeGenerated = (Get-Date)
            Sender        = $sender
            Args          = $args
        }

        & $using:Action $eventData
    }

    $eventHandlers += Register-ObjectEvent -InputObject $fsw -EventName Changed -SourceIdentifier ([guid]::NewGuid()) -Action {
        param($sender,$eventArgs)
        & $using:commonHandler $sender $eventArgs 'Changed'
    }

    # Return a controller object that supports Stop/Dispose
    $obj = [pscustomobject]@{
        PSTypeName            = 'FSW.Wrapper.Controller'
        Path                  = $Path
        Filters               = $wildcards
        IncludeSubdirectories = [bool]$IncludeSubdirectories
        EventTypes            = @('Changed')
        NotifyFilters         = [System.IO.NotifyFilters]::LastWrite
        DebounceMilliseconds  = $DebounceMilliseconds
        Watcher               = $fsw
        Subscriptions         = $eventHandlers
        IsActive              = $true
        Stop = {
            if ($this.IsActive) {
                foreach ($sub in $this.Subscriptions) {
                    try { Unregister-Event -SubscriptionId $sub.Id -ErrorAction SilentlyContinue } catch {}
                }
                $this.Subscriptions = @()
                try { $this.Watcher.EnableRaisingEvents = $false } catch {}
                try { $this.Watcher.Dispose() } catch {}
                $this.IsActive = $false
            }
        }.GetNewClosure()
        Dispose = {
            $this.Stop.Invoke()
        }.GetNewClosure()
    }

    return $obj
}

$callback = {
    param($e)
    # $e is a hashtable with event data
    "{0:HH:mm:ss} [{1}] {2}" -f $e.TimeGenerated, $e.EventType, $e.FullPath | Write-Host
}

$ctrl = New-FileSystemWatcherWrapper `
    -Path "C:\Temp" `
    -Filters @("*.csv","*.log","data-*.json") `
    -Action $callback `
    -EventTypes @('Created','Changed','Deleted','Renamed') `
    -IncludeSubdirectories `
    -DebounceMilliseconds 150
Write-Host "Watching... press Enter to stop."
[void][Console]::ReadLine()

# Cleanup
$ctrl.Dispose()
