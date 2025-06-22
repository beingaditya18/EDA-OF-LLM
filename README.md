# LLM Comparison Data Analysis

Analyze and visualize various Large Language Models (LLMs) using R and the provided CSV dataset.

## Dataset

- **File:** `llm_comparison_dataset.csv`  
  Comparative data on LLM providers, models, ratings, benchmarks, pricing, speed, latency, and open source status.

## Setup

Install required packages in R:

```r
packages <- c("tidyverse", "DataExplorer", "ggcorrplot", "viridis", "knitr")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
```

Load libraries:

```r
library(tidyverse)
library(DataExplorer)
library(ggcorrplot)
library(viridis)
library(knitr)
```

## Usage

1. Load the data:
    ```r
    data <- read.csv("llm_comparison_dataset.csv")
    ```

2. Explore and visualize:
    - Use `glimpse(data)`, `summary(data)`, `plot_missing(data)`
    - Plot distributions, correlations, and comparisons (see script for details)

3. Example plots:
    - Histograms and bar charts for numeric/categorical features
    - Correlation matrix (`ggcorrplot`)
    - Boxplots, scatterplots by provider/model/open source status

## Notes

- Make sure the CSV is in your working directory.
- Adjust scripts if your column names differ.


MIT License
