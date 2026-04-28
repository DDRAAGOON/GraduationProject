param(
  [string]$Configuration = "Release",
  [string]$Output = "backend-dotnet/publish",
  [string]$Runtime = "win-x64"
)

dotnet publish "backend-dotnet/Jobito.Api/Jobito.Api.csproj" `
  -c $Configuration `
  -r $Runtime `
  --self-contained true `
  /p:PublishSingleFile=false `
  -o $Output
Write-Host "Published to $Output"
