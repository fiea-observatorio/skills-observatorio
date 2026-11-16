# UX, Impeccable e evals

Consulta das fontes oficiais em 16/11/2026. Esta integração é uma extensão solicitada pelo usuário; não consta no guia corporativo de 2025. A rotina de evals abaixo é proposta desta skill e não um comando “evals” inventado do Impeccable.

## Instalação e uso
Na raiz do projeto:

```shell
npx impeccable install
```

O instalador permite escolher ferramenta e escopo. Para preparação automatizada apenas da skill no projeto, a CLI documenta:

```shell
npx impeccable install -y --providers=codex --scope=project --no-hooks
```

Não usar --force para substituir customizações existentes sem necessidade explícita. Registrar a versão instalada; em CI, usar versão fixada avaliada pela equipe. Após instalação, recarregar a ferramenta se necessário. No chat do Codex:

```text
$impeccable init
$impeccable document
$impeccable critique a tela ou fluxo escolhido
$impeccable audit a tela ou fluxo escolhido
```

init registra contexto em PRODUCT.md; document registra o sistema visual em DESIGN.md. Preservar conteúdo existente e conferir o resultado. Não habilitar hooks silenciosamente: quando desejados, conferir status e ativação/trust da ferramenta. O detector manual funciona sem hooks.
Fontes: [instalação](https://impeccable.style/tutorials/getting-started/), [CLI oficial](https://www.npmjs.com/package/impeccable), [hooks](https://impeccable.style/docs/hooks/).

## Três avaliações distintas
- **critique:** clareza da tarefa, hierarquia, coerência visual e usabilidade; registra razões para a avaliação. Perspectivas simuladas não são entrevistas reais. O relatório de UX pode usar notas 0–4 e n/a, conforme a ferramenta. [Referência](https://impeccable.style/docs/critique/).
- **audit:** acessibilidade, performance, temas, responsividade e integridade da implementação. Priorização P0 bloqueante, P1 problema relevante, P2 menor e P3 acabamento; nota agregada não anula bloqueio. O modo de avaliação preserva o código. [Referência](https://impeccable.style/docs/audit/).
- **detect:** regras automatizadas de código e página renderizada. Executar no alvo real, não supor que uma análise de TSX mede contraste renderizado. [Referência](https://impeccable.style/docs/detector/).

Exemplos de terminal, adaptando pasta e porta:

```shell
npx impeccable detect --json src/
npx impeccable detect http://localhost:3000
npx impeccable detect --viewport 390x844 http://localhost:3000
```

Resultado da CLI: 0 = sem achados principais (podem existir observações); 2 = achados; 1 = falha de análise. Guardar o resultado completo e o exit code. Falha de ferramenta é não verificado, não aprovação. Resolver falsos positivos com justificativa específica e preservar a marca; não desligar uma categoria inteira para obter verde.

Não executar live mode como parte desta rotina: a referência do projeto descreve fallback que pode iniciar agente com permissões relaxadas. Esta skill usa revisão/detector convencional, sem desativar controles ou enfraquecer CSP. [README oficial](https://github.com/pbakaus/impeccable).

## Evals por tarefa — procedimento desta skill
Antes de implementar, registrar o público, a tarefa, condições iniciais, dados sintéticos, permissão e resultado observável esperado. Escolher cenários relevantes para o escopo, incluindo caminho principal e falhas de maior impacto.

| Dimensão | Exemplo de cenário observável |
| --- | --- |
| Conclusão da tarefa | Encontrar um indicador, filtrar e entender o resultado sem intervenção |
| Compreensão | Identificar filtro aplicado, período e diferença entre zero e ausência de dado |
| Recuperação | Receber erro de rede/validação e repetir sem perder contexto permitido |
| Acesso | Navegar por teclado, ver foco e operar controles com nome acessível |
| Adaptação | Concluir a tarefa em tela estreita e com zoom; texto longo não oculta ação |
| Estado e permissão | Loading, vazio, sessão expirada e acesso negado têm saída compreensível |
| Consistência | Componentes/temas preservam tokens e significado das ações |

Para cada caso, registrar **passou**, **falhou**, **não aplicável** com motivo ou **não verificado**. Evidência: rota/viewport/estado, screenshot quando útil, passos reproduzíveis e resultado. Medir tempo, erros ou performance apenas se observados; não inventar números.

Comparar antes/depois nos mesmos cenários, ambiente e dados. Para tela nova, “antes” é sem baseline, não nota zero. Priorizar tarefa bloqueada e falha de acessibilidade; reexecutar os casos afetados após corrigir. Resultado desconhecido permanece explícito.

O [modelo de relatório](../assets/ux-eval-report.md) separa observação, heurística e ferramenta. Se o pedido for apenas revisar, entregar achados sem alterar; se incluir correção, executar as correções no escopo e revalidar. Testes automatizados não substituem uso real; registrar estudo com usuários apenas se ocorreu.

## Critério de entrega proposto
Fluxos essenciais observados funcionando, nenhuma regressão bloqueante conhecida introduzida, checks técnicos executados ou limitações explícitas e evidência das correções. Pendências P0/P1 tornam a interface não pronta para entrega no escopo afetado; informar isso mesmo que a nota média seja alta. Esta é uma regra operacional da skill, não uma política corporativa atribuída à wiki.
