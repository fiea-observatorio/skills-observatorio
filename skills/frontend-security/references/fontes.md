# Fontes e rastreabilidade

Versão 1.1.0 — análise em 16/11/2026. A 1.1.0 incorpora o ciclo de avaliação de segurança SEN (Painel de Matrículas SENAI) e cria FE-16.

## Referência principal

Os cinco arquivos internos abaixo foram fornecidos pelo solicitante e lidos integralmente. São a base técnica desta skill. Os relatórios de pentest de 29/07/2026 e 10/08/2026 mencionados nas specs não foram fornecidos: a origem dos achados é atribuída às specs, sem alegar leitura dos laudos originais ou aprovação institucional independente.

A data de modificação do arquivo identifica a cópia consultada, não uma aprovação. SHA-256 permite verificar se a referência mudou. O conteúdo consolidado é utilizável sem os caminhos originais, mas uma nova auditoria deve consultar a fonte atual quando acessível. Distribuição destinada ao ambiente interno; não publicar esses materiais em serviços públicos.

### MAT — Matrículas SESI

[Documento original](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/dataproduct-aw-matriculas-sesi/specs/05-seguranca.md>). 367 linhas; modificação em 13/11/2026.

- SHA-256: `AB536A0531C17A0B17901ED973418BDEAAFE1C58D7E470AB01C67C5D538542EC`.
- Seções analisadas: §0 dados e papéis; §1 S1–S17; §2 codificação; §3 configuração; §4 publicação; §5 incidentes; §6 checklist (linha 309); §7 SEC1–SEC11.

### SIN — Sindicato API

[Documento original](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/sindicato_api/specs/05-seguranca.md>). 349 linhas; modificação em 06/10/2026.

- SHA-256: `6FCB497E424A591CB47FD4C4D605CBA69C7097A8FA16E3319F87B59494FB80BB`.
- Seções analisadas: §0 escopo/perfis; §1 S1–S25; §2 codificação; §3 configuração; §4 publicação; §5 incidentes; §6 checklist (linha 281); §7 SEC1–SEC20.

### IRI — Íris

[Documento original](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/dataproduct-aw-iris/specs/04-seguranca.md>). 84 linhas; modificação em 16/11/2026.

- SHA-256: `FB9ADB9BDC9500C5816113A594E38B7E64217D89B5ACB664A7E728C9E1EF37B6`.
- Seções analisadas: Renderização (linha 13); Dados no navegador (23); Cabeçalhos (36); Quando a API entrar (53); Dependências e build (67); Checklist (78).

### RFE — Radar Front-end

[Documento original](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/dataproduct-aw-radar-tendencias/specs/SECURITY_OPERATIONS.md>). 22 linhas; modificação em 28/08/2026.

- SHA-256: `BFE6BE884DC7603998F0E4226B29D917BABCAF7EE2F5A6F87BA2A6B68B5E4802`.
- Seções analisadas: Configuração obrigatória (linha 3); Publicação (11); Resposta a incidente (20).

### RAPI — Radar API

[Documento original](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/dataproduct-aw-radar-tendencias-api/specs/SECURITY_OPERATIONS.md>). 62 linhas; modificação em 28/08/2026.

- SHA-256: `C352DF3911B421E27CDA0538215DE99EA39E98AAA48CF2EB28C3BB800BF70C50`.
- Seções analisadas: Segredos e configuração (linha 3); CLIENT_IP_HEADER (14); TRUSTED_PROXY_HOPS (28); Borda HTTP/DNS (42); Banco/implantação (48); Rotação (56); Reversão (60).

### SEN — Painel de Matrículas SENAI (avaliação de segurança)

Cinco PDFs fornecidos pelo solicitante e lidos integralmente, classificados como confidenciais pela equipe de testes. Diferente das specs acima, são resultados de teste grey box em produção (OWASP WSTG/API Top 10, CVSS 3.1) e as respostas do desenvolvimento. Guardar os originais apenas no local autorizado; esta skill registra só controles e status, sem IPs, hosts, bancos, tabelas, URL de produção ou nomes de pessoas.

| Documento | Data | SHA-256 |
| --- | --- | --- |
| Relatório técnico (9 achados) | 04/11/2026 | `AC93D5B10FA13CC3F97CCA049285513872C1054024F91CF895A893782D143AEC` |
| Resposta do desenvolvimento | 06/11/2026 | `ECEBDAB99A82241A14BB3EB0925227D87B73102F5CE944444CBF0C861ACAC65F` |
| Relatório técnico — reteste v1 | 06/11/2026 | `1AEAE0E0F379B6E9F70F541EE1AF629ED33A8E29780C2ADFBDC57BDDE60AD9D5` |
| Sumário executivo — reteste v1 | 06/11/2026 | `8039DCD853EF32B60F99656EAD1D312C5AAF3A8084A9CE156F0287A68E4C5ED6` |
| Resposta ao reteste | 10/11/2026 | `9956397FAB7D92748CCFEED0635A61E7A852BD5AA7B1115E1EC8EA63388D73D3` |

- Seções analisadas: sumário de achados, detalhamento #01–#09 (alvo, evidência, remediação, como validar), conclusão e prioridades; nas respostas, tratamento por achado e situação de publicação.
- Status consolidado e residuais em [perfis](perfis-e-conflitos.md#matrículas-senai-painel-de-acompanhamento). A resposta de 10/11 não foi retestada nas fontes recebidas.

## Matriz de extração

“Requisito” significa regra da spec no seu projeto. “Síntese” reúne regras para reutilização; em projetos diferentes, sua adoção deve respeitar as instruções locais. “Complementar” indica recomendação pública sem correspondência interna comprovada. As verificações foram propostas nesta consolidação; não foram executadas nas aplicações de origem.

| Controle | Origem interna/seção | Caráter e escopo | Evidência esperada |
| --- | --- | --- | --- |
| FE-01 Renderização e URLs | MAT S3/S5, §2; SIN S5, Entrada/Saída; IRI Renderização; RFE Configuração; RAPI URLs | Requisitos com diferenças por uso de URL | Conteúdo inerte; rejeição de protocolo/destino indevido; links legítimos preservados |
| FE-02 Dados no navegador | MAT §0/§2 e Auditoria; SIN §0/S22/S24; IRI Dados no navegador; SEN #02/#05/#07 | Requisito; exceção de rascunho I27 exclusiva da Íris; SEN como achado demonstrado | Ausência de dados sensíveis em URL/storage/log/cache; campos e linhas mínimos; pseudônimo não reversível; no-store efetivo |
| FE-03 Sessão e BFF | MAT S12/S13/SEC1/SEC8; SIN S12/S13, Refresh rotativo, SEC1/SEC4; RFE Configuração/Publicação; IRI Quando a API entrar | Requisitos; parâmetros por perfil | Sessão inválida recusada; refresh concorrente controlado; rede via BFF |
| FE-04 CSRF | Sem regra interna específica suficiente | Complementar OW-CSRF | Requisição forjada recusada no fluxo com credenciais automáticas |
| FE-05 Autorização | MAT S4/S7/S12–S14 e Papéis; SIN §0, S4/S7, Autorização, SEC2/SEC3; SEN #03/#05 | Requisitos; concessões administrativas explícitas não são autoatribuição | Isolamento horizontal/vertical; ator e escopo verificados no servidor; ação operacional negada ou limitada para usuário comum |
| FE-06 CORS e rate limit | MAT S9/feedback; SIN S9/SEC9; RAPI configuração/proxies; SEN #03 | Requisitos com dependência de infraestrutura | Origem inválida sem permissão; IP forjado sem efeito; limite compartilhado e 429; 429 também durante execução em andamento |
| FE-07 Mensagens entre janelas | Sem regra interna específica suficiente | Complementar OW-HTML5 | Origem/remetente/formato inesperados recusados |
| FE-08 Headers e CSP | MAT S3/S17/SEC2/SEC9; IRI Cabeçalhos; RFE Publicação; SIN S3; SEN #04 | Requisitos e residuais conflitantes por perfil | Header efetivamente entregue com default-src/script-src; nonce/política conforme perfil; limites explicitados |
| FE-09 Terceiros e telemetria | MAT §0/S15/feedback; IRI Dados; RFE Configuração | Requisitos; aprovação de coleta expressa na fonte | Sem GA sem aprovação; ID via env; conteúdo externo e payload mínimo |
| FE-10 Dependências | MAT §2/§4/§6; SIN S16/S20/SEC8; IRI Dependências; RFE Publicação | Requisitos; registro histórico não é resultado atual | Auditoria atual e regressão; bloqueios aplicáveis preservados |
| FE-11 Upload | MAT S3/S6; SIN S6 | Requisito condicional: somente se houver upload | Validação real no servidor e conteúdo ativo impedido |
| FE-12 Segredos | MAT S1/S8/§2/§5/SEC4/SEC10/SEC11; SIN S8/S18/SEC5/SEC11; RFE Incidente; RAPI Segredos/Rotação | Requisitos e residuais de imagem; não generalizar exceções | Sem segredo exposto; boot falha sem configuração; incidente separado de correção local |
| FE-13 Entradas, schemas e erros | MAT §2/§6/S11; SIN S11/S23/S25 e Entrada/Saída/Logs; IRI Quando a API entrar; SEN #06 | Requisitos e parâmetros específicos | Payload inválido recusado; saída validada; erro genérico com rastreio seguro; recusa de sessão com mensagem única |
| FE-14 Publicação | MAT §3/§4/§6/SEC5; SIN §3/§4; RFE Configuração/Publicação; RAPI Borda | Requisitos por projeto e dependências externas | Testes/build do artefato; audiência e headers verificados após deploy |
| FE-15 Exportações | MAT Auditoria/Alunos/Operacional/SEC3; SIN §0/Autorização | Requisitos de minimização/escopo; exportação específica de MAT | CSV autorizado sem fórmula executável; sem persistência do arquivo no estado da tela |
| FE-16 Divulgação de informação técnica | SEN #01/#06/#08/#09 | Achados demonstrados em produção; complemento OW-ERROR/WSTG-INFO | Payload sem metadados de infraestrutura; health mínimo; sem banner de servidor/framework |

## Fontes públicas complementares

Consultadas em 16/11/2026. São páginas vivas, sem edição normativa fixada nesta skill. Não inventar IDs ASVS, certificação ISO ou exigências legais.

- OW-XSS: [OWASP — Cross Site Scripting Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html), Framework Security, Output Encoding, HTML Sanitization e Safe Sinks.
- OW-HTML5: [OWASP — HTML5 Security](https://cheatsheetseries.owasp.org/cheatsheets/HTML5_Security_Cheat_Sheet.html), Web Messaging, CORS e Storage APIs.
- OW-SESSION: [OWASP — Session Management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html), Cookies, Session Expiration e TLS.
- OW-CSRF: [OWASP — Cross-Site Request Forgery Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html), Built-In Implementations e Defense In Depth.
- OW-AUTHZ: [OWASP — Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html), Deny by Default e Validate Permissions on Every Request.
- OW-CSP: [OWASP — Content Security Policy](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html), Policy Delivery, Defense In Depth e Strict CSP.
- OW-THIRD: [OWASP — Third Party Javascript Management](https://cheatsheetseries.owasp.org/cheatsheets/Third_Party_Javascript_Management_Cheat_Sheet.html), Major risks e Defense Considerations.
- OW-DEPS: [OWASP — Vulnerable Dependency Management](https://cheatsheetseries.owasp.org/cheatsheets/Vulnerable_Dependency_Management_Cheat_Sheet.html), Context e Remediation.
- OW-UPLOAD: [OWASP — File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html), File Upload Protection.
- OW-SECRETS: [OWASP — Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html), Secret Lifecycle e Incident Response.
- OW-ERROR: [OWASP — Error Handling](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html), Context e Objective.
- WSTG-INFO: [OWASP WSTG — Information Gathering](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/README), referência usada pelo achado SEN #09.

## Critérios de conclusão e manutenção

- Referências obtidas e analisadas: cinco specs e o ciclo de avaliação SEN (cinco PDFs) indicados pelo solicitante, identificados acima.
- Diretrizes Front-end documentadas: catálogo de 16 controles, matriz de origem e perfis com exceções/conflitos.
- Skill: pacote reutilizável com instruções de desenvolvimento, revisão e validação. A disponibilidade da instalação é registrada no guia de entrega.

Não foi feita auditoria do código ou do ambiente publicado dos cinco produtos. Marcas de “atende”, vulnerabilidades e pendências nas specs são relatos datados, não verificações atuais desta entrega.

Ao receber revisão de uma fonte: leia as seções afetadas, registre hash/data, extraia regra/escopo/evidência, compare decisões e conflitos, atualize catálogo/perfis/versão e sincronize cópias instaladas. Não assuma que a data mais recente de um arquivo revoga todas as regras dos demais. Alterações que dependem de decisão ainda ausente devem ficar como pendência localizada; o restante do trabalho pode prosseguir.
