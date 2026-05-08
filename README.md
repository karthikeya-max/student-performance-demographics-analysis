# Student Performance Demographics Analysis

## Overview
This repository contains the R script and dataset used to evaluate the statistical impact of unalterable demographic factors specifically gender and parental educational background on student academic performance in Mathematics and Language.

## Objective
The primary goal of this project is to determine if subject-specific mastery is gendered and to statistically quantify the "educational penalty" or "boost" associated with a parent's highest level of education.

## Methodology
The analysis assumes a quantitative approach, employing both descriptive and inferential parametric statistics to answer the core research questions:
* **Exploratory Data Analysis (EDA):** Density curves and grouped boxplots generated via `ggplot2` to assess data normality, central tendency, and dispersion.
* **Welch's Two-Sample T-Tests:** To rigorously evaluate gender-based performance differences while accounting for potential heteroscedasticity.
* **One-Way ANOVA & Tukey HSD:** To evaluate main effects and isolate specific pairwise differences across four distinct parental education tiers.
* **Two-Way ANOVA:** To test for compounding interaction effects between gender and education.

## Tech Stack & Reproducibility
* **Language:** R (Version 4.5.1)
* **Core Libraries:** `ggplot2`, `dplyr`, `tidyr`, `readr`, `e1071`, `openxlsx`

## Repository Structure
* `analysis_script.R`: The complete, heavily commented master script containing all data preprocessing, statistical hypothesis testing, and graphic generation code.
* `Scores(2).csv`: The foundational dataset used for the analysis.

## How to Run
1. Clone this repository or download the files locally.
2. Ensure `Scores(2).csv` is located in your active working directory.
3. Open `analysis_script.R` in RStudio.
4. Run the script sequentially. All required dependencies are clearly listed at the top of the script for easy installation.
