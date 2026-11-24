---
name: frontend-development
description: Desenvolver e revisar Front-end no padrão da equipe com Next.js, TypeScript, Tailwind e Mantine; avaliar UX/acessibilidade com referência ao Impeccable e preparar deploy.ps1 para Docker/Harbor. Usar em novos sistemas Front-end, features, revisões de interface e preparação de publicação.
metadata:
  version: "1.1.0"
---
# Desenvolvimento Front-end da equipe

## Spec-Driven Development Workflow
Todo desenvolvimento segue **SPEC → BUILD → VALIDATE → DEPLOY**, com specs em `/specs` como fonte da verdade (CONTEXT, REQUIREMENTS, DESIGN, TECHNICAL, IMPLEMENTATION, METRICS, VALIDATION, DEPLOYMENT, OPEN-ISSUES). Leia [spec-driven.md](references/spec-driven.md): consulte as specs antes de alterar código, atualize a spec correspondente (decisão e justificativa) a cada mudança relevante e não considere a entrega concluída sem cumprir `VALIDATION.spec.md`.

## Contexto e fontes
Leia [padrões da equipe](references/padroes-equipe.md). Identifique o projeto, sua versão de Next/React, gerenciador de pacotes, contratos, design system e instruções locais. Preserve convenções existentes quando o pedido não incluir migração. Antes de qualquer código Next.js, leia os guias pertinentes em node_modules/next/dist/docs/ resolvidos a partir do pacote. Não copiar configuração legada do guia de 2025 sem conferir compatibilidade.

Use [UX e evals](references/ux-evals.md) para criação/revisão de interfaces e [deploy](references/deploy.md) quando criar um sistema ou preparar sua entrega. Integre a skill companheira `$frontend-security` quando disponível para regras de segurança; se ela não estiver instalada, consulte a documentação de segurança do próprio projeto e declare o limite, sem bloquear trabalho independente.

## Desenvolver
1. Identifique a tarefa principal do usuário, dados, permissões, estados e critérios de aceite. Leia `/specs` quando existir. Aproveite README, specs, PRODUCT.md e DESIGN.md existentes; peça apenas informação que não possa inferir e mude a solução.
2. Para novo Front-end, adote Next.js/React/TypeScript, App Router, src/, alias @/*, Tailwind e Mantine com provider/tema compatíveis. Use o comando da referência e confirme opções da versão utilizada. Não recrie uma aplicação existente com create-next-app.
3. Organize componentes PascalCase, hooks, contexts, utils, services e types. Tipar fronteiras e validar dados externos; evitar any. Componentes funcionais; mover lógica pesada para hooks/utils e manter comunicação privada no servidor/BFF.
4. Tailwind é a base visual; Mantine cobre componentes complexos. CSS por componente é permitido quando necessário; index.css é global e não isola classes. Preferir .module.css para isolamento verdadeiro, respeitando o projeto. Reutilizar tokens e componentes. Não redesenhar a marca para satisfazer um detector estético.
5. Entregar fluxos reais com estados de carregamento, vazio, erro, sucesso e permissão negada quando aplicáveis. Diferenciar zero de ausência de dado. Prever teclado/foco, nomes acessíveis, contraste, responsividade e textos longos.
6. Executar checks exigidos pelo projeto e pela feature; validar interface no navegador quando houver ferramenta disponível. Código compilando não demonstra usabilidade.

## UX e avaliações
Ao criar ou alterar significativamente uma interface, aplicar o fluxo de critique/audit/detect em [ux-evals.md](references/ux-evals.md), proporcional ao escopo. Antes da mudança, registrar tarefa e expectativas; depois, observar os mesmos cenários e evidenciar regressões/correções. Usar [modelo de relatório](assets/ux-eval-report.md) quando a avaliação justificar um artefato durável.

Se Impeccable estiver disponível, consultar sua skill e comandos da versão instalada. Não alegar que a ferramenta foi executada por ter feito revisão manual. Sua instalação é uma ação separada documentada na referência, não um efeito obrigatório de toda feature. Nenhuma nota de UX equivale a pesquisa com usuários reais ou certificação de acessibilidade.

## Deploy em todo novo sistema Front-end
Todo novo sistema dentro deste padrão deve receber um deploy.ps1 adaptado ao seu repositório Harbor, Dockerfile e variáveis públicas, além das instruções de uso. Para projetos existentes, preservar o script e revisar o diff; o gerador recusa sobrescrever.

Comando reutilizável (resolver o caminho a partir desta skill, sem codificar o usuário da máquina):

```powershell
pwsh -File "<pasta-da-skill>/scripts/New-FrontendDeploy.ps1" -ProjectPath "<raiz-do-sistema>" -Repository "harbor.sistemafiea.com.br/<projeto>/<imagem>"
```

Antes, preparar Dockerfile/.dockerignore e estágios validation/runtime conforme [deploy.md](references/deploy.md). Para múltiplos sistemas, trabalhar somente na lista autorizada e informar os repositórios individualmente; não descobrir alvos por varredura e escrever em todos. Não adaptar automaticamente para APIs Python.

O script gerado distingue criar, pré-visualizar, construir e publicar. Incluir os comandos de homologação/produção e a dependência de atualização pelo DevOps no README do sistema. Criar a skill/script não autoriza push, atualização de servidor ou mensagens ao time.

## Entrega
Resumir o comportamento entregue, arquivos, checks e evals executados, falhas/limitações e preparação de deploy. Identificar o que é regra da equipe, ajuste de compatibilidade, sugestão de UX ou decisão específica do projeto. Não afirmar publicação, avaliação completa ou aprovação de segurança sem evidências.

Exemplos:
- “Use $frontend-development para criar a tela no padrão da equipe e avaliar a tarefa principal em desktop e mobile.”
- “Use $frontend-development para revisar a UX com Impeccable e registrar evals antes/depois.”
- “Use $frontend-development para gerar o deploy.ps1 deste sistema para o repositório Harbor informado.”
