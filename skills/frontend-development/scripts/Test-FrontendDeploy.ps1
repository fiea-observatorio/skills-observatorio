#requires -Version 7.0
# Executes in an isolated fixture. Docker is mocked; no network/build/push occurs.
$ErrorActionPreference = 'Stop'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('frontend-deploy-test-' + [guid]::NewGuid().ToString('N'))
[IO.Directory]::CreateDirectory($testRoot) | Out-Null
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { throw "FAIL: $Message" } }
function Expect-Failure([scriptblock]$Action, [string]$Message) {
    $failed = $false
    try { & $Action | Out-Null } catch { $failed = $true }
    Assert-True $failed $Message
}
$packageText = '{"dependencies":{"next":"16.0.0"},"scripts":{"test":"test-command","typecheck":"typecheck-command","lint":"lint-command","build":"build-command"}}'
[IO.File]::WriteAllText((Join-Path $testRoot 'package.json'), $packageText)
[IO.File]::WriteAllText((Join-Path $testRoot 'package-lock.json'), '{}')
[IO.File]::WriteAllText((Join-Path $testRoot 'Dockerfile'), "FROM node:22 AS validation`nFROM validation AS runtime`n")
[IO.File]::WriteAllText((Join-Path $testRoot '.dockerignore'), ".env`n.env.*`n.git`n")
[IO.File]::WriteAllText((Join-Path $testRoot '.env'), 'SYNTHETIC_PRIVATE_MARKER=never-read-or-print')
$originalEnvHash = (Get-FileHash -LiteralPath (Join-Path $testRoot '.env')).Hash
$generator = Join-Path $PSScriptRoot 'New-FrontendDeploy.ps1'
& $generator -ProjectPath $testRoot -Repository 'harbor.example.invalid/test/frontend'
$deploy = Join-Path $testRoot 'deploy.ps1'
Assert-True (Test-Path -LiteralPath $deploy) 'generator creates deploy'
$global:FrontendDeployCalls = [Collections.Generic.List[string]]::new()
$global:FrontendDeployFail = ''
function global:docker {
    $call = $args -join ' '
    $global:FrontendDeployCalls.Add($call)
    $global:LASTEXITCODE = if ($global:FrontendDeployFail -and $call.Contains($global:FrontendDeployFail)) { 9 } else { 0 }
}
$preview = (& $deploy -Tag latest -SomenteEnv 6>&1 | Out-String)
Assert-True ($global:FrontendDeployCalls.Count -eq 0) 'preview never calls Docker'
Assert-True (-not $preview.Contains('never-read-or-print')) 'preview does not reveal env'
Assert-True ((Get-FileHash -LiteralPath (Join-Path $testRoot '.env')).Hash -eq $originalEnvHash) 'preview leaves env unchanged'
Assert-True ($preview.Contains('homologacao')) 'latest maps to homologacao'
& $deploy -Tag stable
Assert-True ($global:FrontendDeployCalls.Count -eq 2) 'default performs validation and build only'
Assert-True ($global:FrontendDeployCalls[1].Contains('AMBIENTE=producao')) 'stable maps to producao'
Assert-True (-not ($global:FrontendDeployCalls -match '^push ')) 'default never pushes'
$global:FrontendDeployCalls.Clear()
& $deploy -Tag latest -Publish
Assert-True ($global:FrontendDeployCalls.Count -eq 3 -and $global:FrontendDeployCalls[2].StartsWith('push ')) 'explicit publish pushes after builds'
foreach ($failure in @('--target validation', '--target runtime', 'push ')) {
    $global:FrontendDeployCalls.Clear()
    $global:FrontendDeployFail = $failure
    Expect-Failure { & $deploy -Tag stable -Publish } "failure propagates: $failure"
    if ($failure -ne 'push ') { Assert-True (-not ($global:FrontendDeployCalls -match '^push ')) 'failed build never pushes' }
}
$global:FrontendDeployFail = ''
$global:FrontendDeployCalls.Clear()
Expect-Failure { & $deploy -Tag latest -DryRun -Publish } 'conflicting flags rejected'
Expect-Failure { & $deploy -Tag typo -DryRun } 'unknown environment rejected'
Expect-Failure { & $generator -ProjectPath $testRoot -Repository 'harbor.example.invalid/test/frontend' } 'existing deploy not overwritten'
Expect-Failure { & $generator -ProjectPath $testRoot -Repository "bad';payload" } 'repository injection rejected'
$configPath = Join-Path $testRoot 'public.json'
[IO.File]::WriteAllText($configPath, '{"latest":{"NEXT_PUBLIC_API_KEY":"synthetic"}}')
Expect-Failure { & $deploy -Tag latest -DryRun -PublicConfig $configPath } 'secret-like build key rejected'
[IO.File]::WriteAllText($configPath, '{"latest":{"NEXT_PUBLIC_APP_LABEL":"quoted value with spaces"}}')
$publicPreview = (& $deploy -Tag latest -DryRun -PublicConfig $configPath 6>&1 | Out-String)
Assert-True (-not $publicPreview.Contains('quoted value with spaces')) 'public preview lists names, not values'
[IO.File]::WriteAllText((Join-Path $testRoot 'Dockerfile.dockerignore'), ".env`n.git`n")
Expect-Failure { & $deploy -Tag latest -DryRun } 'Dockerfile-specific ignore takes precedence'
[IO.File]::WriteAllText((Join-Path $testRoot 'Dockerfile.dockerignore'), ".env`n.env.*`n.git`n!.env.production`n")
Expect-Failure { & $deploy -Tag latest -DryRun } 'unsafe env reinclusion rejected'
[IO.File]::WriteAllText((Join-Path $testRoot 'Dockerfile.dockerignore'), ".env`n.env.*`n.git`n")
[IO.File]::WriteAllText((Join-Path $testRoot 'package.json'), '{"dependencies":{"next":"16"},"scripts":{"build":"build"}}')
Expect-Failure { & $deploy -Tag latest -DryRun } 'missing mandatory checks rejected'
Assert-True ($global:FrontendDeployCalls.Count -eq 0) 'invalid configuration never invokes Docker'
Write-Output "PASS: generation, preview, tag mapping, opt-in push, native failures, no overwrite, secret guards and preconditions. Fixture: $testRoot"
