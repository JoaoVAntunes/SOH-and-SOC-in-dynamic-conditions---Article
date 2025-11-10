# Pacotes necessários
library(vroom)

# Diretórios
dir_raw <- "C:/Users/joaov/Desktop/Workspace/3º ano/6_periodo/pesquisa aplicada/Simulation Data/DataRaw"
dir_curated <- "C:/Users/joaov/Desktop/Workspace/3º ano/6_periodo/pesquisa aplicada/Simulation Data/DataCurated"

# Cria diretório de saída se não existir
if (!dir.exists(dir_curated)) dir.create(dir_curated)

# Índices das colunas que você quer manter (ajuste conforme a posição real no seu CSV)
# Caso as colunas estejam em ordem diferente, podemos usar nomes no lugar depois
cols_keep_idx <- c(
  1,  # Time [s]
  2,  # Ambient Temperature [C]
  3,  # Longitudinal Acceleration [m/s²]
  4,  # Speed [m/s]
  5,  # Traction Force [N]
  6,  # Drive Power [W]
  7,  # Drive Torque [Nm]
  8,  # Drive Current [A]
  9,  # EM Power [kW]
  10, # Pack Voltage [V]
  11, # Battery Current [A]
  12, # Power [kW]
  13, # SOC [%]
  14, # Ageing SOH [-]
  15, # Mean Cell Temperature [C]
  16, # Heating Power [kW]
  17, # Heatexchanger Inlet Coolant Temp [C]
  18, # Heatexchanger Outlet Air Temp [C]
  19  # Auxiliaries Total [W]
)

# Lista todos os arquivos CSV
files <- list.files(dir_raw, pattern = "\\.csv$", full.names = TRUE)

# Loop de processamento
for (f in files) {
  message("Processando: ", basename(f))
  
  # Lê o arquivo inteiro, mas apenas as colunas de interesse
  df <- tryCatch({
    vroom::vroom(
      f,
      delim = ";",
      col_select = cols_keep_idx,
      locale = vroom::locale(encoding = "latin1"),
      progress = FALSE
    )
  }, error = function(e) {
    message("❌ Erro ao processar ", basename(f), ": ", e$message)
    return(NULL)
  })
  
  if (!is.null(df)) {
    # Exporta CSV limpo com ';' como separador
    outfile <- file.path(dir_curated, basename(f))
    vroom::vroom_write(df, outfile, delim = ";")
    
    # Libera memória
    rm(df)
    gc()
  }
}

message("✅ Limpeza concluída! Arquivos de simulação salvos em: ", dir_curated)
