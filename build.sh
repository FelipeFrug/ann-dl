#!/usr/bin/env bash
# Regera o index.html de um exercício a partir do seu index.ipynb,
# executando o notebook do zero.
#
#   ./build.sh                      # constrói exercises/data
#   ./build.sh exercises/outro      # constrói outro exercício
set -euo pipefail
cd "$(dirname "$0")"

EXERCICIO="${1:-exercises/data}"
TITULO_PADRAO="Exercícios 1–3 — Geometria e Preparação de Dados | Redes Neurais"

if [ ! -f "$EXERCICIO/index.ipynb" ]; then
  echo "erro: $EXERCICIO/index.ipynb não encontrado" >&2
  exit 1
fi

if [ ! -d .venv ]; then
  echo "criando .venv..."
  python3 -m venv .venv
  .venv/bin/pip install --quiet --upgrade pip
  .venv/bin/pip install --quiet -r requirements.txt
fi

# --execute roda o notebook com o cwd na pasta dele, então os caminhos
# relativos de dentro do notebook (dataset/train.csv) resolvem corretamente.
.venv/bin/jupyter nbconvert --to html --execute \
  --output index.html "$EXERCICIO/index.ipynb"

# nbconvert usa o nome do arquivo como <title>; trocamos por um título legível
.venv/bin/python - "$EXERCICIO/index.html" "$TITULO_PADRAO" <<'PY'
import re, sys, pathlib
caminho, titulo = sys.argv[1], sys.argv[2]
p = pathlib.Path(caminho)
html = p.read_text(encoding="utf-8")
html, n = re.subn(r"<title>.*?</title>", f"<title>{titulo}</title>", html,
                  count=1, flags=re.S)
if n != 1:
    sys.exit("erro: tag <title> não encontrada em " + caminho)
p.write_text(html, encoding="utf-8")
PY

echo "$EXERCICIO/index.html atualizado."
