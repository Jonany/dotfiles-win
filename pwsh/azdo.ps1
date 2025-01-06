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

