# Skills da equipe Front-end

| Skill | Para quê |
|---|---|
| `frontend-development` | Padrão da equipe (Next.js, TypeScript, Tailwind, Mantine), UX/evals e `deploy.ps1` para Docker/Harbor |
| `frontend-security` | Diretrizes de segurança Front-end com fontes internas e verificações |

Funcionam no **Codex** (`~/.codex/skills`) e no **Claude Code** (`~/.claude/skills`).
Você precisa ter acesso de leitura a este repositório (ele é privado).

## Instalar

### Opção 1 — `npx skills` (recomendado, precisa de Node)

```bash
npx skills add fiea-observatorio/skills-observatorio -g -a claude-code -a codex -a cursor -a github-copilot -a grok
```

Instala no usuário (`-g`) e só nesses 5 agentes: Claude Code, Codex, Cursor, GitHub Copilot e Grok.
Tire os `-a` que você não usa (ex.: só `-a claude-code -a codex`). Outros IDs: `gemini-cli`, `windsurf`, `opencode`.
Sem `-a`, o CLI mostra a lista completa (~55 agentes) para escolher. Adicione `-y` para não perguntar nada.
Atualizar depois: `npx skills update`.

### Opção 2 — script (só precisa de git)

Windows (PowerShell):

```powershell
git clone git@github.com:fiea-observatorio/skills-observatorio.git $env:TEMP\team-skills; & $env:TEMP\team-skills\install.ps1
```

macOS / Linux / Git Bash:

```bash
git clone git@github.com:fiea-observatorio/skills-observatorio.git /tmp/team-skills && /tmp/team-skills/install.sh
```

Por padrão instala nas pastas de todos os agentes que existirem na máquina (Codex e/ou Claude Code).
Opções:

- só um agente: `-Agent codex` / `--agent claude`
- só uma skill: `-Skills frontend-security` / `./install.sh frontend-security`
- pasta específica (ex.: por projeto): `-Target .\.claude\skills` / `--target ./.claude/skills`

Para atualizar, rode o mesmo comando de novo (a versão anterior é substituída).
Depois de instalar, reinicie o Codex/Claude Code.

## Manter as skills

Edite em `skills/<nome>/`, suba a versão em `metadata.version` do `SKILL.md` e faça commit/push.
A equipe recebe com `npx skills update` ou rodando o script de novo.
