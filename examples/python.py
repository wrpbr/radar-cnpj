import requests

r = requests.get("https://radar-cnpj.com/api/cnpj/33000167000101", timeout=30).json()
print(r["data"]["razaoSocial"], r["data"]["situacao"]["label"])

b = requests.get("https://radar-cnpj.com/api/busca", params={"q": "padaria", "uf": "DF"}, timeout=30).json()
for e in b["results"][:5]:
    print(e["cnpjFormatted"], e["razaoSocial"], e["situacao"]["label"])
