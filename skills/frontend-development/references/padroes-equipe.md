# Padrões da equipe e compatibilidade

## Origem
“Documentação Técnica - Front-End”, atribuída a Pedro Henrique Xavier Izidoro Lima, datada de 21/05/2025, fornecida pelo usuário em texto. Lida integralmente em 16/11/2026.

[Arquivo fornecido](<C:/Users/john.amorim/.codex/attachments/faca0b90-9b6b-4257-a6e5-9a2a8bcd9f07/Texto colado.txt>).
SHA-256: A82A27665974726C8F7EE4E532979832F2D67E3738355522939F21B209DE3F8B.

Esta síntese preserva as diretrizes úteis, retirando elementos de navegação da wiki. A URL original da página não foi fornecida. Não há consulta automática à wiki nem garantia de que esta cópia seja a revisão mais recente.

## Regras extraídas
| Tema | Diretriz da documentação | Aplicação |
| --- | --- | --- |
| Stack | Next.js, React, TypeScript, Tailwind CSS, Mantine | Provider/tema e versões compatíveis |
| Estrutura | src/components, contexts, hooks, utils, services, types, styles; public/assets e fonts opcional | Criar só pastas com uso; componentes em PascalCase |
| Estilos | Tailwind principal; CSS por componente permitido para conflito com Mantine, animações ou legibilidade | Não duplicar estilos globais desnecessários |
| Código | Componentes funcionais/hooks, tipagem clara, evitar any | Contratos tipados; lógica pesada extraída |
| Qualidade | ESLint/Prettier, revisões ativas e README | Scripts reais compatíveis com a versão; preservar checks de segurança |
| Projeto novo | TypeScript, ESLint, Tailwind, src, App Router, Turbopack e alias @/* | Conferir CLI antes de automatizar |
| Entrega | Docker, Harbor, projeto/acesso e URL alinhados com a equipe | Não inventar repositório, credenciais ou domínio |
| Operação | Após push, solicitar atualização ao DevOps pelo Teams | Preparar mensagem se necessário; enviar somente quando solicitado |

O contato de DevOps citado no documento é histórico; confirmar responsável atual antes de direcionar solicitação, sem expor dados pessoais desnecessários no pacote.

## Ajustes de compatibilidade documentados
- O guia mostra /pages/pasta/page.tsx, mas seleciona App Router no template. Para App Router, usar src/app/.../page.tsx. Pages Router existente segue suas próprias convenções; não misturar os dois por copiar o exemplo.
- index.css importado por componente é CSS comum. Isolamento de CSS Modules usa .module.css. A intenção de CSS localizado é preservada sem prometer isolamento inexistente.
- .eslintrc e tailwind.config.ts são exemplos de 2025, não arquivos obrigatórios em toda versão. Next 16 removeu next lint: executar ESLint por script e usar configuração compatível. Tailwind deve seguir a versão instalada.
- “.dockerfile” na wiki descreve o arquivo de build. Preferir Dockerfile convencional; se o projeto usa outro nome, passá-lo explicitamente ao Docker/gerador.
- NEXT_PUBLIC_* é incorporado ao cliente no build. Configuração privada deve ser lida no servidor e segredos devem ser injetados em runtime.

Os ajustes foram conferidos nos guias locais do Next instalado no workspace, em node_modules/next/dist/docs/: Installation, CSS, ESLint, Deploying e Environment Variables. Em outro projeto, reler os guias da versão dele.

## Criar novo projeto
Comando-base da documentação:

```shell
npx create-next-app@latest dataproduct-aw-nomedaaplicacaoweb
```

Selecionar TypeScript, ESLint, Tailwind, src/, App Router e alias @/*. Confirmar as opções presentes na versão executada; o diálogo pode mudar. Fixar dependências pelo lockfile após criar. Instalar/configurar Mantine e tema conforme a versão escolhida, documentar execução e conferir scripts de teste/typecheck/lint/build. Não instalar latest em um projeto existente como efeito desta instrução.
