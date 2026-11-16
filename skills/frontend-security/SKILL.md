---
name: frontend-security
description: Aplicar diretrizes de segurança ao desenvolver, revisar ou validar código Front-end; consolidar documentos da Segurança da Informação em controles rastreáveis. Usar para segurança de interfaces, autenticação no navegador, dados, integrações e dependências. Distinguir requisitos internos comprovados de recomendações públicas.
metadata:
  version: "1.0.0"
  reference_status: "internal-project-references-analyzed"
---

# Segurança Front-end

## Base e limites

Leia primeiro [fontes e rastreabilidade](references/fontes.md). A base principal são os cinco documentos internos de Matrículas SESI, Sindicato API, Íris e Radar Front-end/API indicados pelo solicitante. São referências técnicas dos projetos; não alegue aprovação corporativa independente ou acesso aos relatórios originais de pentest citados nelas. OWASP complementa lacunas, sem substituir silenciosamente os requisitos internos.

Use [diretrizes e verificações](references/diretrizes.md) como catálogo e leia [perfis, exceções e conflitos](references/perfis-e-conflitos.md) para escolher as regras do projeto. Leia os controles pertinentes à superfície alterada; registre os demais como fora do escopo ou não aplicáveis, com justificativa. Em outro projeto, use os padrões comuns como proposta de engenharia, sem transportar papéis, rotas, domínios, prazos ou exceções automaticamente. Se o projeto não estiver identificável e a escolha afetar um requisito, peça esse esclarecimento e avance nas verificações comuns.

Distinga requisito, decisão posterior, residual documentado e pendência. Os checklists de Matrículas e Sindicato têm bloqueios expressos de merge: reporte-os no respectivo projeto. Uma exceção explícita da mesma fonte deve ser registrada com seu escopo e risco; não transforma a regra geral em conformidade nem autoriza novos casos. Se a especificação não resolver uma contradição relevante, sinalize-a e não ateste aquele controle até haver definição. A data do arquivo, sozinha, não resolve precedência normativa.

## Entender o trabalho

- Identifique se a solicitação é desenvolver/corrigir, revisar, validar ou consolidar documentação. Revisão produz achados; alteração de código depende do escopo pedido.
- Use os arquivos, diff ou funcionalidade indicados. Se o escopo não estiver explícito, derive-o do pedido e das alterações disponíveis; peça esclarecimento somente se isso mudar materialmente o resultado.
- Leia as instruções do repositório e identifique framework, versão, autenticação, dados sensíveis, fronteira cliente/servidor e serviços externos relevantes.
- Antes de escrever código Next.js, leia os guias pertinentes em `node_modules/next/dist/docs/`, resolvidos a partir do pacote que utiliza Next.js. Respeite depreciações e não presuma APIs de outra versão. Quando os guias não estiverem disponíveis, consulte a documentação oficial da versão instalada e exponha a limitação.
- Consulte a fonte técnica original quando precisar de detalhes não preservados no catálogo, quando a recomendação depender de versão, ou quando surgirem dúvidas. Não trate links indisponíveis como fontes lidas; use a síntese disponível e declare o limite.

## Aplicar os controles

### Desenvolvimento e correção

Selecione os controles aplicáveis e traduza-os em critérios verificáveis antes da implementação. Prefira mecanismos mantidos pelo framework e pelas bibliotecas já adotadas. Corrija a causa no ponto de confiança correto: esconder uma ação no navegador não implementa autorização no servidor. Se o controle depender de backend ou infraestrutura fora do escopo, registre a dependência e implemente somente a parte autorizada.

Preserve o comportamento legítimo. Não resolva bloqueios relaxando CSP/CORS, removendo autenticação ou desativando verificações sem explicitar a consequência e a decisão necessária. Não acrescente bibliotecas, coletores ou serviços apenas para cumprir uma checklist genérica.

### Revisão

Rastreie origem do dado, transformações, proteção e destino. Uma ocorrência de `innerHTML`, `localStorage` ou variável pública é um ponto de investigação, não prova isolada de vulnerabilidade. Diferencie segredos de identificadores projetados para exposição pública; preferências não sensíveis podem usar armazenamento local.

Para cada achado, registre: controle, fonte/seção, arquivo/linha observados, condição de exploração, impacto, correção proposta e evidência necessária. Separe achados comprovados de hipóteses e de dependências externas não verificadas. Use a classificação de risco da equipe se fornecida; na ausência dela, descreva impacto e pré-condições sem inventar uma classificação institucional.

### Validação

Execute verificações proporcionais às mudanças e à autorização disponível. Inclua um caso negativo para o controle de segurança e um caso legítimo para detectar regressões. Use ambiente local ou de testes autorizado e dados sintéticos. Testes invasivos em sistemas externos não decorrem da simples invocação desta skill.

Confirme headers, cookies e respostas efetivas no ambiente avaliado quando o resultado depender da entrega HTTP; configuração em um arquivo não comprova o comportamento da hospedagem. Se não puder executar algo, registre **não verificado**, nunca **atendido**. Busca textual, build, lint e scanner de dependências isolados não demonstram ausência de vulnerabilidades.

## Entrega e rastreabilidade

Apresente primeiro os achados relevantes ou o resultado da alteração. Em revisões/validações, mantenha uma tabela compacta:

| Controle e fonte | Evidência no escopo | Resultado | Ação ou dependência |
| --- | --- | --- | --- |

Resultados permitidos: **atendido no escopo avaliado**, **não atendido**, **não aplicável** (com motivo), **não verificado**. Mantenha separado o caráter da regra: recomendação pública, requisito interno comprovado ou interpretação a confirmar.

Indique arquivos alterados, verificações executadas e seus resultados, limitações e pendências. Só declare atendido um controle que tenha evidência suficiente para seu critério. Um teste falho ou uma evidência ausente não pode ser convertido em conformidade. Nenhum resultado equivale a certificação geral da aplicação ou aprovação da Segurança da Informação.

Ao consolidar material interno, produza a matriz de origem exigida em `fontes.md`, documente exclusões e atualize as referências da skill. Não copie documentos restritos para repositórios ou destinos públicos; use localização autorizada e apenas o conteúdo necessário.

## Exemplos de uso

- “Use $frontend-security para revisar a segurança dos arquivos alterados e indicar evidências por controle.”
- “Use $frontend-security para desenvolver o formulário de upload com os controles aplicáveis e validar os casos negativos.”
- “Use $frontend-security para incorporar este documento da Segurança e mapear suas seções às diretrizes Front-end.”

Para a origem das escolhas de estrutura, consulte [pesquisa de skills](references/pesquisa-skills.md). Essa pesquisa não é fonte normativa de segurança.
