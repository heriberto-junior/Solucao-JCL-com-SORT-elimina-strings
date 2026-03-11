## Solucao-JCL-com-SORT-elimina-strings

### Visão geral do job
O job executa três etapas encadeadas para produzir um arquivo final contendo:

1 - o cabeçalho original do arquivo de entrada,
2 - os registros úteis (dados de job), sem linhas de status e sem duplicados
3 - os registros ordenados por campos definidos.

Para isso, utiliza um dataset temporário intermediário, que primeiro recebe o cabeçalho e depois os registros filtrados e ordenados, e por fim é copiado para o dataset definitivo.

---

### Etapa 1 — Cópia do cabeçalho para temporário
O STEP 1 do JCL copia apenas as 3 primeiras linhas do arquivo de entrada para um arquivo temporário chamado `&&COPYTMP` utilizando as funções de SORT `COPY` e `STOPAFT=3` que serve para interromper a leitura após exatamente 3 registros. Essas 3 linhas do arquivo de entrada são um cabeçalho que precisam ser mantidas.

---

### Etapa 2 — Filtragem e ordenação do detalhe
O STEP 2 do JCL utiliza o mesmo arquivo de entrada, utiliza a função do SORT `SKIPREC=3` para ignorar os 3 primeiros registros, a função `OMIT COND` para omitir as strings, sendo as linhas de 1 a 5 com READY e as linhas de 1 a 3 com END, filtra com `SORT FIELDS` primeiro por RC (28,4,CH,A) e depois por USER (10,7,CH,A). Por fim, elimina duplicados com o `SUM FIELDS=NONE`. O resultado é copiado com `MOD` para o temporário `&&COPYTMP`, ou seja, mantém o cabeçalho e copia o resultado do segundo step.

---

### Etapa 3 — Geração do dataset final

Utiliza a função `IEBGENER` para copiar o particionado temporário `&&COPYTMP` para um particionado de saída contendo o resultado.
