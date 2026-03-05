@echo off
setlocal enabledelayedexpansion

echo Fetching...
git fetch --all --prune

echo Processing refs...
for /f "usebackq tokens=1,2* delims= " %%A in (`git for-each-ref --format="%%(refname) %%(upstream:track)" refs/heads`) do (
    if "%%B"=="[gone]" (
        set "branch=%%A"
        set "branch=!branch:refs/heads/=!"
        echo Running 'git branch -D ^<branch^>' for !branch!
        rem git branch -D "!branch!"
    )
)

endlocal
