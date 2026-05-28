# Student Performance Demographics Analysis

## Overview
This repository contains the R script and dataset used to evaluate the statistical impact of demographic factors, specifically gender and parental educational background, on student academic performance in Mathematics and Language.

## Objective
The primary goal of this project is to determine if subject-specific mastery is gendered and to statistically quantify the academic advantage associated with a student's home environment, specifically their parent's highest level of education.

## Methodology
This analysis utilizes a robust, parametric statistical approach to answer the core research questions:
* **Exploratory Data Analysis (EDA):** Histograms and grouped boxplots generated via `ggplot2` to assess data distribution, central tendency, dispersion, and outliers.
* **Assumption Testing:** The Shapiro-Wilk test was applied to model residuals (with deviations addressed via the Central Limit Theorem due to a large sample size). Levene's Test was utilized to explicitly confirm the assumption of homoscedasticity across subgroups.
* **Two-Way Analysis of Variance (ANOVA):** To simultaneously evaluate the main effects of gender and parental education, as well as their interaction effect, on academic performance in both subjects.
* **Post-Hoc Analysis:** Tukey's Honest Significant Difference (HSD) test was applied to isolate the exact source of diverging performance among education levels while mathematically controlling for family-wise Type I error rates.

## Tech Stack & Reproducibility
* **Language:** R (Version 4.5.1 or newer recommended)
* **Core Libraries:** `dplyr`, `tidyr`, `ggplot2`, `moments`, `car`

## Repository Structure
* `analysis.R`: The complete, heavily commented master script containing all data preprocessing, parametric hypothesis testing, and graphical rendering code.
* `Scores(2).csv`: The foundational dataset used for the analysis.

## How to Run
1. Clone this repository or download the files locally.
2. Ensure both `Scores(2).csv` and `analysis.R` are located in the same working directory.
3. Open `analysis.R` in RStudio or your preferred R environment.
4. Highlight and run the entire script to replicate the data cleaning, visualizations, and inferential statistical outputs.
