# Radar CNPJ

> Vale abrir isto aqui? Consulta de CNPJ, avaliação de ideia por região e monitoramento, dos dados abertos da Receita Federal.

**In English.** Radar CNPJ serves the open CNPJ data of Brazil's Receita Federal, reloaded on every dump: the full record of any company, search by name, activity (CNAE) and place, an idea evaluation that turns a sentence into a CNAE, a region and counts, and CNPJ monitoring. Free lookups, no key; responses in Portuguese; remote MCP server.

**No ar:** https://radar-cnpj.com · **Índice da API:** https://radar-cnpj.com/api/ · **OpenAPI:** https://radar-cnpj.com/openapi.json · **Servidor MCP:** https://radar-cnpj.com/mcp · **Docs para agentes:** https://radar-cnpj.com/llms.txt

## O que faz

O Radar CNPJ é a base de CNPJ da Receita Federal organizada para decidir, não só consultar.

O que faz: ficha de qualquer CNPJ (situação, atividades, sócios como a fonte publica, endereço), busca por nome, atividade e lugar, e a avaliação de uma ideia — "vale abrir uma padaria em Águas Claras?" vira um CNAE, uma região e uma contagem de quem já está lá e de quem fechou. O monitoramento avisa quando um CNPJ que você acompanha muda de situação, endereço ou quadro.

## Começo rápido (sem cadastro)

Ficha completa pelo CNPJ (cache de 6 h):

```bash
curl -s https://radar-cnpj.com/api/cnpj/33000167000101
```

Busca por termo e UF:

```bash
curl -s 'https://radar-cnpj.com/api/busca?q=padaria&uf=DF'
```

Vocabulário oficial (CNAE, município ou natureza):

```bash
curl -s 'https://radar-cnpj.com/api/ref?tipo=cnae&q=padaria'
```

Avaliação de ideia:

```bash
curl -s -X POST https://radar-cnpj.com/api/avaliar -H 'content-type: application/json' -d '{"texto":"padaria em Águas Claras"}'
```

## Servidor MCP (remoto, sem instalar nada)

Streamable HTTP sobre a mesma API pública. Cada tool é uma chamada nesta API; o `operationId` do OpenAPI é o nome da tool. Cartão do servidor: `GET https://radar-cnpj.com/mcp`.

Claude Code:

```bash
claude mcp add --transport http radar-cnpj https://radar-cnpj.com/mcp
```

Cursor (`.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "radar-cnpj": {
      "url": "https://radar-cnpj.com/mcp"
    }
  }
}
```

Tools principais: `get_cnpj`, `search`, `avaliar`, `suggest`, `ref`, `ia_filters`, `add_watch`, `list_watches`.

## Preço

**Grátis.** Consulta de CNPJ, busca, exportação e avaliação de ideia, sem cadastro e sem chave; dez CNPJs monitorados por sessão.

**Pago.** Slot de vigia extra: US$ 0,50 por 30 dias; contato de agente US$ 0,10. Por requisição (x402) ou crédito pré-pago.

## O que não é

Não é fonte oficial (é a base pública, recarregada a cada dump) e não serve para spam nem para decisão automatizada sobre pessoas.

## Arquivos deste repositório

| | |
|---|---|
| `README.md` | esta página |
| `openapi.json` | documento OpenAPI 3; `operationId` = nome da tool MCP |
| `llms.txt` | guia curto para agentes (rotas, auth, preço, MCP) |
| `llms-full.txt` | referência completa: parâmetros, corpo, resposta campo a campo, erros (quando publicada) |
| `apis.json` | índice APIs.json (APIs.io) |
| `mcp/server.json` | manifesto publicado no registro oficial de MCP (`com.radar-cnpj/radar-cnpj`) |
| `okf/` | bundle OKF: markdown com front-matter (índice, sobre, API, FAQ) |
| `examples/` | `curl.sh` e `python.py` com as chamadas grátis acima |

## Sobre este repositório

Este repositório espelha as superfícies públicas e legíveis por máquina do Radar CNPJ, como servidas em https://radar-cnpj.com: o documento OpenAPI, o guia `llms.txt`, o manifesto do registro MCP, o bundle OKF e o índice APIs.json. O produto em si não é código aberto; o espelho existe para a API e o servidor MCP poderem ser encontrados, lidos e linkados daqui. Os arquivos são regenerados das superfícies no ar (última sincronização: 2026-09-05); se algo aqui divergir do site, vale o site.

Issues e sugestões são bem-vindas aqui. Contato: contato@radar-cnpj.com. Autor: Wendel ([@wrpbr](https://github.com/wrpbr)).
