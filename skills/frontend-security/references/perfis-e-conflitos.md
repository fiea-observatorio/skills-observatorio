# Perfis, exceções e conflitos

Leia com o [catálogo](diretrizes.md). IDs MAT/SIN/IRI/RFE/RAPI/SEN remetem aos documentos em [fontes.md](fontes.md). Exceções são registros da fonte, sem renovação ou ampliação automática por esta skill.

## Matrículas SESI

- **Audiência e login:** §0 e §3 descrevem fase interna sem login, mas SEC1 e SEC5 registram, desde 21/09/2026, publicação pública com login iDigital. Para essa fase, use sessão autenticada e os papéis de §0. Registre SEC7/rede como trecho inconsistente com a decisão posterior; não conclua que rede é o único controle atual.
- **Papéis:** Auditoria: admin/obs/sesi. Alunos Matriculados: admin em produção, também sesi fora de produção conforme decisão de 11/11/2026. Operacional: seção própria de 13/11/2026 herda papéis da tela 4, mas a tabela geral cita Operacional só local. Sem confirmação do ambiente vigente, não conceder acesso remoto com base apenas na herança; registrar a divergência. Não conceder acesso ao papel user só porque ele passou no SSO.
- **Dados:** buscas por nome/RA no corpo POST, nunca na URL; respostas pessoais no-store; paginação no servidor. Auditoria não recebe CPF/e-mail/telefone. Telefone é exceção da tela 4; telefone/e-mail, da Operacional, com os papéis e ambientes específicos. Páginas de 50/teto 100 e memória de aproximadamente 500 linhas são parâmetros do produto, não limites universais.
- **Cookies:** §2 prescreve SameSite=Strict, enquanto SEC1 registra Lax para o SSO. Tratar Lax como decisão específica desse fluxo; não impor Strict sem validar o retorno OIDC e não remover proteção CSRF.
- **CSP:** S3, §1 e §4 proíbem unsafe-inline em scripts e pedem nonce, mas SEC9 aceita CSP estática com unsafe-inline nesta etapa e deixa nonce para a próxima. Registrar residual e não declarar o requisito de nonce atendido. Estilos inline de Mantine/Tailwind são um residual separado.
- **BFF/borda:** §4 exige impedir exposição direta do backend, mas SEC8 mantém /api/ roteado ao Flask. É conflito de entrega ainda relevante: verificar a borda real e não atestar isolamento do BFF a partir do código do proxy.
- **Feedback:** BFF, chave privada, limite de corpo de 16 KB, egress restrito ao fornecedor indicado na fonte; contexto anexado opt-in e visível. Não reutilizar esse fornecedor ou número automaticamente em outro produto.
- **Pendências:** SEC2 operador da CSP; SEC3 base legal/retenção inclusive CSV; SEC4 rotação de credenciais; SEC10 login restrito para substituir o login BI. Não afirmar que são resolvidas pela skill. Não reproduzir valores de credenciais das fontes.

## Sindicato API / Front-end consumidor

- API é autoridade de perfil, permissões e escopo por sindicato; front recebe permissões para navegação. Usuários comuns não escolhem o próprio sindicato; concessão administrativa autorizada é exceção explícita à proibição de campos de autorização.
- Restringir associação nominal a Unidade Sindical/Observatório. Testar isolamento horizontal e vertical, inclusive existência de objetos (404 quando essa informação for sensível).
- Refresh rotativo com sessão única: serializar tentativas concorrentes do front, respeitando o escopo real de concorrência do BFF/abas/réplicas; um booleano por componente não garante coordenação global. Evitar laços de retry. Usuário desativado ou versão de sessão revogada perde acesso na próxima requisição.
- Tokens da API em cookie HttpOnly do servidor Next; API não emite cookie. Access de 30 min (máximo 60), refresh de 7 dias são parâmetros deste contrato, não parâmetros comuns do Front-end.
- S2/S8/S9/S20/S23–S25 e SEC7–SEC19 trazem achados/pendências da avaliação de 06/10/2026. Validar estado atual antes de repetir números, CVEs ou alegar vulnerabilidade ainda aberta.
- SEC5 admite segredo dentro da imagem apenas como residual da etapa atual, contradizendo o objetivo de não incluir segredos em artefatos. Não replicar .env.imagem em novos projetos. Adotar injeção em runtime; registrar migração pendente no sistema existente. Não executar rotação ou limpeza de registry ao simplesmente revisar código.

## Íris

- V1 tem autenticação simulada e dados simulados; não é um padrão reutilizável de autenticação de produção. Mudança para dados/API reais exige os controles da seção “Quando a API entrar”.
- Mensagem do usuário em texto React; resposta Markdown sem HTML cru/rehype-raw, sem imagem externa; links protegidos com noopener/noreferrer. Saída do modelo é não confiável.
- Conversas enviadas e respostas apenas em memória. Exceção I27: rascunho não enviado por conversa, máximo 20 entradas, 7 dias, apagado ao enviar. Preferências de tema/acessibilidade e marca de sessão simulada são outras permissões específicas. Não expandir I27 para histórico nem transportar a exceção para Matrículas.
- CSP sem origem externa, connect-src self. unsafe-inline em scripts/estilos é residual declarado, não exigência geral; unsafe-eval e ws só no desenvolvimento. A referência a “mesmos residuais do Matrículas” não elimina a divergência entre exigência e decisão daquele documento.
- O achado de dependências de 07/10/2026 é histórico. Não aplicar audit fix --force que rebaixa framework; reavaliar versão e alcance. A ausência da dependência na imagem não elimina todo risco de build/CI.

## Radar Front-end + API

- Implantação pública usa APP_AUDIENCE=external e responde 404 nas rotas administrativas citadas na fonte; administração apenas internal. Esta separação não deve ser aplicada às telas públicas autenticadas do Matrículas por analogia.
- ADMIN_SESSION_MAX_AGE_SECONDS até 3600; API_URL no servidor, APP_ORIGIN exata. São nomes e limite do Radar (também mencionados em MAT), não regra para toda aplicação.
- CSP com nonce por resposta; script-src sem unsafe-inline. Não importar o residual aceito em Íris/Matrículas. Verificar o header entregue pela borda.
- **URLs:** allowlist de hosts para imagens/embeds. Evidências/referências admitem fontes públicas arbitrárias; validar HTTPS, ausência de credenciais, porta 443 e endereço público. Não exigir a mesma allowlist de conteúdo carregado para citações. A API não busca as URLs de evidência; se passar a buscá-las, reavaliar SSRF e contrato.
- API: armazenamento compartilhado de limite entre processos; IP só de cadeia/cabeçalho cuja sobrescrita pela borda seja comprovada. Não copiar CF-Connecting-IP nem quantidade de saltos sem conhecer a topologia. JWT identifica requisição autenticada; anônimas usam IP efetivo.
- Catálogo público: 120 requisições/minuto com 429/Retry-After, conforme fonte. Não copiar esse orçamento para login ou outro sistema. Diagnóstico temporário de headers contém IP e deve ser desligado após a análise.

## Matrículas SENAI (Painel de Acompanhamento)

Produto distinto de Matrículas SESI: não transportar papéis, telas ou exceções de um para o outro. Arquitetura avaliada: SPA React/Vite servida por nginx, API Express no mesmo host, login iDigital (OIDC com PKCE, JWT RS256), cálculo dos indicadores no navegador a partir da base completa entregue pela API. O teste confirmou como pontos fortes: transporte HTTPS com redirecionamento, CORS sem refletir origem estranha, rejeição de `alg: none` e de confusão de algoritmo.

| Achado SEN | Controle | Relatório 04/11 | Reteste 06/11 | Resposta 10/11 (não retestada) |
| --- | --- | --- | --- | --- |
| #01 Infraestrutura interna no campo `fonte` | FE-16 | Média, aberto | Parcial: ainda citava código de relatório BI | Corrigido segundo o desenvolvimento |
| #02 RA de alunos no payload | FE-02 | Baixa, aberto | Corrigido: pseudônimo HMAC de 16 caracteres | Corrigido |
| #03 Recarga de dados por qualquer usuário, sem limite | FE-05/FE-06 | Baixa, aberto | Média, aberto: dois POST seguidos com 200 | Corrigido: 200, 429, 429 com Retry-After |
| #04 CSP sem `default-src`/`script-src` | FE-08 | Baixa, aberto | Corrigido; `style-src 'unsafe-inline'` residual | Corrigido |
| #05 Receita/custo/margem para toda sessão | FE-02/FE-05 | Informativo | Aberto | Risco aceito por decisão do cliente |
| #06 Erros distinguem motivo da recusa de sessão | FE-13 | Informativo | Corrigido | Corrigido |
| #07 Sem `Cache-Control: no-store` | FE-02 | Informativo | Corrigido | Corrigido |
| #08 Health expõe modo de autenticação | FE-16 | Informativo | Corrigido | Corrigido |
| #09 Fingerprint (`Server: nginx`, ETag Express) | FE-16 | Informativo | Parcial | Corrigido no header; bibliotecas do bundle como residual |

- **Estado:** a resposta de 10/11/2026 declara as correções publicadas em homologação e produção, mas não há reteste posterior entre as fontes. Tratar #01, #03 e #09 como **corrigido segundo o desenvolvimento, não verificado** até novo reteste ou verificação própria na resposta efetiva.
- **#05 risco aceito:** a área dona decidiu que receita, custo, resultado e margem ficam visíveis a qualquer sessão iDigital da empresa. A API já tem controle por lista de e-mails/domínios ativável sem implantação. Registrar como risco aceito; não declarar FE-05 atendido para esses campos nem reutilizar a decisão em outro painel.
- **#02 residual de desenho:** pseudônimo estável permite correlacionar o mesmo aluno entre turmas por qualquer sessão; aceitável para a contagem distinta, mas não reutilizar o pseudônimo fora do painel nem expor a chave HMAC. O campo continua chamado `ra`; renomear numa próxima versão.
- **Residuais informativos:** `style-src 'unsafe-inline'` (estilos calculados do React e html2canvas) e identificação de bibliotecas do bundle (React, SheetJS, html2canvas).
- Não reproduzir em código, testes ou documentos os IPs, instâncias, bancos, tabelas ou URL de produção citados nos relatórios.

## Itens excluídos da implementação automática Front-end

Migrations, backup/restauração, contas de banco, TLS de SQL Server, promoção inicial de administrador, rotação de credenciais, alterações de DNS/proxy e limpeza de imagens/histórico dependem de backend/infraestrutura e autorização específica. Registrar a dependência quando impactarem o controle, sem executá-los como efeito da skill. “robots.txt” e URL não divulgada não são autenticação. Checklist visual, convenções de pasta e indicadores de negócio pertencem à skill de desenvolvimento; não tratá-los como vulnerabilidades sem impacto demonstrado.
