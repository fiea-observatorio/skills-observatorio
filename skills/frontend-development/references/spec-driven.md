# Spec-Driven Development Workflow — Observatório da Indústria de Alagoas

Metodologia padrão da equipe. Sequência obrigatória: **SPEC → BUILD → VALIDATE → DEPLOY**.

| Fase | O que acontece |
|---|---|
| SPEC | Definir o que será desenvolvido, suas regras e critérios |
| BUILD | Desenvolver conforme as specs aprovadas |
| VALIDATE | Conferir resultados e executar os testes previstos |
| DEPLOY | Publicar a solução e registrar a versão entregue |

## Princípios
1. **Specs como fonte da verdade**: IA e desenvolvedor consultam as specs antes de alterar código.
2. **Rastreabilidade**: toda mudança relevante atualiza a spec correspondente, registrando decisão e justificativa.
3. **Validação antes da publicação**: nenhuma entrega é concluída sem atender aos critérios das specs.

Cada spec tem uma responsabilidade; não juntar tudo num arquivo único, para que cada uma evolua sem comprometer as demais.

## Fluxo de specs

| # | Spec | Arquivo | Conteúdo |
|---|---|---|---|
| 01 | Context | `CONTEXT.spec.md` | Contexto, histórico, decisões, responsáveis, fontes de dados e regras de negócio |
| 02 | Requirements | `REQUIREMENTS.spec.md` | Objetivos, requisitos funcionais e não funcionais, escopo, critérios de aceite |
| 03 | Design | `DESIGN.spec.md` | Padrões visuais, componentes, identidade, organização das telas, comportamento da interface |
| 04 | Technical | `TECHNICAL.spec.md` | Arquitetura, estrutura de dados, fontes, cálculos, regras de transformação |
| 05 | Implementation | `IMPLEMENTATION.spec.md` | Orientações, etapas de desenvolvimento e componentes a construir |
| 06 | Validation | `VALIDATION.spec.md` | Testes, conferência dos indicadores, integridade dos dados, critérios de validação |
| 07 | Deployment | `DEPLOYMENT.spec.md` | Configuração por ambiente, variáveis, dependências, procedimento de publicação |

Complementares: `METRICS.spec.md` (glossário, indicadores e regras de cálculo) e `OPEN-ISSUES.spec.md` (questões em aberto e responsáveis).

## Estrutura recomendada do projeto

```
/projeto
├── /specs
│   ├── CONTEXT.spec.md
│   ├── REQUIREMENTS.spec.md
│   ├── DESIGN.spec.md
│   ├── TECHNICAL.spec.md
│   ├── IMPLEMENTATION.spec.md
│   ├── METRICS.spec.md
│   ├── VALIDATION.spec.md
│   ├── DEPLOYMENT.spec.md
│   └── OPEN-ISSUES.spec.md
├── /scripts
│   └── audit.py
├── /src
├── .env.example
└── README.md
```

## Correspondência com arquivos legados

| Atual | Novo | Finalidade |
|---|---|---|
| `README.md` | `README.md` | Execução, instalação e publicação |
| `CONTEXTO.md` | `specs/CONTEXT.spec.md` | Decisões, responsáveis, fontes e regras |
| `skill-layout` | `specs/DESIGN.spec.md` | Padrões visuais e de layout |
| Nota técnica | `specs/METRICS.spec.md` | Glossário, indicadores e regras de cálculo |
| `PENDENCIAS.md` | `specs/OPEN-ISSUES.spec.md` | Questões em aberto e responsáveis |
| `deploy.env.example` | `.env.example` | Variáveis de ambiente sem segredos |
| Auditoria | `specs/VALIDATION.spec.md` + `scripts/audit.py` | Regras e scripts de auditoria |

## Como aplicar (agente)
1. **Antes de codar**: verificar se `/specs` existe. Se existir, ler as specs pertinentes à tarefa. Se não existir em projeto novo, criar ao menos CONTEXT, REQUIREMENTS, DESIGN e VALIDATION com o que já é conhecido, marcando lacunas em `OPEN-ISSUES.spec.md` em vez de inventar. Em projeto existente, não migrar arquivos legados sem pedido; propor a correspondência acima.
2. **Ao implementar**: seguir as specs. Se a tarefa as contradiz ou elas estão incompletas, atualizar a spec (ou registrar em OPEN-ISSUES) com decisão e justificativa antes/junto do código.
3. **Ao validar**: executar o que `VALIDATION.spec.md` prevê (testes, `scripts/audit.py`, conferência de indicadores) e reportar o resultado contra os critérios de aceite de `REQUIREMENTS.spec.md`.
4. **Ao publicar**: seguir `DEPLOYMENT.spec.md` e [deploy.md](deploy.md); registrar a versão entregue. Variáveis vão em `.env.example`, sem segredos.
