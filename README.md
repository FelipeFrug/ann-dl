# ann-dl — Redes Neurais (Insper 2026.2)

Entregas da disciplina, publicadas com GitHub Pages.

**Site:** https://felipefrug.github.io/ann-dl/

## Atividades

| Atividade | Página publicada | Fonte |
|---|---|---|
| **Data** — Geometria e Preparação de Dados | https://felipefrug.github.io/ann-dl/exercises/data/ | [`exercises/data/`](exercises/data/) |

A atividade *Data* reúne três exercícios em uma página única:

- **Exercício 1 — Nuvens de Pontos:** geometria e dispersão em 2D (razão de
  separação, taxa de mistura, fronteiras de decisão).
- **Exercício 2 — Não-Linearidade em 5D:** gaussianas deslocadas vs. cascas
  concêntricas (PCA, variância explicada, histograma de raios).
- **Exercício 3 — Dados Reais:** pré-processamento do Spaceship Titanic
  (split estratificado sem vazamento, imputação, one-hot, `TotalSpend`,
  `log(1+x)`, padronização) para uma rede com ativação `tanh`.
- **Resumo dos resultados** ao final, cobrindo os três exercícios.

## Estrutura do repositório

```
.
├── index.html                        capa da disciplina (/ann-dl/)
├── build.sh                          regera o HTML de um exercício
├── requirements.txt                  numpy, pandas, matplotlib, scikit-learn, jupyter
├── .nojekyll                         serve o HTML como está, sem passar pelo Jekyll
└── exercises/
    └── data/
        ├── index.ipynb               fonte: gera os dados, calcula e analisa
        ├── index.html                notebook executado — é o que o Pages serve
        └── dataset/train.csv         dados do Exercício 3
```

## Regerando uma página

```bash
./build.sh
```

Constrói `exercises/data` por padrão; passe outro caminho para construir outro
exercício (`./build.sh exercises/outro`). O script cria o `.venv` na primeira
execução e roda `jupyter nbconvert --to html --execute`, que executa o notebook
do zero e embute as figuras (PNG em base64) no HTML. O arquivo é autocontido:
não depende de nenhum asset externo, exceto o MathJax (CDN) para renderizar as
equações em LaTeX.

Para editar:

```bash
.venv/bin/jupyter lab exercises/data/index.ipynb
```

Depois rode `./build.sh` e faça o commit do `.ipynb` e do `.html`.

## Dados

O Exercício 3 usa o `train.csv` da competição
[Spaceship Titanic](https://www.kaggle.com/competitions/spaceship-titanic) do
Kaggle — o único arquivo rotulado. Está versionado em
`exercises/data/dataset/train.csv` (8693 passageiros, 14 colunas).

> Fonte: Addison Howard, Ashley Chow e Ryan Holbrook, *Spaceship Titanic*,
> Kaggle, 2022. Licença
> [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## Reprodutibilidade

- semente fixa com `rng = np.random.default_rng(42)`, e **um único objeto `rng`**
  reutilizado em todas as amostragens do relatório;
- por isso o notebook precisa ser executado de cima para baixo — é o que o
  `nbconvert --execute` faz. Rodar células fora de ordem muda a sequência de
  sorteios;
- os exercícios compartilham esse `rng`: o Exercício 2 dá sequência ao fluxo
  aleatório iniciado no Exercício 1;
- no Exercício 3, o `train_test_split` do scikit-learn não aceita um
  `np.random.Generator` em `random_state` (só inteiro ou `RandomState`), então é
  passada a mesma semente 42;
- todo `.fit()` do Exercício 3 vê apenas o conjunto de treino — ao teste se
  aplica só `.transform()`. Nenhuma estatística é calculada sobre o dataset
  completo;
- bibliotecas de análise: `numpy`, `pandas`, `matplotlib` e `scikit-learn` —
  este último só para o `PCA` do Exercício 2 e o pré-processamento do
  Exercício 3. **Nenhum modelo é treinado.** O `jupyter`/`nbconvert` entra
  apenas como ferramenta de build.

## Uso de IA

O relatório foi produzido com apoio do Claude (Anthropic) na escrita do código,
na geração das figuras e na redação das análises, conforme declarado na própria
página.
