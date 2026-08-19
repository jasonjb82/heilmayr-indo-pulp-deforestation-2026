FROM --platform=linux/amd64 rocker/geospatial:4.4.2

# Set WORKDIR 
WORKDIR /home/rstudio/heilmayr-indo-pulp-deforestation-2026

# Set up global renv library cache directory
ENV RENV_PATHS_LIBRARY=/renv/library
RUN mkdir -p /renv/library

# Copy dependency definition files first for Docker caching
COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R
COPY .Rprofile .Rprofile

# Restore R packages during build (cached unless renv.lock changes)
RUN Rscript -e "options(renv.config.sandbox = FALSE); renv::restore(prompt = FALSE)"

# Copy rest of codebase (R/, _targets.R, data/, etc.)
COPY . .

# Execute targets pipeline immediately when container runs
CMD ["Rscript", "-e", "targets::tar_make(callr_function = NULL)"]