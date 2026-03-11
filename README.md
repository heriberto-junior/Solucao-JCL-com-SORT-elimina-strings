# Solucao-JCL-com-SORT-elimina-strings

# Visão geral do job
O job executa três etapas encadeadas para produzir um arquivo final contendo:

1 - o cabeçalho original do arquivo de entrada,
2 - os registros úteis (dados de job), sem linhas de status e sem duplicados
3 - os registros ordenados por campos definidos.

Para isso, utiliza um dataset temporário intermediário, que primeiro recebe o cabeçalho e depois os registros filtrados e ordenados, e por fim é copiado para o dataset definitivo.

# Etapa 1 — Cópia do cabeçalho para temporário
O STEP 1 do JCL copia apenas as 3 primeiras linhas do arquivo de entrada para um arquivo temporário chamado `&&COPYTMP utilizando as funções de SORT `COPY e `STOPAFT=3 que serve para interromper a leitura após exatamente 3 registros. Essas 3 linhas do arquivo de entrada são um cabeçalho que precisam ser mantidas.

---

# Etapa 2 — Filtragem e ordenação do detalhe
O STEP 2 do JCL utiliza o mesmo arquivo de entrada, utiliza a função do SORT `SKIPREC=3 para ignorar os 3 primeiros registros

---

# Etapa 3 — Geração do dataset final

Objetivo: mover o conteúdo consolidado do temporário (cabeçalho + ordenado) para o dataset final.
Como faz: executa uma cópia simples, sem reprocessar ou alterar os dados.
Atributos físicos: garante que o dataset de saída tenha o mesmo formato de registro fixo e o mesmo tamanho de registro (LRECL) utilizados no temporário, mantendo a compatibilidade.


Detalhes úteis (comportamento e ajustes comuns)

Dataset temporário: é criado com tempo de vida apenas dentro do job; é passado de um step para o outro e liberado ao final da execução.
Compatibilidade de layout: cabeçalho e registros de detalhe compartilham o mesmo LRECL; isso é importante para não quebrar a cópia final.
Campos de ordenação: a chave usa posições absolutas dentro do registro (caracteres), adequadas a um layout do tipo JOB;USR;STEP;RC. Se o layout mudar (largura do campo, pontos-e-vírgulas, etc.), é preciso ajustar as posições da chave.
Filtro de linhas de status: a lógica exclui linhas que começam com certas palavras (“READY”, “END”). Se surgirem outras marcas de controle no arquivo, inclua-as no filtro.
Cabeçalho com tamanho diferente: se o cabeçalho tiver outra quantidade de linhas, ajuste em conjunto: o limite de cópia na etapa 1 e o salto de linhas na etapa 2 devem ter o mesmo número.
Desempenho/recursos: parâmetros de classe, região e alocação (unidade/SPACE) estão dimensionados para um volume pequeno/moderado. Para volumes maiores, aumente os extents e o SPACE.
Auditoria: as mensagens do utilitário de sort no SYSOUT indicam quantos registros foram lidos, omitidos e gravados — útil para validar a efetividade do filtro e da ordenação.
