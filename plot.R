library(vroom)
library(ggcorrplot)
library(dplyr)
library(janitor)
library(tidyr)

# 📂 Caminho do arquivo (ajuste o nome conforme seu caso)
arquivo <- "C:/Users/joaov/Desktop/Workspace/3º ano/6_periodo/pesquisa aplicada/Simulation Data/DataCurated/0_Mixed_CAN.csv"

# 🧹 Leitura do CSV
df <- vroom::vroom(
  arquivo,
  delim = ";",
  skip = 1,
  locale = vroom::locale(encoding = "latin1"),
  progress = FALSE
)

# 🧾 Limpeza leve dos nomes das colunas (minúsculas, sem acentos)
df <- df %>% janitor::clean_names()

# 💡 Remover colunas não numéricas (texto, fatores)
df_num <- df %>% select(where(is.numeric))

# Identifica as colunas com desvio padrão igual a zero
cols_sd_zero <- df_num %>%
  summarise(across(everything(), ~ sd(., na.rm = TRUE))) %>%
  pivot_longer(everything(), names_to = "coluna", values_to = "desvio_padrao") %>%
  filter(desvio_padrao == 0)

print("Colunas com desvio padrão zero:")
print(cols_sd_zero)

# ⚙️ Remove colunas com desvio padrão igual a zero
df_num <- df_num %>%
  select(where(~ sd(., na.rm = TRUE) > 0))

# 🔢 Calcular matriz de correlação (Pearson)
corr_matrix <- cor(df_num, use = "pairwise.complete.obs", method = "pearson")

# 🔢 Calcular matriz de correlação (Spearman) — corrigido para usar df_num
corr_spearman <- cor(df_num, use = "pairwise.complete.obs", method = "spearman")

# 🎨 Plot do mapa de correlação - Pearson
ggcorrplot(
  corr_matrix,
  hc.order = FALSE,
  type = "full",
  lab = TRUE,
  lab_size = 2.5,
  title = "Mapa de Correlação - Pearson",
  tl.cex = 8,
  tl.srt = 45
)

# 🎨 Plot do mapa de correlação - Spearman
ggcorrplot(
  corr_spearman,
  hc.order = FALSE,
  type = "full",
  lab = TRUE,
  lab_size = 2.5,
  title = "Mapa de Correlação - Spearman",
  tl.cex = 8,
  tl.srt = 45
)

