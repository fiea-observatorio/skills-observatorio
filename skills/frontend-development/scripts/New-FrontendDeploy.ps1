#requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$ProjectPath,
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9][a-z0-9.-]*(?::[0-9]{1,5})?/[a-z0-9]+(?:[._-][a-z0-9]+)*(?:/[a-z0-9]+(?:[._-][a-z0-9]+)*)*$')]
    [string]$Repository,
    [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9._-]*$')]
    [string]$Dockerfile = 'Dockerfile'
)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
if (-not (Test-Path -LiteralPath $projectRoot -PathType Container)) { throw 'ProjectPath deve ser uma pasta.' }
$packagePath = Join-Path $projectRoot 'package.json'
if (-not (Test-Path -LiteralPath $packagePath)) { throw 'package.json ausente: gerador destinado a Front-end Next.js.' }
$package = Get-Content -Raw -LiteralPath $packagePath | ConvertFrom-Json
if (-not ($package.dependencies.next -or $package.devDependencies.next)) { throw 'Next.js nao encontrado. Adaptar o fluxo manualmente para outra stack.' }
$dockerPath = Join-Path $projectRoot $Dockerfile
if (-not (Test-Path -LiteralPath $dockerPath -PathType Leaf)) { throw 'Prepare o Dockerfile com estagios validation e runtime conforme a referencia de deploy.' }
$dockerText = Get-Content -Raw -LiteralPath $dockerPath
foreach ($stage in @('validation', 'runtime')) {
    if ($dockerText -notmatch ('(?im)^\s*FROM\s+[^\r\n]+\s+AS\s+' + $stage + '\s*(?:#.*)?$')) {
        throw "Estagio $stage ausente no Dockerfile. Consulte references/deploy.md."
    }
}
$destination = Join-Path $projectRoot 'deploy.ps1'
if (Test-Path -LiteralPath $destination) { throw 'deploy.ps1 ja existe. Revise e adapte o arquivo existente; o gerador nao sobrescreve.' }
$template = Join-Path $PSScriptRoot '../assets/deploy.ps1.template'
$content = (Get-Content -Raw -LiteralPath $template).Replace('__REPOSITORY__', $Repository).Replace('__DOCKERFILE__', $Dockerfile)
if ($PSCmdlet.ShouldProcess($destination, 'Criar script de deploy do sistema')) {
    [System.IO.File]::WriteAllText($destination, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Output "Criado: $destination"
}
