# Usa l'immagine ufficiale di RStudio e R
FROM rocker/rstudio:latest

# Aggiorna i pacchetti di sistema e installa alcune dipendenze necessarie
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

# Installa BiocManager per poter installare pacchetti Bioconductor
RUN R -e "install.packages('BiocManager')"

# Installa i pacchetti CRAN
RUN R -e "install.packages(c('tidyverse', 'viridis', 'gghalves', 'cowplot', 'patchwork', 'gridExtra', 'hdf5r', 'parallel', 'stringi', 'stringr'))"

# Installa i pacchetti Bioconductor
RUN R -e "BiocManager::install(c('Seurat', 'SeuratObject', 'scran', 'scater', 'scDblFinder', 'SoupX', 'BiocGenerics', 'harmony'))"

# Crea un utente di default per RStudio
RUN useradd -m rstudio_user && \
    echo "rstudio_user:password" | chpasswd && \
    adduser rstudio_user sudo

# Rendi l’utente rstudio_user proprietario della directory
RUN chown -R rstudio_user:rstudio_user /home/rstudio_user

# Espone la porta per l’accesso a RStudio
EXPOSE 8787

# Specifica l'utente di default per eseguire RStudio
USER rstudio_user
