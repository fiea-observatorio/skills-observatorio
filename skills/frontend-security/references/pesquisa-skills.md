# Pesquisa de skills utilizadas como referência

Consulta realizada em 16/11/2026, antes da criação desta skill. Objetivo: examinar padrões de estrutura e aplicação em skills populares. Não foram instalados ou executados pacotes externos nesta pesquisa.

## Seleção e evidência de popularidade

| Skill | Adoção exibida no diretório | Fonte examinada | O que aproveitamos |
| --- | --- | --- | --- |
| Vercel React Best Practices | aproximadamente 904,2 mil instalações | [SKILL.md oficial](https://github.com/vercel-labs/agent-skills/blob/main/skills/react-best-practices/SKILL.md) | Controles identificáveis, categorias e consulta a detalhes conforme a necessidade. |
| Vercel Web Design Guidelines | aproximadamente 868,8 mil instalações | [SKILL.md oficial](https://github.com/vercel-labs/agent-skills/blob/main/skills/web-design-guidelines/SKILL.md) | Revisão ancorada em diretrizes e achados localizáveis em arquivo/linha. |
| Anthropic Frontend Design | aproximadamente 1,1 milhão de instalações | [SKILL.md oficial](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md) | Descrição clara do escopo e orientações específicas do domínio. |

Os números são uma fotografia aproximada do [ranking skills.sh](https://skills.sh/), não uma auditoria de uso. Conferimos também os repositórios dos mantenedores: [Vercel](https://github.com/vercel-labs/agent-skills), com cerca de 34,2 mil estrelas, e [Anthropic](https://github.com/anthropics/skills), com cerca de 195,8 mil. Estrelas são do repositório inteiro. Popularidade ajuda na seleção de exemplos, mas não prova qualidade de segurança.

Essas skills tratam principalmente de performance, interfaces e design. Foram referências de organização; os controles de segurança foram fundamentados principalmente nos cinco documentos internos fornecidos posteriormente pelo solicitante, com OWASP como complemento, conforme `fontes.md`.

## Decisões para esta skill

- Entrada curta com modos de desenvolvimento, revisão e validação; catálogo detalhado separado.
- Controles FE próprios, ligados às fontes originais, à responsabilidade de implementação e às verificações sugeridas.
- Registro explícito de evidência ausente, conflitos e exceções de cada documento interno, evitando falsa conclusão de conformidade.
- Possibilidade de incorporar documento oficial e manter rastreabilidade entre regra e implementação.

A estrutura usa `SKILL.md`, `references/` e metadados opcionais em `agents/openai.yaml`, conforme a [documentação oficial de criação de skills](https://learn.chatgpt.com/docs/build-skills). O conteúdo foi redigido para esta necessidade; nenhuma skill externa foi integralmente copiada.
