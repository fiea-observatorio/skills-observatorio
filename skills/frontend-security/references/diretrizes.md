# Diretrizes de segurança Front-end

Versão 1.1.0, consolidada em 16/11/2026. Fonte principal: cinco specs internas e o ciclo de avaliação de segurança do Painel de Matrículas SENAI (SEN: relatório, reteste e respostas), indicados pelo solicitante. Achados SEN são falhas observadas em produção e servem de casos de teste obrigatórios para superfícies equivalentes. A matriz de [fontes](fontes.md) identifica cada seção. Consulte [perfis e conflitos](perfis-e-conflitos.md) antes de aplicar uma exceção. Os IDs FE são próprios desta skill. “Bloqueante” abaixo só tem alcance no projeto que o declarou.

## FE-01 — Renderização, Markdown e URLs

**Origem:** MAT S3/S5, §2/§6; SIN S5, Entrada/Saída; IRI Renderização; RFE/RAPI URLs. **Responsável:** Front-end e API produtora do dado.

Renderizar texto de usuário, gráfico, API e modelo sem concatenar HTML/SVG. Em MAT, dangerouslySetInnerHTML é proibido por padrão; exceção requer sanitização, justificativa e aprovação de revisão, com bloqueio expresso no checklist. IRI não admite HTML cru/rehype-raw nem imagens nas respostas. Validar cores de dado antes de estilos, preferindo tokens do design system.

Validar URLs na entrada/saída da API e antes do uso no front. Aplicar esquema HTTPS e o filtro de destino do perfil: MAT exige host permitido; Radar distingue imagens/embeds de links de evidência. Não estender uma allowlist para citações arbitrárias nem aceitar javascript/data por serem retornados pelo backend. Links de nova aba na Íris usam noopener/noreferrer.

**Verificar:** marcação maliciosa permanece inerte; protocolos/destinos indevidos são rejeitados; links e rótulos legítimos continuam funcionando. Ocorrência da API perigosa isoladamente não prova exploração.

## FE-02 — Dados pessoais, armazenamento e minimização

**Origem:** MAT §0/§2/Auditoria/§6; SIN §0/S22/S24; IRI Dados no navegador; SEN #02/#05/#07. **Responsável:** Front-end e API.

Dados pessoais, texto livre/conversas, tokens e senhas não vão para URL, storage ou logs. Preservar somente as exceções explícitas do perfil (preferências de UI e rascunho I27 na Íris). Buscar dados pessoais por corpo de requisição conforme contrato. Filtrar/paginar no servidor e retornar apenas campos/linhas usados pela tela; esconder no cliente não evita exposição. Aplicar no-store aos fluxos sensíveis descritos pelas fontes.

Painel que calcula indicadores no navegador recebe a base inteira: tudo no payload é exposto a qualquer sessão, mesmo o que a tela não mostra (SEN #02/#05). Antes de adotar cálculo no cliente, listar cada coluna do payload e justificar sua necessidade. Preferir agregação no servidor; se o cálculo precisar cruzar a mesma pessoa entre registros, enviar pseudônimo gerado no servidor (HMAC com chave só no servidor, sem caminho de volta), nunca matrícula, RA, CPF ou outro identificador real. Não manter o nome do campo original (`ra`) para o pseudônimo, pois sugere dado pessoal e induz reuso indevido. Colunas sensíveis de negócio (receita, custo, margem, resultado) seguem a política de acesso definida pelo dono do dado; se ele decidir expô-las a toda sessão, registrar a decisão como risco aceito com responsável e data, não como conformidade. Respostas de API com dados de usuário ou de negócio enviam `Cache-Control: no-store` (SEN #07), inclusive `/me` e dados agregados volumosos.

**Verificar:** rede, URL, storage, cache e logs com dados sintéticos; logout/Voltar; ausência de campos sensíveis não exibidos; TTL/limite/remoção de rascunhos quando I27 se aplicar; inventário de chaves do payload confrontado com o que a tela usa; identificador pessoal ausente ou pseudonimizado de forma não reversível; header `Cache-Control` efetivo. Não copiar dados reais para fixtures.

## FE-03 — Sessão, BFF e renovação

**Origem:** MAT S12/S13/SEC1/SEC8; SIN S12/S13/Refresh rotativo/SEC1/SEC4; RFE Configuração/Publicação; IRI fase API. **Responsável:** Front-end/BFF/API.

Tokens ficam em cookies HttpOnly/Secure do servidor Front-end, não em localStorage; SameSite e duração seguem o perfil. Browser chama BFF de mesma origem; URL privada e credencial da API permanecem no servidor. Validar sessão no servidor, não por presença de cookie. Tratar 401/403 durante o uso; desativação/revogação não pode manter acesso. No Sindicato, coordenar refresh concorrente para não reutilizar token rotacionado; evitar retry infinito.

**Verificar:** rota direta sem sessão; sessão inválida/expirada/revogada; requisições concorrentes durante refresh; tráfego sem credencial privada no navegador. Sem acesso ao backend, registrar não verificado. Verificar a exposição real da API na borda separadamente.

## FE-04 — CSRF (complementar)

**Origem:** OW-CSRF; não há regra interna específica suficiente nas cinco fontes. **Responsável:** BFF/API.

Para credenciais enviadas automaticamente pelo navegador, avaliar proteção mantida pelo framework, token e/ou validação de origem/Fetch Metadata adequada ao fluxo. Não tratar CORS ou SameSite como proteção universal nem impor token sem examinar a arquitetura. GET não deve alterar estado.

**Verificar:** operação legítima aceita e operação forjada de outra origem recusada; se houver token, testar ausência/invalidez. Classificar como recomendação complementar, não descumprimento de requisito interno inventado.

## FE-05 — Permissões, autoria e isolamento

**Origem:** MAT S4/S7/S12–S14/Papéis/§6; SIN §0/Autorização/§6/SEC2/SEC3; SEN #03/#05. **Responsável:** API; Front-end apresenta o resultado.

Identidade, papel e escopo vêm do usuário autenticado no servidor. Menu, 404 de página e permissões recebidas servem à navegação. Autorização de objeto deve existir além da permissão de página. Ações operacionais (forçar recarga de dados, reprocessar, reenviar, limpar cache) também são funções: esconder o botão para não administradores não impede o POST direto (SEN #03, demonstrado com conta sem perfil administrativo). Restringir a função no servidor ou, se o produto quiser liberá-la a todos, aplicar cooldown e limite (FE-06). Não deixar usuário atribuir seu próprio papel/sindicato. Formulários administrativos podem enviar concessões somente nos casos autorizados no contrato; não proibir indiscriminadamente toda edição legítima de permissões.

**Verificar:** usuário A não lê/altera/descobre objeto de B; papel sem permissão não acessa endpoint direto, incluindo endpoints de ação operacional (403 ou limite efetivo); conta desativada perde acesso; controles por ambiente do MAT respeitados. No SIN, novo endpoint com escopo exige teste de isolamento e é bloqueante de merge. Escolher 401/403/404 segundo o contrato e a sensibilidade da existência do objeto.

## FE-06 — CORS, proxies e limites

**Origem:** MAT S9/feedback; SIN S9/SEC9; RAPI configuração/proxies; SEN #03. **Responsável:** API/borda, com tratamento de erro no Front-end.

Origens HTTPS exatas para recursos protegidos. Não confiar em headers forjáveis para identificar cliente. Comprovar topologia, sobrescrita na borda e origem da conexão antes de configurar cabeçalho/saltos confiáveis. Limites entre réplicas usam armazenamento compartilhado; não copiar contador local para produção. Manter regras autenticadas/anônimas e orçamento do projeto.

Operações caras disparadas pelo usuário (consulta a sistemas de origem, DW, geração de relatório) precisam de limite por usuário autenticado e de cooldown global. Todo pedido que não dispara trabalho novo responde 429 com Retry-After — inclusive enquanto uma execução anterior ainda está em andamento. Responder 200/201 “ignorando” o pedido esconde o controle do cliente e do teste: no SEN #03 a primeira correção falhou no reteste porque o segundo pedido, chegando durante a carga do primeiro, recebia 200. Exemplo de parâmetros do SEN (não universais): 3 pedidos/min por usuário, 2 min entre tentativas, 10 min desde a última carga.

**Verificar:** origem não permitida sem ACAO; IP real permanece igual diante de header forjado; limite não se torna global pelo IP do BFF; excesso retorna 429/Retry-After no contrato do Radar; para operação cara, sequência de pedidos seguidos com usuário comum retorna 200 seguido de 429 com Retry-After, inclusive durante execução em andamento. Na UI, evitar retries em laço e apresentar recuperação. Não realizar bursts em produção como health check.

## FE-07 — Mensagens entre janelas (complementar)

**Origem:** OW-HTML5; sem requisito interno específico. **Responsável:** Front-end.

Em postMessage, restringir origem de destino para conteúdo sensível, verificar origem exata/remetente esperado e validar formato. Tratar payload como dado, sem eval/HTML. Restringir permissões de frames ao necessário.

**Verificar:** origem/remetente/formato inesperados ignorados e integração legítima preservada. Aplicar apenas se houver essa superfície.

## FE-08 — CSP e headers entregues

**Origem:** MAT S3/S17/SEC2/SEC9; IRI Cabeçalhos; RFE Publicação; SIN S3; SEN #04. **Responsável:** Front-end/BFF/borda.

Verificar política entregue ao navegador, não só arquivo local. Uma CSP só com `base-uri`, `object-src` e `frame-ancestors` não mitiga XSS: sem `default-src` e `script-src` qualquer origem de script é aceita (SEN #04). Linha de base para SPA sem script inline: `default-src 'self'; script-src 'self'; object-src 'none'; base-uri 'self'; frame-ancestors 'none'`, com `connect-src` e `form-action` limitados à própria origem e ao provedor de SSO, e `img-src`/`font-src`/`worker-src` com `data:`/`blob:` só quando a funcionalidade exigir (ex.: exportação de imagem). `style-src 'unsafe-inline'` exigido por estilos calculados ou html2canvas é residual a registrar, não a omitir. Radar exige nonce por resposta e script-src sem unsafe-inline. MAT/IRI têm residuais explicitados no perfil; não exportá-los a outros projetos nem declarar nonce atendido. Separar style-src de script-src e regras de desenvolvimento das de produção. Manter object-src none/frame-ancestors none e demais headers exigidos pelo perfil, incluindo nosniff, referrer/permissions policy e HSTS onde aplicáveis. Report-Only não bloqueia.

**Verificar:** resposta HTTP efetiva; script externo não autorizado bloqueado; aplicação legítima funciona; CSP não reduzida pela borda a upgrade-insecure-requests. Corrigir sobrescrita na camada responsável. Não usar robots.txt como controle de acesso.

## FE-09 — Terceiros e telemetria

**Origem:** MAT §0/S15/feedback; IRI Dados; RFE Configuração; complemento OW-THIRD. **Responsável:** Front-end/BFF e dono da coleta.

Telemetria requer aprovação formal conforme as fontes e ID vindo de env, sem default hardcoded. Esta exigência vem dos documentos internos, não de uma suposição da skill. Mantê-la desligada sem evidência de aprovação. Texto livre pode conter dados pessoais. No feedback MAT, chave e destino final ficam no BFF, egress é restrito e contexto é opt-in/visível. Não inferir identidade nem anexar impressão digital do navegador.

**Verificar:** nenhuma chamada de telemetria sem configuração/aprovação; payload mínimo; chave privada ausente do bundle; erro de fornecedor não repassado à tela. Avaliar scripts externos e SRI quando compatível, como complemento técnico.

## FE-10 — Dependências e verificações de código

**Origem:** MAT §2/§4/§6; SIN S16/S20/SEC8; IRI Dependências; RFE Publicação. **Responsável:** desenvolvimento/CI.

Usar lockfile e npm ci --ignore-scripts nos fluxos prescritos. MAT/RFE exigem audit com nível high, testes, typecheck, lint e build; MAT também secret scan. Preservar bloqueios do projeto. SIN usa ferramentas Python na API, não substituí-las por npm. Alertas e contagens antigas nas specs não são resultado atual. Não executar audit fix --force que rebaixa framework; avaliar atualização e regressão.

**Verificar:** executar ferramentas disponíveis, registrar versão/data/saída e limites. Testes no runtime/dependências do artefato publicado; manter Docker/package/CI compatíveis. Se o projeto não tiver script exigido, documentar/implementar o check adequado dentro do escopo, nunca passar com --if-present.

## FE-11 — Uploads

**Origem:** MAT S3/S6; SIN S6; complemento OW-UPLOAD. **Responsável:** API e Front-end.

Quando houver upload, servidor valida conteúdo/magic bytes, limites e nomes gerados. Extensão/accept no navegador são conveniência. MAT não permite SVG servido a partir de upload e determina attachment. Não afirmar que SIN tem upload: sua spec registra ausência nesta fase.

**Verificar:** arquivo incompatível/acima do limite recusado também em chamada direta autorizada; preview não executa conteúdo ativo. Preservar fluxo legítimo e controle de acesso.

## FE-12 — Segredos e configuração

**Origem:** MAT S1/S8/§2/§5/SEC4/SEC10/SEC11; SIN S8/S18/SEC5/SEC11; RFE incidente; RAPI segredos/rotação. **Responsável:** aplicação/CI/infraestrutura.

Nenhuma credencial fixa/default, token ou segredo em diff, fixture, bundle ou variável NEXT_PUBLIC. Endereço privado de API fica no servidor. Aplicação falha ao iniciar se faltar configuração obrigatória, sem fallback inseguro. Env de exemplo contém apenas valores fictícios. Novos projetos recebem segredos em runtime/cofre, não build-args/imagem; residuais existentes de MAT/SIN ficam registrados sem reutilização.

**Verificar:** artefatos e fronteira cliente/servidor com marcador sintético; boot sem chave recusado; ambiente isolado. Não imprimir valores reais encontrados. Exposição exige revogação/rotação e tratamento de cópias, não só remoção de literal. Planejar essas ações com o responsável; não executar revogação, reescrita de histórico ou exclusão de imagens como efeito automático da revisão.

## FE-13 — Schemas, campos livres, erros e logs

**Origem:** MAT §2/§6/S11; SIN Entrada/Saída/Logs/S23/S25; IRI fase API; SEN #06. **Responsável:** Front-end/BFF/API.

Validar respostas por schema antes de estado; tratar resultado inválido. Revalidar entrada no servidor, com limites reais de corpo/texto. Não confiar nos limites visuais (IRI cita 2.000 caracteres; MAT, 16 KB de corpo do feedback). Usar mensagens úteis de 4xx e genéricas para falha interna, com correlação sem dados sensíveis. Não registrar senha, token, corpo de login, conversa ou texto digitado num login falho.

Recusas de autenticação usam uma única mensagem genérica (ex.: “sessão inválida ou expirada”) para ausência de token, token inválido, ID token ausente e algoritmo recusado; o motivo detalhado fica só no log (SEN #06). Mensagens que distinguem esses casos ensinam ao atacante como a validação funciona. Ver também FE-16.

**Verificar:** payload malformado/excessivo recusado no servidor; resposta inválida não quebra a tela; erro SMTP/SQL/infra não vaza; logs com dados sintéticos não contêm o conteúdo protegido; variações de credencial inválida (sem token, Bearer inválido, `alg: none`, header de ID token isolado) recebem o mesmo status e a mesma mensagem. Limites numéricos são do contrato específico.

## FE-14 — Publicação e separação de ambientes

**Origem:** MAT §3/§4/§6/SEC5; SIN §3/§4; RFE configuração/publicação; RAPI borda. **Responsável:** desenvolvimento e entrega.

Publicar artefato aprovado pelos checks, com runtime coerente e usuário não-root. HTTPS/HSTS e audiência seguem o projeto. No Radar público, rotas administrativas devem responder 404; no MAT há telas públicas autenticadas e regras por papel, não copiar a divisão de audiência do Radar. Mocks/dados gerados só nos ambientes e condições previstos. Verificar a exposição direta de backend conforme o contrato; manter conflito MAT visível.

**Verificar:** build/checks do artefato, ambiente/tag/destino, ausência de mock/login de desenvolvimento em produção, headers efetivos, rotas diretas e imagens sociais HTTPS. Criar script de deploy não equivale a publicar ou atualizar servidor. Dependências de DevOps devem ser entregues como pendências ou solicitação preparada, não mensagem enviada sem instrução.

## FE-15 — Exportações e dados de alunos

**Origem:** MAT Auditoria/Alunos/Operacional/SEC3; SIN escopo/minimização. **Responsável:** API e Front-end.

Exportação segue os mesmos papéis, filtros e restrições de campo da tela. Em MAT, CSV vem do servidor por POST, usa no-store, proteção contra fórmula e auditoria de quem exportou; o front dispara download sem converter a base inteira em estado persistente. Não ampliar dados pessoais por conveniência de exportação. SEC3/base legal/retenção permanece questão documentada, não resolvida por este controle.

**Verificar:** usuário sem papel não exporta; CSV respeita filtros/campos e não executa fórmula a partir de entrada adversa; nenhuma persistência adicional no navegador. Não usar dados reais de menores em testes.

## FE-16 — Divulgação de informação técnica

**Origem:** SEN #01/#06/#08/#09; complemento OW-ERROR e WSTG-INFO. **Responsável:** API/BFF/borda; Front-end não exibe nem repassa.

Payloads entregues ao navegador não carregam metadados de infraestrutura: IP ou hostname interno, instância, nome de banco, schema, tabela, caminho de arquivo, nem códigos de relatórios ou sistemas internos (SEN #01: a primeira correção removeu IP/banco/tabela, mas o reteste manteve o achado parcial porque o texto ainda citava o código do relatório BI de origem). Campos de “fonte” ou “origem” mostram apenas um nome lógico pensado para o usuário. Health checks públicos ou autenticados respondem só o estado (`{"ok":true}`), sem modo de autenticação, versão ou dependências (SEN #08). Remover banners e assinaturas de framework: `X-Powered-By`, `ETag` padrão do Express quando não usado para cache, versão e nome do servidor no `Server` (SEN #09). A identificação das bibliotecas pelo bundle é inerente e pode ser registrada como residual informativo.

**Verificar:** inspecionar com sessão comum todas as respostas JSON da tela, procurando padrões de IP privado, `\\`, nomes de banco/tabela e códigos internos; corpo do health; headers `Server`, `X-Powered-By` e `ETag` no HTML e na API, na resposta efetiva da borda. Ausência em homologação não comprova produção.

## Limites da consolidação

Cobertura selecionada para Front-end e suas fronteiras. Para OAuth/OIDC, WebSockets, service workers ou novas superfícies, consultar contrato e fonte oficial pertinente, documentando origem e aplicabilidade. Não certificar banco, infraestrutura, LGPD ou segurança geral apenas por esta checklist.
