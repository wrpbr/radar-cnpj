#!/usr/bin/env bash
# Radar CNPJ — free calls, no account. Chamadas grátis, sem cadastro.
set -euo pipefail

# Ficha completa pelo CNPJ (cache de 6 h)
curl -s https://radar-cnpj.com/api/cnpj/33000167000101

# Busca por termo e UF
curl -s 'https://radar-cnpj.com/api/busca?q=padaria&uf=DF'

# Vocabulário oficial (CNAE, município ou natureza)
curl -s 'https://radar-cnpj.com/api/ref?tipo=cnae&q=padaria'

# Avaliação de ideia
curl -s -X POST https://radar-cnpj.com/api/avaliar -H 'content-type: application/json' -d '{"texto":"padaria em Águas Claras"}'
