---
type: "API"
title: "API do Radar CNPJ"
description: "Superfície HTTP e MCP do Radar CNPJ, com o modelo de cobrança."
resource: "https://radar-cnpj.com/api/"
---

# API do Radar CNPJ

Base: https://radar-cnpj.com

## Como pagar

Consulta e avaliação de ideia são grátis. Contato de agente cobra por requisição (x402) ou desconta de crédito pré-pago (`POST /api/credito?usd=10`).

## Endpoints

* `GET /okf/:arquivo` — Bundle OKF (Open Knowledge Format v0.1): markdown com frontmatter para o agente ler o produto inteiro sem parsear HTML.
* `GET /.well-known/:arquivo` — Descoberta de máquina antes da home: `api-catalog` (RFC 9727, linkset com a API e o MCP), `security.txt` (RFC 9116) e `mcp-registry-auth` (chave do registro oficial de MCP).
* `GET /apis.json` — APIs.json (apisjson.org, 0.19): o índice que o APIs.io colhe — a API, o MCP, OpenAPI, guia e bundle OKF num arquivo só. Também em `/.well-known/apis.json`.
* `GET /api/` — Índice auto-descrito de toda a superfície deste Worker, com a origem declarada.
* `GET /api/health` — Saúde da origem e a idade do dado: de quando é o dump da Receita e o que ele tem.
* `POST /mcp` — Servidor MCP por HTTP (Streamable HTTP, JSON-RPC 2.0) — pluga no cliente sem instalar nada.
* `POST /api/avaliar` — Cola uma ideia de negócio em texto e recebe a ficha da oferta formal na Receita.
* `GET /api/cnpj/:cnpj` — A ficha cadastral completa de uma empresa, pelos 14 dígitos do CNPJ.
* `GET /api/busca` — Busca empresas por termo e/ou filtros avançados, paginada.
* `GET /api/export` — Exporta o resultado da busca em CSV ou JSON, com os mesmos filtros dela.
* `GET /api/sugerir` — Autocomplete de empresas e termos, para montar a lista enquanto a pessoa digita.
* `GET /api/ref` — Vocabulários oficiais para montar seletor: CNAE, município e natureza jurídica.
* `POST /api/ia` — Transforma um texto livre nos filtros normalizados que a busca aceita.
* `POST /api/ia/jobs` — Enfileira a mesma tradução de texto para filtros, quando a síncrona não cabe no tempo.
* `GET /api/ia/jobs/:id` — Consulta o trabalho de IA enfileirado; quando pronto, devolve os filtros.
* `GET /api/local` — Cidade e UF de quem está chamando, pela borda da Cloudflare.
* `GET /api/municipio-proximo` — O município do IBGE mais próximo de um par de coordenadas, com o bairro do CNEFE.
* `POST /api/monitor/session` — Cria uma sessão anônima de monitoramento e devolve o uuid dela.
* `PUT /api/monitor/session/email` — Cadastra o e-mail que vai receber os alertas desta sessão.
* `GET /api/me/monitor/watches` — Os CNPJs que esta sessão acompanha, com a cota aplicada pela origem.
* `POST /api/me/monitor/watch` — Passa a acompanhar um CNPJ. Os primeiros 10 da sessão são grátis; a partir daí, x402 por 30 dias.
* `DELETE /api/me/monitor/watch/:cnpj` — Para de acompanhar um CNPJ. A chave é o próprio CNPJ, não um id.
* `GET /api/me/monitor/alerts` — Os alertas gerados para os CNPJs que esta sessão acompanha.
* `GET /api/monitor/changes/:cnpj` — O histórico de alterações cadastrais de um CNPJ.
* `POST /api/contato` — Fala com o suporte: humano resolve Turnstile, agente paga $0.10 em x402.
* `POST /api/contact` — O mesmo contato de `/api/contato`, com os nomes de campo em inglês.
* `GET /api/metrics` — Métricas operacionais: sem token, visitas de hoje e uso; com o token do operador, a série de 7 dias.
* `POST /api/credito` — Recarrega crédito pré-pago: paga uma vez com x402 e recebe o token que desconta em qualquer API da casa.
* `GET /api/credito` — Saldo e extrato do crédito — as últimas movimentações, sem devolver o token.

Catálogo completo: https://radar-cnpj.com/llms-full.txt · OpenAPI: https://radar-cnpj.com/openapi.json
