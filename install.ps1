<#
.SYNOPSIS
  Instala as skills da equipe (frontend-security, frontend-development) no Codex e/ou Claude Code.

.EXAMPLE
  # De dentro de um clone do repositório
  .\install.ps1

.EXAMPLE
  # Outra origem
  .\install.ps1 -Repo <url-git>   # baixa o repositório indicado em vez de usar o clone local

.PARAMETER Agent
  codex, claude ou all. Padrão: all (instala em todos os agentes cuja pasta existe; se nenhuma existir, usa codex).

.PARAMETER Skills
  Lista de skills a instalar. Padrão: todas da pasta skills/.

.PARAMETER Repo
  URL git do repositório. Usado só quando o script não está rodando de dentro de um clone.

.PARAMETER Target
  Pasta de destino explícita (ignora -Agent). Útil para testes ou instalação por projeto (ex.: .\.claude\skills).
#>
[CmdletBinding()]
param(
    [ValidateSet('all', 'codex', 'claude')]
    [string]$Agent = 'all',
    [string[]]$Skills,
    [string]$Repo = $env:TEAM_SKILLS_REPO,
    [string]$Target
)

$ErrorActionPreference = 'Stop'
$DefaultRepo = 'git@github.com:fiea-observatorio/skills-observatorio.git'

# 1. Localiza a origem: o próprio clone ou um clone temporário
$source = $null
$tempClone = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot 'skills'))) {
    $source = Join-Path $PSScriptRoot 'skills'
} else {
    if (-not $Repo) { $Repo = $DefaultRepo }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'git não encontrado no PATH.' }
    $tempClone = Join-Path ([IO.Path]::GetTempPath()) ("team-skills-" + [guid]::NewGuid().ToString('N'))
    Write-Host "Baixando $Repo ..."
    git clone --depth 1 --quiet $Repo $tempClone
    if ($LASTEXITCODE -ne 0) { throw "Falha ao clonar $Repo (verifique acesso ao repositório)." }
    $source = Join-Path $tempClone 'skills'
}

try {
    if (-not (Test-Path $source)) { throw "Pasta skills/ não encontrada em $Repo." }
    $available = @(Get-ChildItem $source -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') })
    if (-not $available) { throw "Nenhuma skill (SKILL.md) encontrada em $source." }
    if ($Skills) {
        $missing = $Skills | Where-Object { $_ -notin $available.Name }
        if ($missing) { throw "Skill(s) inexistente(s): $($missing -join ', '). Disponíveis: $($available.Name -join ', ')" }
        $available = $available | Where-Object { $_.Name -in $Skills }
    }

    # 2. Define os destinos
    $homeDir = [Environment]::GetFolderPath('UserProfile')
    $agents = [ordered]@{
        codex  = Join-Path $homeDir '.codex'
        claude = Join-Path $homeDir '.claude'
    }
    if ($Target) {
        $targets = @($Target)
    } elseif ($Agent -ne 'all') {
        $targets = @(Join-Path $agents[$Agent] 'skills')
    } else {
        $targets = @($agents.Values | Where-Object { Test-Path $_ } | ForEach-Object { Join-Path $_ 'skills' })
        if (-not $targets) { $targets = @(Join-Path $agents.codex 'skills') }
    }

    # 3. Copia (substitui versão anterior da mesma skill)
    foreach ($t in $targets) {
        New-Item -ItemType Directory -Force -Path $t | Out-Null
        foreach ($s in $available) {
            $dest = Join-Path $t $s.Name
            if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
            Copy-Item -Recurse $s.FullName $dest
            Write-Host ("  ok  {0} -> {1}" -f $s.Name, $dest)
        }
    }
    Write-Host "Pronto. Reinicie o Codex/Claude Code para carregar as skills."
} finally {
    if ($tempClone -and (Test-Path $tempClone)) { Remove-Item -Recurse -Force $tempClone }
}
