# Replication Package: Indonesia’s pulp sector risks reversing progress towards zero deforestation

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21542417.svg)](https://doi.org/10.5281/zenodo.21542417)
[![R-CMD-check](https://img.shields.io/badge/R-4.4.2-blue.svg)](https://www.r-project.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)

This repository contains the complete code, targets pipeline, and replication materials for:

> **Heilmayr, R., Benedict, J. J., Orland, B., Afif, H., Barr, C., Descals, A., Husnayaen, H., Kridalaksana, A., Manurung, T., Nagara, G., & Gaveau, D. (2026).** *Indonesia’s pulp sector risks reversing progress towards zero deforestation.* Science. [Zenodo Archive](https://doi.org/10.5281/zenodo.21542417).

---

## Overview

This repository uses the [`targets`](https://docs.ropensci.org/targets/) workflow management package alongside [`renv`](https://rstudio.github.io/renv/) to construct an automated, fully reproducible pipeline analyzing deforestation, concession licensing, and corporate supply chain dynamics in Indonesia's pulpwood sector.

The pipeline fetches raw spatial and tabular data from Zenodo, executes all spatial overlay and statistical transformations, and generates the relevant summary figures and SI tables reported in the paper.

---

## Repository Structure

```text
.
├── R/                         # Custom modularized R functions powering targets
├── _targets.R                 # Main targets pipeline workflow definition
├── renv.lock                  # Lockfile pinning exact R package versions
├── Dockerfile                 # Container image specification for isolated builds
├── .dockerignore              # Rules to exclude large data files from Docker context
├── README.md                  # Replication documentation
└── remote/                    # Local storage for raw Zenodo replication data
```

---

## Data Availability & Automation

All required raw input files are archived on Zenodo ([DOI: 10.5281/zenodo.21542417](https://doi.org/10.5281/zenodo.21542417)).

You do not need to download raw datasets manually. The `zenodo_data_check` target in `_targets.R` automatically checks for local data and downloads `01_data_replication.zip` into `remote/01_data_replication/` during the first pipeline execution if files are absent.

---

## System & Hardware Requirements

* **RAM**: Minimum 16 GB recommended due to memory-intensive spatial operations (`sf`, `terra`).
* **Disk Space**: ~10 GB free space for raw zip downloads and `targets` cache files.
* **Software**: R (≥ 4.4.2) or Docker Desktop.

---

## Platform-Specific Notes

### macOS (Apple Silicon M1/M2/M3/M4)
* **Docker Architecture**: Build using x86_64 emulation if targeting Intel-based servers:
  ```bash
  docker build --platform linux/amd64 -t test-indo-defor .
  ```
* **Memory Allocation**: Docker Desktop defaults to 2 GB RAM, which cause container crashes (`Killed`) during spatial overlays. Set **Settings > Resources > Memory** to at least **8 GB – 12 GB**.
* **Local R Execution**: Requires Homebrew installation of spatial libraries (`gdal`, `geos`, `proj`) prior to compiling `sf` or `terra` locally.

### Windows (10/11)
* **Long Paths**: Enable Long Paths in Git/Windows if encountering file path length issues during zip extraction:
  ```bash
  git config --global core.longpaths true
  ```
* **Line Endings**: Set Git to preserve LF line endings:
  ```bash
  git config --global core.autocrlf input
  ```

### Linux (Ubuntu / Debian)
* **System Libraries**: For local R execution outside Docker, ensure C++ spatial headers are installed:
  ```bash
  sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev
  ```

---

## Replication Instructions

You can execute the replication workflow through an interactive R session or inside an isolated Docker container.

### Option A: Local R Session (Recommended for Interactive Development)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jasonjb82/heilmayr-indo-pulp-deforestation-2026.git
   cd heilmayr-indo-pulp-deforestation-2026
   ```

2. **Restore package dependencies:**
   In your R/Positron console, run:
   ```R
   renv::restore()
   ```

3. **Inspect the pipeline graph (Optional):**
   ```R
   targets::tar_visnetwork()
   ```

4. **Run the replication pipeline:**
   ```R
   targets::tar_make()
   ```

Generated output figures, tables, and text statistics will automatically be saved into the `output/` directory.

---

### Option B: Docker Container (Fully Isolated Execution)

To build and run the pipeline inside a self-contained Linux environment:

1. **Build the Docker image:**
   ```bash
   docker build -t test-indo-defor .
   ```

2. **Run the container pipeline:**
   ```bash
   docker run --rm test-indo-defor
   ```

## Authors & Citation

**Authors:**
Robert Heilmayr, Jason Jon Benedict, Brian Orland, Hilman Afif, Christopher Barr, Adrià Descals, Husnayaen Husnayaen, Age Kridalaksana, Timer Manurung, Grahat Nagara, David Gaveau

**Suggested Citation:**
```bibtex
@article{heilmayr_2026_indonesia_pulp,
  title={Indonesia’s pulp sector risks reversing progress towards zero deforestation},
  author={Heilmayr, Robert and Benedict, Jason Jon and Orland, Brian and Afif, Hilman and Barr, Christopher and Descals, Adri{\a} and Husnayaen, Husnayaen and Kridalaksana, Age and Manurung, Timer and Nagara, Grahat and Gaveau, David},
  journal={Science},
  year={2026},
  doi={10.5281/zenodo.21542417}
}
```

## License

The code in this repository is open-source under the [MIT License](LICENSE). Input datasets are provided under creative commons licenses as specified on Zenodo.
