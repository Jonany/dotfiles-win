function rmcls {
    param (
        [Parameter(Mandatory)]
        [string]$rmString
    )
    rm $rmString && clear && ls
}

