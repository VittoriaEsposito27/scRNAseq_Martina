# Usa l'immagine base di R con una versione specifica (adatta alla tua necessità)
FROM rocker/r-ver:latest

# Aggiorna i pacchetti di sistema e installa le dipendenze necessarie per R e RStudio
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libhdf5-dev \
    pandoc \
    gdebi-core && \
    rm -rf /var/lib/apt/lists/*

# Scarica e installa RStudio Server
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-latest-amd64.deb && \
    gdebi -n rstudio-server-latest-amd64.deb && \
    rm rstudio-server-latest-amd64.deb

# Installa BiocManager per pacchetti Bioconductor
RUN R -e "install.packages('BiocManager')"

# Installa pacchetti CRAN
RUN R -e "install.packages(c('tidyverse', 'viridis', 'gghalves', 'cowplot', 'patchwork', 'gridExtra', 'hdf5r', 'parallel', 'stringi', 'stringr'))"

# Installa pacchetti Bioconductor
RUN R -e "BiocManager::install(c('Seurat', 'SeuratObject', 'scran', 'scater', 'scDblFinder', 'SoupX', 'harmony'))"

# Crea un utente non-root per eseguire RStudio
RUN useradd -m rstudio_user && \
    echo "rstudio_user:rstudio" | chpasswd && \
    adduser rstudio_user sudo

# Configura RStudio per funzionare sulla porta 8787 senza autenticazione
RUN echo "www-port=8787" >> /etc/rstudio/rserver.conf && \
    echo "auth-none=1" >> /etc/rstudio/rserver.conf

# Espone la porta per l’accesso a RStudio
EXPOSE 8787

# Imposta l'utente di default per il container
USER rstudio_user

# Comando per avviare RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]
