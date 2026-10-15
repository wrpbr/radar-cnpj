---
name: radar-cnpj
description: Check Brazilian companies with Radar CNPJ (radar-cnpj.com). Look up a CNPJ for the Receita Federal record, partners, sanctions (CEIS, CNEP, CEPIM, TCU, CNIA), federal tax debt, government contracts and 40+ public databases. Search companies by name, partner, phone, address or activity (CNAE) and place. Check a supplier list in bulk, count active, opened and closed companies for a business idea, and monitor CNPJ changes. Use when a task mentions CNPJ, empresa, Receita Federal, CNAE, sócios, fornecedor, due diligence, KYC or a Brazilian company.
license: MIT-0
compatibility: Needs HTTPS access to radar-cnpj.com. Works with the remote MCP server or with plain HTTP calls.
---

# Radar CNPJ

Radar CNPJ serves the open company data of Brazil (CNPJ) from Receita Federal and 40+ public databases.
Use it to identify a company, check its risk, find companies and measure how many companies of an
activity exist in a place.

## Connect

HTML index pages are free for people and crawlers, without an API quota.
JSON, Markdown, OKF and MCP index data calls have 1,000 free reads per day, IP and product.
Above that allowance, the MCP answers `free_limit`. On the HTTP API, US$1 buys 1,000 shared reads for 30 days
without automatic renewal: see `/api-access-guide.md` for evaluation, purchase and retry instructions.

- MCP server (preferred): `https://radar-cnpj.com/mcp?checkout=site`. Transport: Streamable HTTP. Every MCP tool is
  free, within its free limits: no key and no payment.
- HTTP API: base URL `https://radar-cnpj.com`. Each MCP tool calls one route of this API.
- If the MCP tools are not available, call the HTTP routes with `curl` or with your fetch tool.
- Discovery: `GET https://radar-cnpj.com/api/` lists the routes, prices and limits.
  `https://radar-cnpj.com/llms-full.txt` has the full reference.

## MCP tools

| Tool | HTTP | Use it to | Cost |
|---|---|---|---|
| `consulta_cadastro` | `GET /api/consulta/cadastro/{cnpj}` | Read basic company data without contacts or live analysis. | Free, no allowance consumed |
| `consulta_endereco` | `GET /api/consulta/endereco/{cep}` | Read up to 20 addresses and 20 companies of a CEP. | Free, no allowance consumed |
| `get_cnpj` | `GET /api/cnpj/{cnpj}` | Read the company record: status, activities, address, partners (masked), sanctions, tax debt, contracts. Accepts the 14-digit CNPJ and the alphanumeric one (12 letters or digits + 2 check digits). | Free |
| `consulta_cnpj` | `GET /api/consulta/cnpj/{cnpj}` | Run the full check: live CNIA misconduct lookup, PEP partners, regulators, BNDES, federal payments, address on the map. | Free, daily limit |
| `search` | `GET /api/busca` | Find companies. Set `tipo` to `nome`, `fantasia`, `socio`, `telefone`, `email`, `endereco` or `cnae`. | Free |
| `suggest` | `GET /api/sugerir?q=` | Find up to eight companies by CNPJ, company or partner name, phone with area code, or full registered email. The API detects the input type. | Free |
| `ref` | `GET /api/ref` | Find official codes. Set `tipo` to `cnae`, `municipio` or `natureza`. | Free |
| `ia_filters` | `POST /api/ia` | Turn a plain-language request into search filters. It takes about 20 seconds. | Free |
| `avaliar` | `POST /api/avaliar` | Map a business idea and place to a CNAE. Count active, opened and closed companies. | Free |
| `health` | `GET /api/health` | Read the date of the Receita data (`import.dump_date`). | Free |

The unmasked partner contacts, the dossier, the bulk check of a CNPJ list (`POST /api/consulta/lote`) and the CNPJ
monitor are paid features of the site and the HTTP API (below). They are not MCP tools.

## Rules

1. Start with `get_cnpj` or `search`. Use `consulta_cnpj` for the full check.
2. If an MCP tool answers `free_limit`, tell the user that the free limit for that action is used up.
3. On the HTTP API, read the price from `GET /api/pricing` before a paid call. Do not use a price from memory.
   Do not spend balance or reveal personal data until the user approves the item and the amount.
4. Never pay by yourself. On the HTTP API, a paid route returns HTTP 402: show the price and
   https://radar-cnpj.com/pricing to the user. The person buys on the site. Then send the same call again with the
   person's prepaid credit token in the header `Authorization: Bearer cred_…`.
5. When you retry a paid call, keep the same `Idempotency-Key`. The service does not charge the same request
   twice.
6. Keep tokens (`cred_…`, `mmk_…`) secret. Do not write them in files, logs or answers.
7. Partner names, phones and e-mails are personal data under the Brazilian data protection law (LGPD).
   Use them only for the legitimate purpose that the user states.
   Do not use them for unsolicited marketing or for automated decisions about people.
8. Give the source date with each answer. A count shows registered companies (supply).
   It does not show demand, revenue or search volume.
9. Lists return up to 20 items per page. Follow `links.proximo`. Do not guess IDs. Do not scrape HTML pages.
10. If you get HTTP 429 or 503, wait for the time in `Retry-After` and try once more.

## Paid features (site and HTTP API)

- The person buys on the site: https://radar-cnpj.com/pricing shows the lookup plans, the packs and the prepaid
  credit, with the prices. Plans do not renew automatically.
- `GET /api/consulta` and `GET /api/pricing` read the plans and the prices. They do not charge.
- The HTTP API also supports lookup purchases without an account through x402 v1 or v2.
  The paying wallet owns the package. Its `mmw_…` credential comes from
  `/api/auth/wallet/agent/start` and `/api/auth/wallet/agent/token`.
  The MCP connection above never charges.
- Reveals use a paid Lookup package. HTTP 402 includes `ofertas[]` with purchase links.
  Send the API key or credit token of the package owner. The same owner can reopen the same company
  without another debit. A failed lookup returns the unit.
- A prepaid credit gives a `cred_…` token one time only. The same token works in Radar CNPJ, PontoFato and
  EditalMD.

## Examples

```bash
# Company record (free)
curl -s https://radar-cnpj.com/api/cnpj/33000167000101

# Companies by name and state (free)
curl -s 'https://radar-cnpj.com/api/busca?q=padaria&uf=DF'

# Business idea in a place (free)
curl -s -X POST https://radar-cnpj.com/api/avaliar \
  -H 'content-type: application/json' -d '{"texto":"padaria em Águas Claras"}'
```

## Limits

- Read [company and supplier news](https://radar-cnpj.com/en/noticias/index.md).
  Use the [free feed](https://radar-cnpj.com/en/noticias/feed.json). Cite the article date and original sources.

- Radar CNPJ is not an official certificate. The data is the public Receita Federal dump and the listed
  public databases, each with its date.
- The free CNPJ record has an edge cache of 6 hours.
- Terms: https://radar-cnpj.com/termos. Privacy: https://radar-cnpj.com/privacidade.
  Contact: contato@radar-cnpj.com.
