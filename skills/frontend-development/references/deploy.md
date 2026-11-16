# Deploy padronizado por sistema

## Referência analisada
[deploy.ps1 de Matrículas SESI](<C:/Users/john.amorim/OneDrive - Sistema FIEA/Documentos/Projetos/Observatório/dataproduct-aw-matriculas-sesi/deploy.ps1>), lido em 16/11/2026.
SHA-256: F61B60D316AB08E373BFD00203B1009B59586E2E730879C0AC582186BF888DA9.

O original mapeia stable/produção e latest/homologação, ativa blocos da .env, envia argumentos de build específicos do iDigital e executa build/push. O modo SomenteEnv modifica a .env e imprime valores. O repositório Harbor é fixo. Não foram lidos arquivos .env nem usadas credenciais reais.

## Adaptação incluída
O [gerador](../scripts/New-FrontendDeploy.ps1) cria deploy.ps1 a partir do [template](../assets/deploy.ps1.template), preservando as tags e parametrizando repositório/Dockerfile. É para projetos Next.js com npm; não é instalador universal de API Python.

Diferenças intencionais: não altera .env, não imprime valores, não envia segredos por build-arg, não copia parâmetros iDigital/Rubeus do projeto original, não publica sem -Publish e não desativa SBOM/provenance por padrão. Esses parâmetros dependem do sistema. O script exige PowerShell 7, lockfile e scripts test/typecheck/lint/build.

## Preparação obrigatória por projeto
1. Confirmar projeto/repositório Harbor e domínio real com o contexto disponível. Não assumir que o nome do diretório prova que esse destino existe. Docker login é realizado pelo operador/CI com o mecanismo de credenciais já adotado; não armazenar senha no script.
2. Preparar Dockerfile (ou nome informado por -Dockerfile), com estágios **validation** e **runtime**, mesma versão de Node e lockfile. O estágio validation deve instalar com npm ci --ignore-scripts, executar npm audit --audit-level=high, npm test, npm run typecheck, npm run lint e npm run build, interrompendo em qualquer erro. Adicionar secret scan conforme o projeto.
3. O estágio runtime deve copiar a saída validada de validation (por exemplo standalone/static/public), executar como não-root e não incluir fontes/segredos desnecessários. Revisar essa dependência no Dockerfile: o gerador verifica nomes de estágios, não interpreta o grafo nem certifica que os comandos estão corretos.
4. Configurar .dockerignore efetivo com linhas .env, .env.* e .git; a única reinclusão admitida pelo template é !.env.example, que deve conter só dados fictícios. Se existir Dockerfile.dockerignore, ele tem precedência. O guard é conservador, não é scanner completo de segredos.
5. Criar/configurar variáveis exclusivas de servidor via runtime/cofre/orquestrador, validando boot. Se o build exigir credenciais de produção, refatorar essa dependência. Prefixo NEXT_PUBLIC não torna um valor seguro: revisar o conteúdo. Configurações públicas incorporadas no build precisam ser geradas para o ambiente correto.

## Comando para criar em cada sistema
Na pasta da skill instalada, ou usando seu caminho absoluto:

```powershell
pwsh -File ./scripts/New-FrontendDeploy.ps1 -ProjectPath "C:/projetos/meu-sistema" -Repository "harbor.sistemafiea.com.br/meu-projeto/frontend"
```

Para arquivo chamado .dockerfile, acrescentar `-Dockerfile .dockerfile`. Os exemplos são fictícios. O gerador recusa sobrescrever deploy.ps1; adaptar o script existente por diff quando houver. -WhatIf permite visualizar a criação.

O usuário pediu a inclusão desse comando na skill para todos os sistemas. Isso torna o procedimento reutilizável por sistema; não autoriza varrer diretórios e alterar outros repositórios sem escopo.

## Uso do script gerado
Na raiz do sistema:

```powershell
# Previa sem alterar .env, construir ou publicar
pwsh -File ./deploy.ps1 -Tag latest -SomenteEnv
pwsh -File ./deploy.ps1 -Tag stable -DryRun

# Validar e construir localmente
pwsh -File ./deploy.ps1 -Tag latest

# Publicar quando isso fizer parte do pedido autorizado
pwsh -File ./deploy.ps1 -Tag latest -Publish
pwsh -File ./deploy.ps1 -Tag stable -Publish
```

Configuração pública opcional em JSON, passada por -PublicConfig; exemplo com valor fictício:
```json
{
  "latest": { "NEXT_PUBLIC_APP_LABEL": "Meu sistema - Homologacao" },
  "stable": { "NEXT_PUBLIC_APP_LABEL": "Meu sistema" }
}
```
O Dockerfile deve declarar/usar os ARG correspondentes. O script adiciona AMBIENTE a partir da tag; o Dockerfile/app precisam consumi-lo quando relevante. Não definir NODE_ENV=homologacao: os valores válidos do Next são development, production e test.

O preview valida pré-condições e mostra destino e nomes de argumentos. Construção e publicação falham em erro de processo externo. Não há teste real de Harbor nesta criação de skill. Publicar a imagem não atualiza o contêiner; documentar a etapa de DevOps e validar HTTPS, headers, audiência e fluxos após a atualização autorizada.

## Validar o gerador

Executar `pwsh -NoProfile -File scripts/Test-FrontendDeploy.ps1` a partir da pasta da skill. O teste cria uma fixture temporária e substitui Docker por uma função simulada; não constrói imagem nem acessa registry. Verifica geração, tags, preview sem alteração de env, push explícito, interrupção diante de falhas, recusa de sobrescrita e validações de configuração. Isso não certifica o Dockerfile real de um sistema, que exige os checks e a revisão descritos acima.
