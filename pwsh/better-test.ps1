Set-StrictMode -Version Latest

function better-test() {
    echo "Building..." `
    && dotnet build --nologo --no-restore --tl:off -clp:"ErrorsOnly;NoSummary" -p:WarningLevel=0 `
    && echo "Testing..." `
    && dotnet test --no-build --nologo --tl:off --logger "console;verbosity=detailed" @args
}
