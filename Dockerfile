FROM rocker/verse:4.2.2

# Install BiocManager
RUN R -e "install.packages('BiocManager')"

# Install CRAN packages
RUN R -e "install.packages(c('tidyverse', 'viridis', 'gghalves', 'cowplot', 'patchwork', 'gridExtra', 'hdf5r', 'parallel', 'stringi', 'stringr'))"

# Install Bioconductor packages
RUN R -e "BiocManager::install(c('Seurat', 'SeuratObject', 'scran', 'scater', 'scDblFinder', 'SoupX', 'BiocGenerics', 'harmony'))"

# Expose the RStudio port
EXPOSE 8787

# Start RStudio server
CMD ["/usr/bin/render-demo"]
