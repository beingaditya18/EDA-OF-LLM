### Install required packages (only run once)
packages <- c("tidyverse", "DataExplorer", "ggcorrplot", "viridis", "knitr")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

### Load libraries
library(tidyverse)       # Includes ggplot2, dplyr, tidyr, readr, etc.
library(DataExplorer)    # For plot_missing()
library(ggcorrplot)      # For correlation plots
library(viridis)         # For better color palettes in plots
library(knitr)           # For better table output (optional)

### Load dataset
data <- read.csv("llm_comparison_dataset.csv")

### Peek at the structure
glimpse(data)

### Summary statistics
summary(data)

### Visualize missing data
plot_missing(data)

### Select numeric columns
num_cols <- sapply(data, is.numeric)
data_num <- data[, num_cols]

### Reshape numeric data for plotting
hist_data <- pivot_longer(as.data.frame(data_num), cols = everything(), 
                          names_to = "Feature", values_to = "Value")

### Plot histograms for numeric features
ggplot(hist_data, aes(x = Value)) +
  facet_wrap(~ Feature, scales = "free", ncol = 3) +
  geom_histogram(bins = 30, fill = "#56B4E9", color = "white", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Numeric Features", x = "Value", y = "Frequency") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        strip.text = element_text(face = "bold"))

### Select categorical columns
data_cat <- data %>% select_if(is.character)

### Reshape categorical data for plotting
bar_data <- pivot_longer(data_cat, cols = everything(), 
                         names_to = "Feature", values_to = "Category")

### Plot bar charts for categorical features
ggplot(bar_data, aes(y = Category)) +
  facet_wrap(~ Feature, scales = "free_y", ncol = 2) +
  geom_bar(fill = "#E69F00", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Categorical Features", x = "Count", y = "Category") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        strip.text = element_text(face = "bold"))

### Correlation matrix of numeric features
corr <- cor(data_num, use = "pairwise.complete.obs")

ggcorrplot(corr, hc.order = TRUE, type = "lower", lab = TRUE,
           lab_size = 3, method = "circle",
           colors = c("tomato2", "white", "springgreen3"),
           title = "Correlation Matrix of Numeric Features",
           ggtheme = theme_minimal()) +
  theme(plot.title = element_text(hjust = 0.5))

### Boxplot: Quality Rating by Provider
ggplot(data, aes(x = Provider, y = Quality.Rating, fill = Provider)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  scale_fill_viridis(discrete = TRUE, option = "D") +
  labs(title = "Quality Rating by Provider", y = "Quality Rating", fill = "Provider") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

### Scatter: Speed vs Latency by Model
ggplot(data, aes(x = Speed..tokens.sec., y = Latency..sec., color = Model)) +
  geom_point(size = 3, alpha = 0.7) +
  theme_minimal() +
  scale_color_viridis(discrete = TRUE, option = "C") +
  labs(title = "Speed vs Latency", x = "Speed (tokens/sec)", y = "Latency (sec)", color = "Model") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))

### Price vs MMLU Benchmark by Open Source
ggplot(data, aes(x = Price...Million.Tokens, y = Benchmark..MMLU., color = Open.Source)) +
  geom_point(size = 3, alpha = 0.7) +
  theme_minimal() +
  scale_color_manual(values = c("TRUE" = "#4daf4a", "FALSE" = "#e41a1c")) +
  labs(title = "Price vs MMLU Benchmark",
       x = "Price per Million Tokens",
       y = "MMLU Score",
       color = "Open Source") +
  theme(plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))

### Average numeric features by Open Source status
open_source_comparison <- data %>%
  group_by(Open.Source) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

print(open_source_comparison)

### Top 5 models by Quality Rating
top_5_models <- data %>%
  arrange(desc(Quality.Rating)) %>%
  select(Model, Provider, Quality.Rating, Benchmark..MMLU., `Price...Million.Tokens`) %>%
  head(5)

print(top_5_models)
