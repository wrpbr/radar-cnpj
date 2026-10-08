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

- MCP server (preferred): `https://radar-cnpj.com/mcp`. Transport: Streamable HTTP. The free tools need no key.
- HTTP API: base URL `https://radar-cnpj.com`. Each MCP tool calls one route of this API.
- If the MCP tools are not available, call the HTTP routes with `curl` or with your fetch tool.
- Discovery: `GET https://radar-cnpj.com/api/` lists the routes, prices and limits.
  `https://radar-cnpj.com/llms-full.txt` has the full reference.

## MCP tools

| Tool | HTTP | Use it to | Cost |
|---|---|---|---|
| `get_cnpj` | `GET /api/cnpj/{cnpj}` | Read the company record: status, activities, address, partners (masked), sanctions, tax debt, contracts. | Free |
| `consulta_cnpj` | `GET /api/consulta/cnpj/{cnpj}` | Run the full check: live CNIA misconduct lookup, PEP partners, regulators, BNDES, federal payments, address on the map. | Daily free allowance, then balance |
| `consulta_lote` | `POST /api/consulta/lote` | Check a list of supplier or customer CNPJs, one row each, up to 100 per call. | One lookup per valid CNPJ |
| `search` | `GET /api/busca` | Find companies. Set `tipo` to `nome`, `fantasia`, `socio`, `telefone`, `endereco` or `cnae`. | Free |
| `ref` | `GET /api/ref` | Find official codes. Set `tipo` to `cnae`, `municipio` or `natureza`. | Free |
| `ia_filters` | `POST /api/ia` | Turn a plain-language request into search filters. It takes about 20 seconds. | Free |
| `avaliar` | `POST /api/avaliar` | Map a business idea and place to a CNAE. Count active, opened and closed companies. | Free |
| `reveal_cnpj` | `POST /api/revelar/{cnpj}` | Show partner names, phones and e-mail without the mask. | Per company; read `pricing` |
| `dossier_cnpj` | `POST /api/dossie/{cnpj}` | Get the company dossier with the live misconduct check and a risk light. | Per company |
| `add_watch` / `list_watches` | `/api/me/monitor/watch(es)` | Monitor a CNPJ for changes. Send a prepaid credit token in `credito`. | 10 free, then per CNPJ |
| `consulta_planos` | `GET /api/consulta` | Read the free allowance of today, the plans and your balance. | Free |
| `consulta_comprar` | `POST /api/consulta/planos/{oferta}` | Buy a lookup pack or plan. | Paid |
| `pricing` | `GET /api/pricing` | Read the current prices and free allowances. | Free |
| `health` | `GET /api/health` | Read the date of the Receita data (`import.dump_date`). | Free |

## Rules

1. Start with the free tools. Use `get_cnpj` or `search` before a paid lookup.
2. Before a call that spends money or balance, read the price from `pricing` or `consulta_planos`.
   Do not use a price from memory.
3. Do not buy, pay or reveal personal data until the user approves the item and the amount.
4. If a call returns HTTP 402, show the offer and the price to the user. After approval, pay and send the
   same call again:
   - with a prepaid credit token: header `Authorization: Bearer cred_…`, or the `credito` or
     `credit_token` tool argument;
   - with x402: pay one entry of `accepts[]` (USDC on Base) and send the `X-PAYMENT` header.
5. When you retry a paid call, keep the same `Idempotency-Key` or the same `compra` mark.
   The service does not charge the same request twice.
6. Keep tokens (`cred_…`, `mmk_…`) secret. Do not write them in files, logs or answers.
7. Partner names, phones and e-mails are personal data under the Brazilian data protection law (LGPD).
   Use them only for the legitimate purpose that the user states.
   Do not use them for unsolicited marketing or for automated decisions about people.
8. Give the source date with each answer. A count shows registered companies (supply).
   It does not show demand, revenue or search volume.
9. Lists return up to 20 items per page. Follow `links.proximo`. Do not guess IDs. Do not scrape HTML pages.
10. If you get HTTP 429 or 503, wait for the time in `Retry-After` and try once more.

## Pay

- Prepaid credit: `POST https://radar-cnpj.com/api/credito?usd=5` returns 402. After the payment, it returns
  a `cred_…` token one time only. The same token works in Radar CNPJ, PontoFato and EditalMD.
- Pix in reais (Brazil): `GET https://radar-cnpj.com/api/credito/pix` gives the packs and the steps.
- Lookup plans: `consulta_planos` lists them and `consulta_comprar` buys one. Plans do not renew automatically.
- People can see prices and pay at https://radar-cnpj.com/pricing.

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

- Radar CNPJ is not an official certificate. The data is the public Receita Federal dump and the listed
  public databases, each with its date.
- The free CNPJ record has an edge cache of 6 hours.
- Terms: https://radar-cnpj.com/termos. Privacy: https://radar-cnpj.com/privacidade.
  Contact: contato@radar-cnpj.com.
